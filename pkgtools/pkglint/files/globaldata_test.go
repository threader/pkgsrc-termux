package main

import (
	check "gopkg.in/check.v1"
	"netbsd.org/pkglint/trace"
)

func (s *Suite) Test_GlobalData_InitVartypes(c *check.C) {
	G.globalData.InitVartypes()

	c.Check(G.globalData.vartypes["BSD_MAKE_ENV"].basicType.name, equals, "ShellWord")
	c.Check(G.globalData.vartypes["USE_BUILTIN.*"].basicType.name, equals, "YesNoIndirectly")
}

func (s *Suite) Test_parselinesSuggestedUpdates(c *check.C) {
	lines := s.NewLines("doc/TODO",
		"",
		"Suggested package updates",
		"==============",
		"For Perl updates \u2026",
		"",
		"\t"+"o CSP-0.34",
		"\t"+"o freeciv-client-2.5.0 (urgent)",
		"",
		"\t"+"o ignored-0.0")

	todo := parselinesSuggestedUpdates(lines)

	c.Check(todo, check.DeepEquals, []SuggestedUpdate{
		{lines[5], "CSP", "0.34", ""},
		{lines[6], "freeciv-client", "2.5.0", "(urgent)"}})
}

func (s *Suite) Test_GlobalData_loadTools(c *check.C) {
	s.Init(c)
	s.CreateTmpFileLines("mk/tools/bsd.tools.mk",
		".include \"flex.mk\"",
		".include \"gettext.mk\"")
	s.CreateTmpFileLines("mk/tools/defaults.mk",
		"_TOOLS_VARNAME.chown=CHOWN",
		"_TOOLS_VARNAME.gawk=AWK",
		"_TOOLS_VARNAME.mv=MV",
		"_TOOLS_VARNAME.pwd=PWD")
	s.CreateTmpFileLines("mk/tools/flex.mk",
		"# empty")
	s.CreateTmpFileLines("mk/tools/gettext.mk",
		"USE_TOOLS+=msgfmt",
		"TOOLS_CREATE+=msgfmt")
	s.CreateTmpFileLines("mk/bsd.prefs.mk",
		"USE_TOOLS+=\tpwd")
	s.CreateTmpFileLines("mk/bsd.pkg.mk",
		"USE_TOOLS+=\tmv")
	G.globalData.Pkgsrcdir = s.tmpdir
	G.CurrentDir = s.tmpdir
	G.CurPkgsrcdir = "."

	G.globalData.loadTools()

	trace.Tracing = true
	G.globalData.Tools.Trace()

	c.Check(s.Output(), equals, ""+
		"TRACE: + (*ToolRegistry).Trace()\n"+
		"TRACE: 1   tool &{Name:TOOLS_mv Varname: MustUseVarForm:false Predefined:true UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:TOOLS_pwd Varname: MustUseVarForm:false Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: 1   tool &{Name:chown Varname:CHOWN MustUseVarForm:false Predefined:false UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:echo Varname:ECHO MustUseVarForm:true Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: 1   tool &{Name:echo -n Varname:ECHO_N MustUseVarForm:true Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: 1   tool &{Name:false Varname:FALSE MustUseVarForm:true Predefined:true UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:gawk Varname:AWK MustUseVarForm:false Predefined:false UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:msgfmt Varname: MustUseVarForm:false Predefined:false UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:mv Varname:MV MustUseVarForm:false Predefined:true UsableAtLoadtime:false}\n"+
		"TRACE: 1   tool &{Name:pwd Varname:PWD MustUseVarForm:false Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: 1   tool &{Name:test Varname:TEST MustUseVarForm:true Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: 1   tool &{Name:true Varname:TRUE MustUseVarForm:true Predefined:true UsableAtLoadtime:true}\n"+
		"TRACE: - (*ToolRegistry).Trace()\n")
}

func (s *Suite) Test_GlobalData_loadDocChangesFromFile(c *check.C) {
	s.Init(c)
	s.CreateTmpFile("doc/CHANGES-2015", ""+
		"\tAdded category/package version 1.0 [author1 2015-01-01]\n"+
		"\tUpdated category/package to 1.5 [author2 2015-01-02]\n"+
		"\tRenamed category/package to category/pkg [author3 2015-01-03]\n"+
		"\tMoved category/package to other/package [author4 2015-01-04]\n"+
		"\tRemoved category/package [author5 2015-01-05]\n"+
		"\tRemoved category/package successor category/package2 [author6 2015-01-06]\n"+
		"\tDowngraded category/package to 1.2 [author7 2015-01-07]\n")

	changes := G.globalData.loadDocChangesFromFile(s.tmpdir + "/doc/CHANGES-2015")

	c.Assert(len(changes), equals, 7)
	c.Check(*changes[0], equals, Change{changes[0].Line, "Added", "category/package", "1.0", "author1", "2015-01-01"})
	c.Check(*changes[1], equals, Change{changes[1].Line, "Updated", "category/package", "1.5", "author2", "2015-01-02"})
	c.Check(*changes[2], equals, Change{changes[2].Line, "Renamed", "category/package", "", "author3", "2015-01-03"})
	c.Check(*changes[3], equals, Change{changes[3].Line, "Moved", "category/package", "", "author4", "2015-01-04"})
	c.Check(*changes[4], equals, Change{changes[4].Line, "Removed", "category/package", "", "author5", "2015-01-05"})
	c.Check(*changes[5], equals, Change{changes[5].Line, "Removed", "category/package", "", "author6", "2015-01-06"})
	c.Check(*changes[6], equals, Change{changes[6].Line, "Downgraded", "category/package", "1.2", "author7", "2015-01-07"})
}

func (s *Suite) Test_GlobalData_deprecated(c *check.C) {
	s.Init(c)
	G.globalData.loadDeprecatedVars()

	line := NewLine("Makefile", 5, "USE_PERL5=\tyes", nil)
	MkLineChecker{NewMkLine(line)}.checkVarassign()

	s.CheckOutputLines(
		"WARN: Makefile:5: Definition of USE_PERL5 is deprecated. Use USE_TOOLS+=perl or USE_TOOLS+=perl:run instead.")
}

// https://mail-index.netbsd.org/tech-pkg/2017/01/18/msg017698.html
func (s *Suite) Test_GlobalData_loadDistSites(c *check.C) {
	s.Init(c)
	G.globalData.Pkgsrcdir = s.TmpDir()
	s.CreateTmpFileLines("mk/fetch/sites.mk",
		mkrcsid,
		"",
		"MASTER_SITE_A+= https://example.org/distfiles/",
		"MASTER_SITE_B+= https://b.example.org/distfiles/ \\",
		"  https://b2.example.org/distfiles/",
		"MASTER_SITE_A+= https://a.example.org/distfiles/")

	G.globalData.loadDistSites()

	c.Check(G.globalData.MasterSiteURLToVar["https://example.org/distfiles/"], equals, "MASTER_SITE_A")
	c.Check(G.globalData.MasterSiteURLToVar["https://b.example.org/distfiles/"], equals, "MASTER_SITE_B")
	c.Check(G.globalData.MasterSiteURLToVar["https://b2.example.org/distfiles/"], equals, "MASTER_SITE_B")
	c.Check(G.globalData.MasterSiteURLToVar["https://a.example.org/distfiles/"], equals, "MASTER_SITE_A")
	c.Check(G.globalData.MasterSiteVarToURL["MASTER_SITE_A"], equals, "https://example.org/distfiles/")
	c.Check(G.globalData.MasterSiteVarToURL["MASTER_SITE_B"], equals, "https://b.example.org/distfiles/")
}
