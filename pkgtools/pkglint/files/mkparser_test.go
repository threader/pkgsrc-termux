package main

import (
	check "gopkg.in/check.v1"
)

func (s *Suite) Test_MkParser_MkTokens(c *check.C) {
	s.Init(c)
	checkRest := func(input string, expectedTokens []*MkToken, expectedRest string) {
		p := NewMkParser(dummyLine, input, true)
		actualTokens := p.MkTokens()
		c.Check(actualTokens, deepEquals, expectedTokens)
		for i, expectedToken := range expectedTokens {
			if i < len(actualTokens) {
				c.Check(*actualTokens[i], deepEquals, *expectedToken)
			}
		}
		c.Check(p.Rest(), equals, expectedRest)
	}
	check := func(input string, expectedToken *MkToken) {
		checkRest(input, []*MkToken{expectedToken}, "")
	}
	literal := func(text string) *MkToken {
		return &MkToken{Text: text}
	}
	varuse := func(varname string, modifiers ...string) *MkToken {
		text := "${" + varname
		for _, modifier := range modifiers {
			text += ":" + modifier
		}
		text += "}"
		return &MkToken{Text: text, Varuse: &MkVarUse{varname: varname, modifiers: modifiers}}
	}
	varuseText := func(text, varname string, modifiers ...string) *MkToken {
		return &MkToken{Text: text, Varuse: &MkVarUse{varname: varname, modifiers: modifiers}}
	}

	check("literal", literal("literal"))
	check("\\/share\\/ { print \"share directory\" }", literal("\\/share\\/ { print \"share directory\" }"))
	check("find . -name \\*.orig -o -name \\*.pre", literal("find . -name \\*.orig -o -name \\*.pre"))
	check("-e 's|\\$${EC2_HOME.*}|EC2_HOME}|g'", literal("-e 's|\\$${EC2_HOME.*}|EC2_HOME}|g'"))

	check("${VARIABLE}", varuse("VARIABLE"))
	check("${VARIABLE.param}", varuse("VARIABLE.param"))
	check("${VARIABLE.${param}}", varuse("VARIABLE.${param}"))
	check("${VARIABLE.hicolor-icon-theme}", varuse("VARIABLE.hicolor-icon-theme"))
	check("${VARIABLE.gtk+extra}", varuse("VARIABLE.gtk+extra"))
	check("${VARIABLE:S/old/new/}", varuse("VARIABLE", "S/old/new/"))
	check("${GNUSTEP_LFLAGS:S/-L//g}", varuse("GNUSTEP_LFLAGS", "S/-L//g"))
	check("${SUSE_VERSION:S/.//}", varuse("SUSE_VERSION", "S/.//"))
	check("${MASTER_SITE_GNOME:=sources/alacarte/0.13/}", varuse("MASTER_SITE_GNOME", "=sources/alacarte/0.13/"))
	check("${INCLUDE_DIRS:H:T}", varuse("INCLUDE_DIRS", "H", "T"))
	check("${A.${B.${C.${D}}}}", varuse("A.${B.${C.${D}}}"))
	check("${RUBY_VERSION:C/([0-9]+)\\.([0-9]+)\\.([0-9]+)/\\1/}", varuse("RUBY_VERSION", "C/([0-9]+)\\.([0-9]+)\\.([0-9]+)/\\1/"))
	check("${PERL5_${_var_}:Q}", varuse("PERL5_${_var_}", "Q"))
	check("${PKGNAME_REQD:C/(^.*-|^)py([0-9][0-9])-.*/\\2/}", varuse("PKGNAME_REQD", "C/(^.*-|^)py([0-9][0-9])-.*/\\2/"))
	check("${PYLIB:S|/|\\\\/|g}", varuse("PYLIB", "S|/|\\\\/|g"))
	check("${PKGNAME_REQD:C/ruby([0-9][0-9]+)-.*/\\1/}", varuse("PKGNAME_REQD", "C/ruby([0-9][0-9]+)-.*/\\1/"))
	check("${RUBY_SHLIBALIAS:S/\\//\\\\\\//}", varuse("RUBY_SHLIBALIAS", "S/\\//\\\\\\//"))
	check("${RUBY_VER_MAP.${RUBY_VER}:U${RUBY_VER}}", varuse("RUBY_VER_MAP.${RUBY_VER}", "U${RUBY_VER}"))
	check("${RUBY_VER_MAP.${RUBY_VER}:U18}", varuse("RUBY_VER_MAP.${RUBY_VER}", "U18"))
	check("${CONFIGURE_ARGS:S/ENABLE_OSS=no/ENABLE_OSS=yes/g}", varuse("CONFIGURE_ARGS", "S/ENABLE_OSS=no/ENABLE_OSS=yes/g"))
	check("${PLIST_RUBY_DIRS:S,DIR=\"PREFIX/,DIR=\",}", varuse("PLIST_RUBY_DIRS", "S,DIR=\"PREFIX/,DIR=\","))
	check("${LDFLAGS:S/-Wl,//g:Q}", varuse("LDFLAGS", "S/-Wl,//g", "Q"))
	check("${_PERL5_REAL_PACKLIST:S/^/${DESTDIR}/}", varuse("_PERL5_REAL_PACKLIST", "S/^/${DESTDIR}/"))
	check("${_PYTHON_VERSION:C/^([0-9])/\\1./1}", varuse("_PYTHON_VERSION", "C/^([0-9])/\\1./1"))
	check("${PKGNAME:S/py${_PYTHON_VERSION}/py${i}/}", varuse("PKGNAME", "S/py${_PYTHON_VERSION}/py${i}/"))
	check("${PKGNAME:C/-[0-9].*$/-[0-9]*/}", varuse("PKGNAME", "C/-[0-9].*$/-[0-9]*/"))
	check("${PKGNAME:S/py${_PYTHON_VERSION}/py${i}/:C/-[0-9].*$/-[0-9]*/}", varuse("PKGNAME", "S/py${_PYTHON_VERSION}/py${i}/", "C/-[0-9].*$/-[0-9]*/"))
	check("${_PERL5_VARS:tl:S/^/-V:/}", varuse("_PERL5_VARS", "tl", "S/^/-V:/"))
	check("${_PERL5_VARS_OUT:M${_var_:tl}=*:S/^${_var_:tl}=${_PERL5_PREFIX:=/}//}", varuse("_PERL5_VARS_OUT", "M${_var_:tl}=*", "S/^${_var_:tl}=${_PERL5_PREFIX:=/}//"))
	check("${RUBY${RUBY_VER}_PATCHLEVEL}", varuse("RUBY${RUBY_VER}_PATCHLEVEL"))
	check("${DISTFILES:M*.gem}", varuse("DISTFILES", "M*.gem"))
	check("${LOCALBASE:S^/^_^}", varuse("LOCALBASE", "S^/^_^"))
	check("${SOURCES:%.c=%.o}", varuse("SOURCES", "%.c=%.o"))
	check("${GIT_TEMPLATES:@.t.@ ${EGDIR}/${GIT_TEMPLATEDIR}/${.t.} ${PREFIX}/${GIT_CORE_TEMPLATEDIR}/${.t.} @:M*}",
		varuse("GIT_TEMPLATES", "@.t.@ ${EGDIR}/${GIT_TEMPLATEDIR}/${.t.} ${PREFIX}/${GIT_CORE_TEMPLATEDIR}/${.t.} @", "M*"))
	check("${DISTNAME:C:_:-:}", varuse("DISTNAME", "C:_:-:"))
	check("${CF_FILES:H:O:u:S@^@${PKG_SYSCONFDIR}/@}", varuse("CF_FILES", "H", "O", "u", "S@^@${PKG_SYSCONFDIR}/@"))
	check("${ALT_GCC_RTS:S%${LOCALBASE}%%:S%/%%}", varuse("ALT_GCC_RTS", "S%${LOCALBASE}%%", "S%/%%"))
	check("${PREFIX:C;///*;/;g:C;/$;;}", varuse("PREFIX", "C;///*;/;g", "C;/$;;"))
	check("${GZIP_CMD:[1]:Q}", varuse("GZIP_CMD", "[1]", "Q"))
	check("${DISTNAME:C/-[0-9]+$$//:C/_/-/}", varuse("DISTNAME", "C/-[0-9]+$$//", "C/_/-/"))
	check("${DISTNAME:slang%=slang2%}", varuse("DISTNAME", "slang%=slang2%"))
	check("${OSMAP_SUBSTVARS:@v@-e 's,\\@${v}\\@,${${v}},g' @}", varuse("OSMAP_SUBSTVARS", "@v@-e 's,\\@${v}\\@,${${v}},g' @"))
	check("${BRANDELF:D${BRANDELF} -t Linux ${LINUX_LDCONFIG}:U${TRUE}}", varuse("BRANDELF", "D${BRANDELF} -t Linux ${LINUX_LDCONFIG}", "U${TRUE}"))
	check("${${_var_}.*}", varuse("${_var_}.*"))

	check("${GCONF_SCHEMAS:@.s.@${INSTALL_DATA} ${WRKSRC}/src/common/dbus/${.s.} ${DESTDIR}${GCONF_SCHEMAS_DIR}/@}",
		varuse("GCONF_SCHEMAS", "@.s.@${INSTALL_DATA} ${WRKSRC}/src/common/dbus/${.s.} ${DESTDIR}${GCONF_SCHEMAS_DIR}/@"))

	/* weird features */
	check("${${EMACS_VERSION_MAJOR}>22:?@comment :}", varuse("${EMACS_VERSION_MAJOR}>22", "?@comment :"))
	check("${empty(CFLAGS):?:-cflags ${CFLAGS:Q}}", varuse("empty(CFLAGS)", "?:-cflags ${CFLAGS:Q}"))
	check("${${PKGSRC_COMPILER}==gcc:?gcc:cc}", varuse("${PKGSRC_COMPILER}==gcc", "?gcc:cc"))

	check("${${XKBBASE}/xkbcomp:L:Q}", varuse("${XKBBASE}/xkbcomp", "L", "Q"))
	check("${${PKGBASE} ${PKGVERSION}:L}", varuse("${PKGBASE} ${PKGVERSION}", "L"))

	check("${${${PKG_INFO} -E ${d} || echo:L:sh}:L:C/[^[0-9]]*/ /g:[1..3]:ts.}",
		varuse("${${PKG_INFO} -E ${d} || echo:L:sh}", "L", "C/[^[0-9]]*/ /g", "[1..3]", "ts."))

	check("${VAR:S/-//S/.//}", varuseText("${VAR:S/-//S/.//}", "VAR", "S/-//", "S/.//")) // For :S and :C, the colon can be left out.

	check("${VAR:ts}", varuse("VAR", "ts"))                 // The separator character can be left out.
	check("${VAR:ts\\000012}", varuse("VAR", "ts\\000012")) // The separator character can be a long octal number.
	check("${VAR:ts\\124}", varuse("VAR", "ts\\124"))       // Or even decimal.

	check("$(GNUSTEP_USER_ROOT)", varuseText("$(GNUSTEP_USER_ROOT)", "GNUSTEP_USER_ROOT"))
	s.CheckOutputLines(
		"WARN: Please use curly braces {} instead of round parentheses () for GNUSTEP_USER_ROOT.")

	checkRest("${VAR)", nil, "${VAR)") // Opening brace, closing parenthesis
	checkRest("$(VAR}", nil, "$(VAR}") // Opening parenthesis, closing brace
	s.CheckOutputEmpty()               // Warnings are only printed for balanced expressions.

	check("${PLIST_SUBST_VARS:@var@${var}=${${var}:Q}@}", varuse("PLIST_SUBST_VARS", "@var@${var}=${${var}:Q}@"))
	check("${PLIST_SUBST_VARS:@var@${var}=${${var}:Q}}", varuse("PLIST_SUBST_VARS", "@var@${var}=${${var}:Q}")) // Missing @ at the end
	s.CheckOutputLines(
		"WARN: Modifier ${PLIST_SUBST_VARS:@var@...@} is missing the final \"@\".")

	checkRest("hello, ${W:L:tl}orld", []*MkToken{
		literal("hello, "),
		varuse("W", "L", "tl"),
		literal("orld")}, "")
	checkRest("ftp://${PKGNAME}/ ${MASTER_SITES:=subdir/}", []*MkToken{
		literal("ftp://"),
		varuse("PKGNAME"),
		literal("/ "),
		varuse("MASTER_SITES", "=subdir/")}, "")
}

func (s *Suite) Test_MkParser_MkCond(c *check.C) {
	checkRest := func(input string, expectedTree *Tree, expectedRest string) {
		p := NewMkParser(dummyLine, input, false)
		actualTree := p.MkCond()
		c.Check(actualTree, deepEquals, expectedTree)
		c.Check(p.Rest(), equals, expectedRest)
	}
	check := func(input string, expectedTree *Tree) {
		checkRest(input, expectedTree, "")
	}
	varuse := func(varname string, modifiers ...string) MkVarUse {
		return MkVarUse{varname: varname, modifiers: modifiers}
	}

	check("${OPSYS:MNetBSD}",
		NewTree("not", NewTree("empty", varuse("OPSYS", "MNetBSD"))))
	check("defined(VARNAME)",
		NewTree("defined", "VARNAME"))
	check("empty(VARNAME)",
		NewTree("empty", varuse("VARNAME")))
	check("!empty(VARNAME)",
		NewTree("not", NewTree("empty", varuse("VARNAME"))))
	check("!empty(VARNAME:M[yY][eE][sS])",
		NewTree("not", NewTree("empty", varuse("VARNAME", "M[yY][eE][sS]"))))
	check("${VARNAME} != \"Value\"",
		NewTree("compareVarStr", varuse("VARNAME"), "!=", "Value"))
	check("${VARNAME:Mi386} != \"Value\"",
		NewTree("compareVarStr", varuse("VARNAME", "Mi386"), "!=", "Value"))
	check("${VARNAME} != Value",
		NewTree("compareVarStr", varuse("VARNAME"), "!=", "Value"))
	check("\"${VARNAME}\" != Value",
		NewTree("compareVarStr", varuse("VARNAME"), "!=", "Value"))
	check("${pkg} == \"${name}\"",
		NewTree("compareVarVar", varuse("pkg"), "==", varuse("name")))
	check("\"${pkg}\" == \"${name}\"",
		NewTree("compareVarVar", varuse("pkg"), "==", varuse("name")))
	check("(defined(VARNAME))",
		NewTree("defined", "VARNAME"))
	check("exists(/etc/hosts)",
		NewTree("exists", "/etc/hosts"))
	check("exists(${PREFIX}/var)",
		NewTree("exists", "${PREFIX}/var"))
	check("${OPSYS} == \"NetBSD\" || ${OPSYS} == \"OpenBSD\"",
		NewTree("or",
			NewTree("compareVarStr", varuse("OPSYS"), "==", "NetBSD"),
			NewTree("compareVarStr", varuse("OPSYS"), "==", "OpenBSD")))
	check("${OPSYS} == \"NetBSD\" && ${MACHINE_ARCH} == \"i386\"",
		NewTree("and",
			NewTree("compareVarStr", varuse("OPSYS"), "==", "NetBSD"),
			NewTree("compareVarStr", varuse("MACHINE_ARCH"), "==", "i386")))
	check("defined(A) && defined(B) || defined(C) && defined(D)",
		NewTree("or",
			NewTree("and",
				NewTree("defined", "A"),
				NewTree("defined", "B")),
			NewTree("and",
				NewTree("defined", "C"),
				NewTree("defined", "D"))))
	check("${MACHINE_ARCH:Mi386} || ${MACHINE_OPSYS:MNetBSD}",
		NewTree("or",
			NewTree("not", NewTree("empty", varuse("MACHINE_ARCH", "Mi386"))),
			NewTree("not", NewTree("empty", varuse("MACHINE_OPSYS", "MNetBSD")))))

	// Exotic cases
	check("0",
		NewTree("literalNum", "0"))
	check("! ( defined(A)  && empty(VARNAME) )",
		NewTree("not", NewTree("and", NewTree("defined", "A"), NewTree("empty", varuse("VARNAME")))))
	check("${REQD_MAJOR} > ${MAJOR}",
		NewTree("compareVarVar", varuse("REQD_MAJOR"), ">", varuse("MAJOR")))
	check("${OS_VERSION} >= 6.5",
		NewTree("compareVarNum", varuse("OS_VERSION"), ">=", "6.5"))
	check("${OS_VERSION} == 5.3",
		NewTree("compareVarNum", varuse("OS_VERSION"), "==", "5.3"))
	check("!empty(${OS_VARIANT:MIllumos})", // Probably not intended
		NewTree("not", NewTree("empty", varuse("${OS_VARIANT:MIllumos}"))))

	// Errors
	checkRest("!empty(PKG_OPTIONS:Msndfile) || defined(PKG_OPTIONS:Msamplerate)",
		NewTree("not", NewTree("empty", varuse("PKG_OPTIONS", "Msndfile"))),
		" || defined(PKG_OPTIONS:Msamplerate)")
}

func (s *Suite) Test_MkParser__varuse_parentheses_autofix(c *check.C) {
	s.Init(c)
	s.UseCommandLine("--autofix")
	G.globalData.InitVartypes()
	filename := s.CreateTmpFile("Makefile", "")
	mklines := s.NewMkLines(filename,
		mkrcsid,
		"COMMENT=$(P1) $(P2)) $(P3:Q) ${BRACES}")

	mklines.Check()

	s.CheckOutputLines(
		"AUTOFIX: ~/Makefile:2: Replacing \"$(P1)\" with \"${P1}\".",
		"AUTOFIX: ~/Makefile:2: Replacing \"$(P2)\" with \"${P2}\".",
		"AUTOFIX: ~/Makefile:2: Replacing \"$(P3:Q)\" with \"${P3:Q}\".",
		"AUTOFIX: ~/Makefile: Has been auto-fixed. Please re-run pkglint.")
	c.Check(s.LoadTmpFile("Makefile"), equals, ""+
		mkrcsid+"\n"+
		"COMMENT=${P1} ${P2}) ${P3:Q} ${BRACES}\n")
}
