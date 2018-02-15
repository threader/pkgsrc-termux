package main

import (
	"fmt"

	check "gopkg.in/check.v1"
)

func (s *Suite) Test_VartypeCheck_AwkCommand(c *check.C) {
	s.Init(c)
	runVartypeChecks("PLIST_AWK", opAssignAppend, (*VartypeCheck).AwkCommand,
		"{print $0}",
		"{print $$0}")

	s.CheckOutputLines(
		"WARN: fname:1: $0 is ambiguous. Use ${0} if you mean a Makefile variable or $$0 if you mean a shell variable.")
}

func (s *Suite) Test_VartypeCheck_BasicRegularExpression(c *check.C) {
	s.Init(c)
	runVartypeChecks("REPLACE_FILES.pl", opAssign, (*VartypeCheck).BasicRegularExpression,
		".*\\.pl$",
		".*\\.pl$$")

	s.CheckOutputLines(
		"WARN: fname:1: Pkglint parse error in MkLine.Tokenize at \"$\".")
}

func (s *Suite) Test_VartypeCheck_BuildlinkDepmethod(c *check.C) {
	s.Init(c)
	runVartypeChecks("BUILDLINK_DEPMETHOD.libc", opAssignDefault, (*VartypeCheck).BuildlinkDepmethod,
		"full",
		"unknown")

	s.CheckOutputLines(
		"WARN: fname:2: Invalid dependency method \"unknown\". Valid methods are \"build\" or \"full\".")
}

func (s *Suite) Test_VartypeCheck_Category(c *check.C) {
	s.Init(c)
	s.CreateTmpFile("filesyscategory/Makefile", "# empty\n")
	s.CreateTmpFile("wip/Makefile", "# empty\n")
	G.CurrentDir = s.tmpdir
	G.CurPkgsrcdir = "."

	runVartypeChecks("CATEGORIES", opAssign, (*VartypeCheck).Category,
		"chinese",
		"arabic",
		"filesyscategory",
		"wip")

	s.CheckOutputLines(
		"ERROR: fname:2: Invalid category \"arabic\".",
		"ERROR: fname:4: Invalid category \"wip\".")
}

func (s *Suite) Test_VartypeCheck_CFlag(c *check.C) {
	s.Init(c)
	runVartypeChecks("CFLAGS", opAssignAppend, (*VartypeCheck).CFlag,
		"-Wall",
		"/W3",
		"target:sparc64",
		"-std=c99",
		"-XX:+PrintClassHistogramAfterFullGC",
		"`pkg-config pidgin --cflags`")

	s.CheckOutputLines(
		"WARN: fname:2: Compiler flag \"/W3\" should start with a hyphen.",
		"WARN: fname:3: Compiler flag \"target:sparc64\" should start with a hyphen.",
		"WARN: fname:5: Unknown compiler flag \"-XX:+PrintClassHistogramAfterFullGC\".")
}

func (s *Suite) Test_VartypeCheck_Comment(c *check.C) {
	s.Init(c)
	runVartypeChecks("COMMENT", opAssign, (*VartypeCheck).Comment,
		"Versatile Programming Language",
		"TODO: Short description of the package",
		"A great package.",
		"some packages need a very very long comment to explain their basic usefulness",
		"\"Quoting the comment is wrong\"",
		"'Quoting the comment is wrong'")

	s.CheckOutputLines(
		"ERROR: fname:2: COMMENT must be set.",
		"WARN: fname:3: COMMENT should not begin with \"A\".",
		"WARN: fname:3: COMMENT should not end with a period.",
		"WARN: fname:4: COMMENT should start with a capital letter.",
		"WARN: fname:4: COMMENT should not be longer than 70 characters.",
		"WARN: fname:5: COMMENT should not be enclosed in quotes.",
		"WARN: fname:6: COMMENT should not be enclosed in quotes.")
}

func (s *Suite) Test_VartypeCheck_ConfFiles(c *check.C) {
	s.Init(c)
	runVartypeChecks("CONF_FILES", opAssignAppend, (*VartypeCheck).ConfFiles,
		"single/file",
		"share/etc/config ${PKG_SYSCONFDIR}/etc/config",
		"share/etc/config ${PKG_SYSCONFBASE}/etc/config file",
		"share/etc/config ${PREFIX}/etc/config share/etc/config2 ${VARBASE}/config2",
		"share/etc/bootrc /etc/bootrc")

	s.CheckOutputLines(
		"WARN: fname:1: Values for CONF_FILES should always be pairs of paths.",
		"WARN: fname:3: Values for CONF_FILES should always be pairs of paths.",
		"WARN: fname:5: Found absolute pathname: /etc/bootrc",
		"WARN: fname:5: The destination file \"/etc/bootrc\" should start with a variable reference.")
}

func (s *Suite) Test_VartypeCheck_Dependency(c *check.C) {
	runVartypeChecks("CONFLICTS", opAssignAppend, (*VartypeCheck).Dependency,
		"Perl",
		"perl5>=5.22",
		"perl5-*",
		"perl5-5.22.*",
		"perl5-[5.10-5.22]*",
		"py-docs",
		"perl5-5.22.*{,nb*}",
		"libkipi>=0.1.5<4.0",
		"gtk2+>=2.16",
		"perl-5.22",
		"perl-5*",
		"gtksourceview-sharp-2.0-[0-9]*",
		"perl-5.22{,nb*}",
		"perl-5.22{,nb[0-9]*}",
		"mbrola-301h{,nb[0-9]*}",
		"mpg123{,-esound,-nas}>=0.59.18",
		"mysql*-{client,server}-[0-9]*",
		"postgresql8[0-35-9]-${module}-[0-9]*",
		"ncurses-${NC_VERS}{,nb*}",
		"{ssh{,6}-[0-9]*,openssh-[0-9]*}",
		"gnome-control-center>=2.20.1{,nb*}")

	c.Check(s.Output(), equals, ""+
		"WARN: fname:1: Unknown dependency pattern \"Perl\".\n"+
		"WARN: fname:3: Please use \"perl5-[0-9]*\" instead of \"perl5-*\".\n"+
		"WARN: fname:5: Only [0-9]* is allowed in the numeric part of a dependency.\n"+
		"WARN: fname:5: The version pattern \"[5.10-5.22]*\" should not contain a hyphen.\n"+
		"WARN: fname:6: Unknown dependency pattern \"py-docs\".\n"+
		"WARN: fname:10: Please use \"5.22{,nb*}\" instead of \"5.22\" as the version pattern.\n"+
		"WARN: fname:11: Please use \"5.*\" instead of \"5*\" as the version pattern.\n"+
		"WARN: fname:12: The version pattern \"2.0-[0-9]*\" should not contain a hyphen.\n"+
		"WARN: fname:20: The version pattern \"[0-9]*,openssh-[0-9]*}\" should not contain a hyphen.\n"+ // XXX
		"WARN: fname:21: Dependency patterns of the form pkgbase>=1.0 don't need the \"{,nb*}\" extension.\n")
}

func (s *Suite) Test_VartypeCheck_DependencyWithPath(c *check.C) {
	s.Init(c)
	s.CreateTmpFile("x11/alacarte/Makefile", "# empty\n")
	s.CreateTmpFile("category/package/Makefile", "# empty\n")
	G.globalData.Pkgsrcdir = s.tmpdir
	G.CurrentDir = s.tmpdir + "/category/package"
	G.CurPkgsrcdir = "../.."

	runVartypeChecks("DEPENDS", opAssignAppend, (*VartypeCheck).DependencyWithPath,
		"Perl",
		"perl5>=5.22:../perl5",
		"perl5>=5.24:../../lang/perl5",
		"broken0.12.1:../../x11/alacarte",
		"broken[0-9]*:../../x11/alacarte",
		"broken[0-9]*../../x11/alacarte",
		"broken>=:../../x11/alacarte",
		"broken=0:../../x11/alacarte",
		"broken=:../../x11/alacarte",
		"broken-:../../x11/alacarte",
		"broken>:../../x11/alacarte",
		"gtk2+>=2.16:../../x11/alacarte")

	c.Check(s.Output(), equals, ""+
		"WARN: fname:1: Unknown dependency pattern with path \"Perl\".\n"+
		"WARN: fname:2: Dependencies should have the form \"../../category/package\".\n"+
		"ERROR: fname:3: \"../../lang/perl5\" does not exist.\n"+
		"ERROR: fname:3: There is no package in \"lang/perl5\".\n"+
		"WARN: fname:3: Please use USE_TOOLS+=perl:run instead of this dependency.\n"+
		"WARN: fname:4: Unknown dependency pattern \"broken0.12.1\".\n"+
		"WARN: fname:5: Unknown dependency pattern \"broken[0-9]*\".\n"+
		"WARN: fname:6: Unknown dependency pattern with path \"broken[0-9]*../../x11/alacarte\".\n"+
		"WARN: fname:7: Unknown dependency pattern \"broken>=\".\n"+
		"WARN: fname:8: Unknown dependency pattern \"broken=0\".\n"+
		"WARN: fname:9: Unknown dependency pattern \"broken=\".\n"+
		"WARN: fname:10: Unknown dependency pattern \"broken-\".\n"+
		"WARN: fname:11: Unknown dependency pattern \"broken>\".\n")
}

func (s *Suite) Test_VartypeCheck_DistSuffix(c *check.C) {
	s.Init(c)
	runVartypeChecks("EXTRACT_SUFX", opAssign, (*VartypeCheck).DistSuffix,
		".tar.gz",
		".tar.bz2")

	s.CheckOutputLines(
		"NOTE: fname:1: EXTRACT_SUFX is \".tar.gz\" by default, so this definition may be redundant.")
}

func (s *Suite) Test_VartypeCheck_EmulPlatform(c *check.C) {
	s.Init(c)
	runVartypeChecks("EMUL_PLATFORM", opAssign, (*VartypeCheck).EmulPlatform,
		"linux-i386",
		"nextbsd-8087",
		"${LINUX}")

	s.CheckOutputLines(
		"WARN: fname:2: \"nextbsd\" is not valid for the operating system part of EMUL_PLATFORM. Use one of { bitrig bsdos cygwin darwin dragonfly freebsd haiku hpux interix irix linux mirbsd netbsd openbsd osf1 solaris sunos } instead.",
		"WARN: fname:2: \"8087\" is not valid for the hardware architecture part of EMUL_PLATFORM. Use one of { aarch64 aarch64eb alpha amd64 arc arm arm26 arm32 cobalt coldfire convex dreamcast earm earmeb earmhf earmhfeb earmv4 earmv4eb earmv5 earmv5eb earmv6 earmv6eb earmv6hf earmv6hfeb earmv7 earmv7eb earmv7hf earmv7hfeb evbarm hpcmips hpcsh hppa hppa64 i386 i586 i686 ia64 m68000 m68k m88k mips mips64 mips64eb mips64el mipseb mipsel mipsn32 mlrisc ns32k pc532 pmax powerpc powerpc64 rs6000 s390 sh3eb sh3el sparc sparc64 vax x86_64 } instead.",
		"WARN: fname:3: \"${LINUX}\" is not a valid emulation platform.")
}

func (s *Suite) Test_VartypeCheck_Enum(c *check.C) {
	s.Init(c)
	runVartypeMatchChecks("JDK", enum("jdk1 jdk2 jdk4").checker,
		"*",
		"jdk*",
		"sun-jdk*",
		"${JDKNAME}")

	s.CheckOutputLines(
		"WARN: fname:3: The pattern \"sun-jdk*\" cannot match any of { jdk1 jdk2 jdk4 } for JDK.")
}

func (s *Suite) Test_VartypeCheck_FetchURL(c *check.C) {
	s.Init(c)
	s.RegisterMasterSite("MASTER_SITE_GNU", "http://ftp.gnu.org/pub/gnu/")
	s.RegisterMasterSite("MASTER_SITE_GITHUB", "https://github.com/")

	runVartypeChecks("MASTER_SITES", opAssign, (*VartypeCheck).FetchURL,
		"https://github.com/example/project/",
		"http://ftp.gnu.org/pub/gnu/bison", // Missing a slash at the end
		"${MASTER_SITE_GNU:=bison}",
		"${MASTER_SITE_INVALID:=subdir/}")

	s.CheckOutputLines(
		"WARN: fname:1: Please use ${MASTER_SITE_GITHUB:=example/} instead of \"https://github.com/example/project/\" and run \""+confMake+" help topic=github\" for further tips.",
		"WARN: fname:2: Please use ${MASTER_SITE_GNU:=bison} instead of \"http://ftp.gnu.org/pub/gnu/bison\".",
		"ERROR: fname:3: The subdirectory in MASTER_SITE_GNU must end with a slash.",
		"ERROR: fname:4: The site MASTER_SITE_INVALID does not exist.")

	// PR 46570, keyword gimp-fix-ca
	runVartypeChecks("MASTER_SITES", opAssign, (*VartypeCheck).FetchURL,
		"https://example.org/download.cgi?fname=fname&sha1=12341234")

	s.CheckOutputEmpty()

	runVartypeChecks("MASTER_SITES", opAssign, (*VartypeCheck).FetchURL,
		"http://example.org/distfiles/",
		"http://example.org/download?fname=distfile;version=1.0",
		"http://example.org/download?fname=<distfile>;version=<version>")

	s.CheckOutputLines(
		"WARN: fname:3: \"http://example.org/download?fname=<distfile>;version=<version>\" is not a valid URL.")
}

func (s *Suite) Test_VartypeCheck_Filename(c *check.C) {
	s.Init(c)
	runVartypeChecks("FNAME", opAssign, (*VartypeCheck).Filename,
		"Filename with spaces.docx",
		"OS/2-manual.txt")

	s.CheckOutputLines(
		"WARN: fname:1: \"Filename with spaces.docx\" is not a valid filename.",
		"WARN: fname:2: A filename should not contain a slash.")
}

func (s *Suite) Test_VartypeCheck_LdFlag(c *check.C) {
	s.Init(c)
	runVartypeChecks("LDFLAGS", opAssignAppend, (*VartypeCheck).LdFlag,
		"-lc",
		"-L/usr/lib64",
		"`pkg-config pidgin --ldflags`",
		"-unknown")

	s.CheckOutputLines(
		"WARN: fname:4: Unknown linker flag \"-unknown\".")
}

func (s *Suite) Test_VartypeCheck_License(c *check.C) {
	s.Init(c)
	runVartypeChecks("LICENSE", opAssign, (*VartypeCheck).License,
		"gnu-gpl-v2",
		"AND mit")

	s.CheckOutputLines(
		"WARN: fname:1: License file /licenses/gnu-gpl-v2 does not exist.",
		"ERROR: fname:2: Parse error for license condition \"AND mit\".")

	runVartypeChecks("LICENSE", opAssignAppend, (*VartypeCheck).License,
		"gnu-gpl-v2",
		"AND mit")

	s.CheckOutputLines(
		"ERROR: fname:1: Parse error for appended license condition \"gnu-gpl-v2\".",
		"WARN: fname:2: License file /licenses/mit does not exist.")
}

func (s *Suite) Test_VartypeCheck_MachineGnuPlatform(c *check.C) {
	s.Init(c)
	runVartypeMatchChecks("MACHINE_GNU_PLATFORM", (*VartypeCheck).MachineGnuPlatform,
		"x86_64-pc-cygwin",
		"Cygwin-*-amd64")

	s.CheckOutputLines(
		"WARN: fname:2: The pattern \"Cygwin\" cannot match any of { aarch64 aarch64_be alpha amd64 arc arm armeb armv4 armv4eb armv6 armv6eb armv7 armv7eb cobalt convex dreamcast hpcmips hpcsh hppa hppa64 i386 i486 ia64 m5407 m68010 m68k m88k mips mips64 mips64el mipseb mipsel mipsn32 mlrisc ns32k pc532 pmax powerpc powerpc64 rs6000 s390 sh shle sparc sparc64 vax x86_64 } for the hardware architecture part of MACHINE_GNU_PLATFORM.",
		"WARN: fname:2: The pattern \"amd64\" cannot match any of { bitrig bsdos cygwin darwin dragonfly freebsd haiku hpux interix irix linux mirbsd netbsd openbsd osf1 solaris sunos } for the operating system part of MACHINE_GNU_PLATFORM.")
}

func (s *Suite) Test_VartypeCheck_MailAddress(c *check.C) {
	s.Init(c)
	runVartypeChecks("MAINTAINER", opAssign, (*VartypeCheck).MailAddress,
		"pkgsrc-users@netbsd.org")

	s.CheckOutputLines(
		"WARN: fname:1: Please write \"NetBSD.org\" instead of \"netbsd.org\".")
}

func (s *Suite) Test_VartypeCheck_Message(c *check.C) {
	s.Init(c)
	runVartypeChecks("SUBST_MESSAGE.id", opAssign, (*VartypeCheck).Message,
		"\"Correct paths\"",
		"Correct paths")

	s.CheckOutputLines(
		"WARN: fname:1: SUBST_MESSAGE.id should not be quoted.")
}

func (s *Suite) Test_VartypeCheck_Option(c *check.C) {
	s.Init(c)
	G.globalData.PkgOptions = map[string]string{
		"documented":   "Option description",
		"undocumented": "",
	}

	runVartypeChecks("PKG_OPTIONS.pkgbase", opAssign, (*VartypeCheck).Option,
		"documented",
		"undocumented",
		"unknown")

	s.CheckOutputLines(
		"WARN: fname:3: Unknown option \"unknown\".")
}

func (s *Suite) Test_VartypeCheck_Pathlist(c *check.C) {
	s.Init(c)
	runVartypeChecks("PATH", opAssign, (*VartypeCheck).Pathlist,
		"/usr/bin:/usr/sbin:.:${LOCALBASE}/bin")

	s.CheckOutputLines(
		"WARN: fname:1: All components of PATH (in this case \".\") should be absolute paths.")
}

func (s *Suite) Test_VartypeCheck_Perms(c *check.C) {
	s.Init(c)
	runVartypeChecks("CONF_FILES_PERMS", opAssignAppend, (*VartypeCheck).Perms,
		"root",
		"${ROOT_USER}",
		"ROOT_USER",
		"${REAL_ROOT_USER}")

	s.CheckOutputLines(
		"ERROR: fname:2: ROOT_USER must not be used in permission definitions. Use REAL_ROOT_USER instead.")
}

func (s *Suite) Test_VartypeCheck_PkgOptionsVar(c *check.C) {
	s.Init(c)
	runVartypeChecks("PKG_OPTIONS_VAR.screen", opAssign, (*VartypeCheck).PkgOptionsVar,
		"PKG_OPTIONS.${PKGBASE}",
		"PKG_OPTIONS.anypkgbase")

	s.CheckOutputLines(
		"ERROR: fname:1: PKGBASE must not be used in PKG_OPTIONS_VAR.")
}

func (s *Suite) Test_VartypeCheck_PkgRevision(c *check.C) {
	s.Init(c)
	runVartypeChecks("PKGREVISION", opAssign, (*VartypeCheck).PkgRevision,
		"3a")

	s.CheckOutputLines(
		"WARN: fname:1: PKGREVISION must be a positive integer number.",
		"ERROR: fname:1: PKGREVISION only makes sense directly in the package Makefile.")

	runVartypeChecksFname("Makefile", "PKGREVISION", opAssign, (*VartypeCheck).PkgRevision,
		"3")

	s.CheckOutputEmpty()
}

func (s *Suite) Test_VartypeCheck_MachinePlatformPattern(c *check.C) {
	s.Init(c)
	runVartypeMatchChecks("ONLY_FOR_PLATFORM", (*VartypeCheck).MachinePlatformPattern,
		"linux-i386",
		"nextbsd-5.0-8087",
		"netbsd-7.0-l*",
		"NetBSD-1.6.2-i386",
		"FreeBSD*",
		"FreeBSD-*",
		"${LINUX}")

	s.CheckOutputLines(
		"WARN: fname:1: \"linux-i386\" is not a valid platform pattern.",
		"WARN: fname:2: The pattern \"nextbsd\" cannot match any of { AIX BSDOS Bitrig Cygwin Darwin DragonFly FreeBSD FreeMiNT GNUkFreeBSD HPUX Haiku IRIX Interix Linux Minix MirBSD NetBSD OSF1 OpenBSD QNX SCO_SV SunOS UnixWare } for the operating system part of ONLY_FOR_PLATFORM.",
		"WARN: fname:2: The pattern \"8087\" cannot match any of { aarch64 aarch64eb alpha amd64 arc arm arm26 arm32 cobalt coldfire convex dreamcast earm earmeb earmhf earmhfeb earmv4 earmv4eb earmv5 earmv5eb earmv6 earmv6eb earmv6hf earmv6hfeb earmv7 earmv7eb earmv7hf earmv7hfeb evbarm hpcmips hpcsh hppa hppa64 i386 i586 i686 ia64 m68000 m68k m88k mips mips64 mips64eb mips64el mipseb mipsel mipsn32 mlrisc ns32k pc532 pmax powerpc powerpc64 rs6000 s390 sh3eb sh3el sparc sparc64 vax x86_64 } for the hardware architecture part of ONLY_FOR_PLATFORM.",
		"WARN: fname:3: The pattern \"netbsd\" cannot match any of { AIX BSDOS Bitrig Cygwin Darwin DragonFly FreeBSD FreeMiNT GNUkFreeBSD HPUX Haiku IRIX Interix Linux Minix MirBSD NetBSD OSF1 OpenBSD QNX SCO_SV SunOS UnixWare } for the operating system part of ONLY_FOR_PLATFORM.",
		"WARN: fname:3: The pattern \"l*\" cannot match any of { aarch64 aarch64eb alpha amd64 arc arm arm26 arm32 cobalt coldfire convex dreamcast earm earmeb earmhf earmhfeb earmv4 earmv4eb earmv5 earmv5eb earmv6 earmv6eb earmv6hf earmv6hfeb earmv7 earmv7eb earmv7hf earmv7hfeb evbarm hpcmips hpcsh hppa hppa64 i386 i586 i686 ia64 m68000 m68k m88k mips mips64 mips64eb mips64el mipseb mipsel mipsn32 mlrisc ns32k pc532 pmax powerpc powerpc64 rs6000 s390 sh3eb sh3el sparc sparc64 vax x86_64 } for the hardware architecture part of ONLY_FOR_PLATFORM.",
		"WARN: fname:5: \"FreeBSD*\" is not a valid platform pattern.")
}

func (s *Suite) Test_VartypeCheck_PythonDependency(c *check.C) {
	s.Init(c)
	runVartypeChecks("PYTHON_VERSIONED_DEPENDENCIES", opAssign, (*VartypeCheck).PythonDependency,
		"cairo",
		"${PYDEP}",
		"cairo,X")

	s.CheckOutputLines(
		"WARN: fname:2: Python dependencies should not contain variables.",
		"WARN: fname:3: Invalid Python dependency \"cairo,X\".")
}

func (s *Suite) Test_VartypeCheck_Restricted(c *check.C) {
	s.Init(c)
	runVartypeChecks("NO_BIN_ON_CDROM", opAssign, (*VartypeCheck).Restricted,
		"May only be distributed free of charge")

	s.CheckOutputLines(
		"WARN: fname:1: The only valid value for NO_BIN_ON_CDROM is ${RESTRICTED}.")
}

func (s *Suite) Test_VartypeCheck_SedCommands(c *check.C) {
	s.Init(c)
	runVartypeChecks("SUBST_SED.dummy", opAssign, (*VartypeCheck).SedCommands,
		"s,@COMPILER@,gcc,g",
		"-e s,a,b, -e a,b,c,",
		"-e \"s,#,comment ,\"",
		"-e \"s,\\#,comment ,\"")

	s.CheckOutputLines(
		"NOTE: fname:1: Please always use \"-e\" in sed commands, even if there is only one substitution.",
		"NOTE: fname:2: Each sed command should appear in an assignment of its own.",
		"WARN: fname:3: The # character starts a comment.")
}

func (s *Suite) Test_VartypeCheck_ShellCommands(c *check.C) {
	s.Init(c)
	runVartypeChecks("GENERATE_PLIST", opAssign, (*VartypeCheck).ShellCommands,
		"echo bin/program",
		"echo bin/program;")

	s.CheckOutputLines(
		"WARN: fname:1: This shell command list should end with a semicolon.")
}

func (s *Suite) Test_VartypeCheck_Stage(c *check.C) {
	s.Init(c)
	runVartypeChecks("SUBST_STAGE.dummy", opAssign, (*VartypeCheck).Stage,
		"post-patch",
		"post-modern",
		"pre-test")

	s.CheckOutputLines(
		"WARN: fname:2: Invalid stage name \"post-modern\". Use one of {pre,do,post}-{extract,patch,configure,build,test,install}.")
}

func (s *Suite) Test_VartypeCheck_VariableName(c *check.C) {
	s.Init(c)
	runVartypeChecks("BUILD_DEFS", opAssign, (*VartypeCheck).VariableName,
		"VARBASE",
		"VarBase",
		"PKG_OPTIONS_VAR.pkgbase",
		"${INDIRECT}")

	s.CheckOutputLines(
		"WARN: fname:2: \"VarBase\" is not a valid variable name.")
}

func (s *Suite) Test_VartypeCheck_Version(c *check.C) {
	s.Init(c)
	runVartypeChecks("PERL5_REQD", opAssignAppend, (*VartypeCheck).Version,
		"0",
		"1.2.3.4.5.6",
		"4.1nb17",
		"4.1-SNAPSHOT",
		"4pre7")

	s.CheckOutputLines(
		"WARN: fname:4: Invalid version number \"4.1-SNAPSHOT\".")
}

func (s *Suite) Test_VartypeCheck_Yes(c *check.C) {
	s.Init(c)
	runVartypeChecks("APACHE_MODULE", opAssign, (*VartypeCheck).Yes,
		"yes",
		"no",
		"${YESVAR}")

	s.CheckOutputLines(
		"WARN: fname:2: APACHE_MODULE should be set to YES or yes.",
		"WARN: fname:3: APACHE_MODULE should be set to YES or yes.")

	runVartypeMatchChecks("PKG_DEVELOPER", (*VartypeCheck).Yes,
		"yes",
		"no",
		"${YESVAR}")

	s.CheckOutputLines(
		"WARN: fname:1: PKG_DEVELOPER should only be used in a \".if defined(...)\" conditional.",
		"WARN: fname:2: PKG_DEVELOPER should only be used in a \".if defined(...)\" conditional.",
		"WARN: fname:3: PKG_DEVELOPER should only be used in a \".if defined(...)\" conditional.")
}

func (s *Suite) Test_VartypeCheck_YesNo(c *check.C) {
	s.Init(c)
	runVartypeChecks("GNU_CONFIGURE", opAssign, (*VartypeCheck).YesNo,
		"yes",
		"no",
		"ja",
		"${YESVAR}")

	s.CheckOutputLines(
		"WARN: fname:3: GNU_CONFIGURE should be set to YES, yes, NO, or no.",
		"WARN: fname:4: GNU_CONFIGURE should be set to YES, yes, NO, or no.")
}

func (s *Suite) Test_VartypeCheck_YesNoIndirectly(c *check.C) {
	s.Init(c)
	runVartypeChecks("GNU_CONFIGURE", opAssign, (*VartypeCheck).YesNoIndirectly,
		"yes",
		"no",
		"ja",
		"${YESVAR}")

	s.CheckOutputLines(
		"WARN: fname:3: GNU_CONFIGURE should be set to YES, yes, NO, or no.")
}

func runVartypeChecks(varname string, op MkOperator, checker func(*VartypeCheck), values ...string) {
	if !contains(op.String(), "=") {
		panic("runVartypeChecks needs an assignment operator")
	}
	for i, value := range values {
		mkline := NewMkLine(NewLine("fname", i+1, varname+op.String()+value, nil))
		valueNovar := mkline.WithoutMakeVariables(mkline.Value())
		vc := &VartypeCheck{mkline, mkline, mkline.Varname(), mkline.Op(), mkline.Value(), valueNovar, "", false}
		checker(vc)
	}
}

func runVartypeMatchChecks(varname string, checker func(*VartypeCheck), values ...string) {
	for i, value := range values {
		text := fmt.Sprintf(".if ${%s:M%s} == \"\"", varname, value)
		mkline := NewMkLine(NewLine("fname", i+1, text, nil))
		valueNovar := mkline.WithoutMakeVariables(value)
		vc := &VartypeCheck{mkline, mkline, varname, opUseMatch, value, valueNovar, "", false}
		checker(vc)
	}
}

func runVartypeChecksFname(fname, varname string, op MkOperator, checker func(*VartypeCheck), values ...string) {
	for i, value := range values {
		mkline := NewMkLine(NewLine(fname, i+1, varname+op.String()+value, nil))
		valueNovar := mkline.WithoutMakeVariables(value)
		vc := &VartypeCheck{mkline, mkline, varname, op, value, valueNovar, "", false}
		checker(vc)
	}
}
