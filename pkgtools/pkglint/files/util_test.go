package main

import (
	check "gopkg.in/check.v1"
	"netbsd.org/pkglint/regex"
	"netbsd.org/pkglint/textproc"
	"testing"
)

func (s *Suite) Test_MkopSubst__middle(c *check.C) {
	c.Check(mkopSubst("pkgname", false, "kgna", false, "ri", ""), equals, "prime")
	c.Check(mkopSubst("pkgname", false, "pkgname", false, "replacement", ""), equals, "replacement")
}

func (s *Suite) Test_MkopSubst__left(c *check.C) {
	c.Check(mkopSubst("pkgname", true, "kgna", false, "ri", ""), equals, "pkgname")
	c.Check(mkopSubst("pkgname", true, "pkgname", false, "replacement", ""), equals, "replacement")
}

func (s *Suite) Test_MkopSubst__right(c *check.C) {
	c.Check(mkopSubst("pkgname", false, "kgna", true, "ri", ""), equals, "pkgname")
	c.Check(mkopSubst("pkgname", false, "pkgname", true, "replacement", ""), equals, "replacement")
}

func (s *Suite) Test_MkopSubst__leftRight(c *check.C) {
	c.Check(mkopSubst("pkgname", true, "kgna", true, "ri", ""), equals, "pkgname")
	c.Check(mkopSubst("pkgname", false, "pkgname", false, "replacement", ""), equals, "replacement")
}

func (s *Suite) Test_MkopSubst__gflag(c *check.C) {
	c.Check(mkopSubst("aaaaa", false, "a", false, "b", "g"), equals, "bbbbb")
	c.Check(mkopSubst("aaaaa", true, "a", false, "b", "g"), equals, "baaaa")
	c.Check(mkopSubst("aaaaa", false, "a", true, "b", "g"), equals, "aaaab")
	c.Check(mkopSubst("aaaaa", true, "a", true, "b", "g"), equals, "aaaaa")
}

func (s *Suite) Test_replaceFirst(c *check.C) {
	m, rest := regex.ReplaceFirst("a+b+c+d", `(\w)(.)(\w)`, "X")

	c.Assert(m, check.NotNil)
	c.Check(m, check.DeepEquals, []string{"a+b", "a", "+", "b"})
	c.Check(rest, equals, "X+c+d")
}

func (s *Suite) Test_tabLength(c *check.C) {
	c.Check(tabLength("12345"), equals, 5)
	c.Check(tabLength("\t"), equals, 8)
	c.Check(tabLength("123\t"), equals, 8)
	c.Check(tabLength("1234567\t"), equals, 8)
	c.Check(tabLength("12345678\t"), equals, 16)
}

func (s *Suite) Test_cleanpath(c *check.C) {
	c.Check(cleanpath("simple/path"), equals, "simple/path")
	c.Check(cleanpath("/absolute/path"), equals, "/absolute/path")
	c.Check(cleanpath("./././."), equals, ".")
	c.Check(cleanpath("./././"), equals, ".")
	c.Check(cleanpath("dir/../dir/../dir/../dir/subdir/../../Makefile"), equals, "dir/../dir/../dir/../Makefile")
	c.Check(cleanpath("dir/multi/././/file"), equals, "dir/multi/file")
	c.Check(cleanpath("111/222/../../333/444/../../555/666/../../777/888/9"), equals, "111/222/../../777/888/9")
	c.Check(cleanpath("cat/pkg.v1/../../cat/pkg.v2/Makefile"), equals, "cat/pkg.v1/../../cat/pkg.v2/Makefile")
	c.Check(cleanpath("dir/"), equals, "dir")
}

func (s *Suite) Test_isEmptyDir_and_getSubdirs(c *check.C) {
	s.Init(c)
	s.CreateTmpFile("CVS/Entries", "dummy\n")

	c.Check(isEmptyDir(s.tmpdir), equals, true)
	c.Check(getSubdirs(s.tmpdir), check.DeepEquals, []string(nil))

	s.CreateTmpFile("somedir/file", "")

	c.Check(isEmptyDir(s.tmpdir), equals, false)
	c.Check(getSubdirs(s.tmpdir), check.DeepEquals, []string{"somedir"})

	if nodir := s.tmpdir + "/nonexistent"; true {
		c.Check(isEmptyDir(nodir), equals, true) // Counts as empty.
		defer s.ExpectFatalError(func() {
			c.Check(s.Output(), check.Matches, `FATAL: (.+): Cannot be read: open (.+): (.+)\n`)
		})
		c.Check(getSubdirs(nodir), check.DeepEquals, []string(nil))
		c.FailNow()
	}
}

func (s *Suite) Test_PrefixReplacer_Since(c *check.C) {
	repl := textproc.NewPrefixReplacer("hello, world")
	mark := repl.Mark()
	repl.AdvanceRegexp(`^\w+`)
	c.Check(repl.Since(mark), equals, "hello")
}

const reMkIncludeBenchmark = `^\.(\s*)(s?include)\s+\"([^\"]+)\"\s*(?:#.*)?$`
const reMkIncludeBenchmarkPositive = `^\.(\s*)(s?include)\s+\"(.+)\"\s*(?:#.*)?$`

func Benchmark_match3_buildlink3(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../category/package/buildlink3.mk\"", reMkIncludeBenchmark)
	}
}

func Benchmark_match3_bsd_pkg_mk(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../mk/bsd.pkg.mk\"", reMkIncludeBenchmark)
	}
}

func Benchmark_match3_samedir(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"options.mk\"", reMkIncludeBenchmark)
	}
}

func Benchmark_match3_bsd_pkg_mk_comment(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../mk/bsd.pkg.mk\"          # infrastructure     ", reMkIncludeBenchmark)
	}
}

func Benchmark_match3_buildlink3_positive(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../category/package/buildlink3.mk\"", reMkIncludeBenchmarkPositive)
	}
}

func Benchmark_match3_bsd_pkg_mk_positive(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../mk/bsd.pkg.mk\"", reMkIncludeBenchmarkPositive)
	}
}

func Benchmark_match3_samedir_positive(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"options.mk\"", reMkIncludeBenchmarkPositive)
	}
}

func Benchmark_match3_bsd_pkg_mk_comment_positive(b *testing.B) {
	for i := 0; i < b.N; i++ {
		match3(".include \"../../mk/bsd.pkg.mk\"          # infrastructure     ", reMkIncludeBenchmarkPositive)
	}
}

func Benchmark_match3_explicit(b *testing.B) {
	for i := 0; i < b.N; i++ {
		MatchMkInclude(".include \"../../mk/bsd.pkg.mk\"          # infrastructure     ")
	}
}
