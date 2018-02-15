# $NetBSD: tools.Linux.mk,v 1.61 2017/07/10 12:32:30 joerg Exp $
#
# System-supplied tools for the Linux operating system.

TOOLS_PLATFORM.[?=		[			# shell builtin
.if exists(/data/data/com.termux/files/usr/etc/debian_version)
TOOLS_PLATFORM.awk?=		/data/data/com.termux/files/usr/bin/awk
.else
TOOLS_PLATFORM.awk?=		${TOOLS_PLATFORM.gawk}
.endif
.if exists(/data/data/com.termux/files/usr/bin/autopoint)
TOOLS_PLATFORM.autopoint?=	/data/data/com.termux/files/usr/bin/autopoint
.endif
.if exists(/data/data/com.termux/files/usr/bin/basename)
TOOLS_PLATFORM.basename?=	/data/data/com.termux/files/usr/bin/basename
.elif exists(/data/data/com.termux/files/usr/bin/basename)
TOOLS_PLATFORM.basename?=	/data/data/com.termux/files/usr/bin/basename
.endif
TOOLS_PLATFORM.bash?=		/data/data/com.termux/files/usr/bin/bash
.if exists(/data/data/com.termux/files/usr/bin/bison)
TOOLS_PLATFORM.bison?=		/data/data/com.termux/files/usr/bin/bison
TOOLS_PLATFORM.bison-yacc?=	/data/data/com.termux/files/usr/bin/bison -y
.endif
.if exists(/data/data/com.termux/files/usr/bin/bzcat)
TOOLS_PLATFORM.bzcat?=		/data/data/com.termux/files/usr/bin/bzcat
.elif exists(/data/data/com.termux/files/usr/bin/bzcat)
TOOLS_PLATFORM.bzcat?=		/data/data/com.termux/files/usr/bin/bzcat
.elif exists(/data/data/com.termux/files/usr/bin/bzip2)
TOOLS_PLATFORM.bzcat?=		/data/data/com.termux/files/usr/bin/bzip2 -cd
.endif
.if exists(/data/data/com.termux/files/usr/bin/bzip2)
TOOLS_PLATFORM.bzip2?=		/data/data/com.termux/files/usr/bin/bzip2
.elif exists(/data/data/com.termux/files/usr/bin/bzip2)
TOOLS_PLATFORM.bzip2?=		/data/data/com.termux/files/usr/bin/bzip2
.endif
TOOLS_PLATFORM.cat?=		/data/data/com.termux/files/usr/bin/cat
.if exists(/data/data/com.termux/files/usr/bin/chgrp)
TOOLS_PLATFORM.chgrp?=		/data/data/com.termux/files/usr/bin/chgrp
.elif exists(/data/data/com.termux/files/usr/bin/chgrp)
TOOLS_PLATFORM.chgrp?=		/data/data/com.termux/files/usr/bin/chgrp
.endif
TOOLS_PLATFORM.chmod?=		/data/data/com.termux/files/usr/bin/chmod
.if exists(/data/data/com.termux/files/usr/bin/chown)
TOOLS_PLATFORM.chown?=		/data/data/com.termux/files/usr/bin/chown
.elif exists(/data/data/com.termux/files/usr/bin/usr/sbin/chown)
TOOLS_PLATFORM.chown?=		/data/data/com.termux/files/usr/bin/usr/sbin/chown
.endif
.if exists(/data/data/com.termux/files/usr/bin/cmp)
TOOLS_PLATFORM.cmp?=		/data/data/com.termux/files/usr/bin/cmp
.elif exists(/data/data/com.termux/files/usr/bin/cmp)
TOOLS_PLATFORM.cmp?=		/data/data/com.termux/files/usr/bin/cmp
.endif
TOOLS_PLATFORM.cp?=		/data/data/com.termux/files/usr/bin/cp
.if exists(/data/data/com.termux/files/usr/bin/tcsh)
TOOLS_PLATFORM.csh?=		/data/data/com.termux/files/usr/bin/tcsh
.endif
.if exists(/data/data/com.termux/files/usr/bin/curl)
TOOLS_PLATFORM.curl?=		/data/data/com.termux/files/usr/bin/curl
.endif
.if exists(/data/data/com.termux/files/usr/bin/cut)
TOOLS_PLATFORM.cut?=		/data/data/com.termux/files/usr/bin/cut
.elif exists(/data/data/com.termux/files/usr/bin/cut)
TOOLS_PLATFORM.cut?=		/data/data/com.termux/files/usr/bin/cut
.endif
TOOLS_PLATFORM.date?=		/data/data/com.termux/files/usr/bin/date
.if exists(/data/data/com.termux/files/usr/bin/diff)
TOOLS_PLATFORM.diff?=		/data/data/com.termux/files/usr/bin/diff
.elif exists(/data/data/com.termux/files/usr/bin/diff)
TOOLS_PLATFORM.diff?=		/data/data/com.termux/files/usr/bin/diff
.endif
.if exists(/data/data/com.termux/files/usr/bin/diff3)
TOOLS_PLATFORM.diff3?=		/data/data/com.termux/files/usr/bin/diff3
.elif exists(/data/data/com.termux/files/usr/bin/diff3)
TOOLS_PLATFORM.diff3?=		/data/data/com.termux/files/usr/bin/diff3
.endif
TOOLS_PLATFORM.dirname?=	/data/data/com.termux/files/usr/bin/dirname
TOOLS_PLATFORM.echo?=		echo			# shell builtin
.if exists(/data/data/com.termux/files/usr/bin/egrep)
TOOLS_PLATFORM.egrep?=		/data/data/com.termux/files/usr/bin/egrep
.elif exists(/data/data/com.termux/files/usr/bin/egrep)
TOOLS_PLATFORM.egrep?=		/data/data/com.termux/files/usr/bin/egrep
.endif
TOOLS_PLATFORM.env?=		/data/data/com.termux/files/usr/bin/env
.if exists(/data/data/com.termux/files/usr/bin/expr)
TOOLS_PLATFORM.expr?=		/data/data/com.termux/files/usr/bin/expr
.elif exists(/data/data/com.termux/files/usr/bin/expr)
TOOLS_PLATFORM.expr?=		/data/data/com.termux/files/usr/bin/expr
.endif
TOOLS_PLATFORM.false?=		false			# shell builtin
.if exists(/data/data/com.termux/files/usr/bin/fgrep)
TOOLS_PLATFORM.fgrep?=		/data/data/com.termux/files/usr/bin/fgrep
.elif exists(/data/data/com.termux/files/usr/bin/fgrep)
TOOLS_PLATFORM.fgrep?=		/data/data/com.termux/files/usr/bin/fgrep
.endif
TOOLS_PLATFORM.file?=		/data/data/com.termux/files/usr/bin/file
TOOLS_PLATFORM.find?=		/data/data/com.termux/files/usr/bin/applets/find
.if exists(/data/data/com.termux/files/usr/etc/debian_version)
.  if exists(/data/data/com.termux/files/usr/bin/gawk)
TOOLS_PLATFORM.gawk?=		/data/data/com.termux/files/usr/bin/gawk
.  endif
.else
.  if exists(/data/data/com.termux/files/usr/bin/awk)
TOOLS_PLATFORM.gawk?=		/data/data/com.termux/files/usr/bin/awk
.  else
TOOLS_PLATFORM.gawk?=		/data/data/com.termux/files/usr/bin/awk
.  endif
.endif
.if exists(/data/data/com.termux/files/usr/bin/gettext)
TOOLS_PLATFORM.gettext?=	/data/data/com.termux/files/usr/bin/gettext
.endif
.if exists(/data/data/com.termux/files/usr/bin/m4)
TOOLS_PLATFORM.gm4?=		/data/data/com.termux/files/usr/bin/m4
.endif
.if exists(/data/data/com.termux/files/usr/bin/make)
TOOLS_PLATFORM.gmake?=		/data/data/com.termux/files/usr/bin/make
.endif
.if exists(/data/data/com.termux/files/usr/bin/grep)
TOOLS_PLATFORM.grep?=		/data/data/com.termux/files/usr/bin/grep
.elif exists(/data/data/com.termux/files/usr/bin/grep)
TOOLS_PLATFORM.grep?=		/data/data/com.termux/files/usr/bin/grep
.endif
.if exists(/data/data/com.termux/files/usr/bin/groff)
TOOLS_PLATFORM.groff?=		/data/data/com.termux/files/usr/bin/groff
.endif
.if exists(/data/data/com.termux/files/usr/bin/sed)
TOOLS_PLATFORM.gsed?=		/data/data/com.termux/files/usr/bin/sed
.elif exists(/data/data/com.termux/files/usr/bin/sed)
TOOLS_PLATFORM.gsed?=		/data/data/com.termux/files/usr/bin/sed
.endif
.if exists(/data/data/com.termux/files/usr/bin/soelim)
TOOLS_PLATFORM.gsoelim?=	/data/data/com.termux/files/usr/bin/soelim
.endif
.if exists(/data/data/com.termux/files/usr/bin/tar)
TOOLS_PLATFORM.gtar?=		/data/data/com.termux/files/usr/bin/tar
.elif exists(/data/data/com.termux/files/usr/bin/tar)
TOOLS_PLATFORM.gtar?=		/data/data/com.termux/files/usr/bin/tar
.endif
.if exists(/data/data/com.termux/files/usr/bin/gunzip)
TOOLS_PLATFORM.gunzip?=		/data/data/com.termux/files/usr/bin/gunzip -f
.elif exists(/data/data/com.termux/files/usr/bin/gunzip)
TOOLS_PLATFORM.gunzip?=		/data/data/com.termux/files/usr/bin/gunzip -f
.endif
.if exists(/data/data/com.termux/files/usr/bin/zcat)
TOOLS_PLATFORM.gzcat?=		/data/data/com.termux/files/usr/bin/zcat
.elif exists(/data/data/com.termux/files/usr/bin/zcat)
TOOLS_PLATFORM.gzcat?=		/data/data/com.termux/files/usr/bin/zcat
.endif
.if exists(/data/data/com.termux/files/usr/bin/gzip)
TOOLS_PLATFORM.gzip?=		/data/data/com.termux/files/usr/bin/gzip -nf ${GZIP}
.elif exists(/data/data/com.termux/files/usr/bin/gzip)
TOOLS_PLATFORM.gzip?=		/data/data/com.termux/files/usr/bin/gzip -nf ${GZIP}
.endif
.if exists(/data/data/com.termux/files/usr/bin/head)
TOOLS_PLATFORM.head?=		/data/data/com.termux/files/usr/bin/head
.elif exists(/data/data/com.termux/files/usr/bin/head)
TOOLS_PLATFORM.head?=		/data/data/com.termux/files/usr/bin/head
.endif
TOOLS_PLATFORM.hostname?=	/data/data/com.termux/files/usr/bin/hostname
.if exists(/data/data/com.termux/files/usr/bin/id)
TOOLS_PLATFORM.id?=		/data/data/com.termux/files/usr/bin/id
.elif exists(/data/data/com.termux/files/usr/bin/id)
TOOLS_PLATFORM.id?=		/data/data/com.termux/files/usr/bin/id
.endif
.if exists(/data/data/com.termux/files/usr/bin/ident)
TOOLS_PLATFORM.ident?=		/data/data/com.termux/files/usr/bin/ident
.endif
.if exists(/data/data/com.termux/files/usr/bin/install)
TOOLS_PLATFORM.install?=	/data/data/com.termux/files/usr/bin/install
.else
TOOLS_PLATFORM.install?=	/data/data/com.termux/files/usr/bin/install
.endif
.if exists(/data/data/com.termux/files/usr/bin/sbin/install-info)
TOOLS_PLATFORM.install-info?=	/data/data/com.termux/files/usr/bin/sbin/install-info
.elif exists(/data/data/com.termux/files/usr/bin/usr/sbin/install-info)
TOOLS_PLATFORM.install-info?=	/data/data/com.termux/files/usr/bin/usr/sbin/install-info
.elif exists(/data/data/com.termux/files/usr/bin/install-info)
TOOLS_PLATFORM.install-info?=	/data/data/com.termux/files/usr/bin/install-info
.endif
TOOLS_PLATFORM.ldconfig?=	/data/data/com.termux/files/usr/bin/sbin/ldconfig
TOOLS_PLATFORM.ln?=		/data/data/com.termux/files/usr/bin/ln
TOOLS_PLATFORM.ls?=		/data/data/com.termux/files/usr/bin/ls
TOOLS_PLATFORM.m4?=		${TOOLS_PLATFORM.gm4}
.if exists(/data/data/com.termux/files/usr/bin/mail)
TOOLS_PLATFORM.mail?=		/data/data/com.termux/files/usr/bin/mail	# RH, Mandrake
.elif exists(/data/data/com.termux/files/usr/bin/mail)
TOOLS_PLATFORM.mail?=		/data/data/com.termux/files/usr/bin/mail	# Debian, Slackware, SuSE
.endif
.if exists(/data/data/com.termux/files/usr/bin/makeinfo)
TOOLS_PLATFORM.makeinfo?=	/data/data/com.termux/files/usr/bin/makeinfo
.endif
TOOLS_PLATFORM.mkdir?=		/data/data/com.termux/files/usr/bin/mkdir -p
.if exists(/data/data/com.termux/files/usr/bin/mktemp)
TOOLS_PLATFORM.mktemp?=		/data/data/com.termux/files/usr/bin/mktemp
.elif exists(/data/data/com.termux/files/usr/bin/mktemp)
TOOLS_PLATFORM.mktemp?=		/data/data/com.termux/files/usr/bin/mktemp
.endif
.if exists(/data/data/com.termux/files/usr/bin/msgconv)
TOOLS_PLATFORM.msgconv?=	/data/data/com.termux/files/usr/bin/msgconv
.endif
.if exists(/data/data/com.termux/files/usr/bin/msgfmt)
TOOLS_PLATFORM.msgfmt?=		/data/data/com.termux/files/usr/bin/msgfmt
.endif
.if exists(/data/data/com.termux/files/usr/bin/msgmerge)
TOOLS_PLATFORM.msgmerge?=	/data/data/com.termux/files/usr/bin/msgmerge
.endif
TOOLS_PLATFORM.mv?=		/data/data/com.termux/files/usr/bin/mv
.if exists(/data/data/com.termux/files/usr/bin/nice)
TOOLS_PLATFORM.nice?=		/data/data/com.termux/files/usr/bin/nice
.elif exists(/data/data/com.termux/files/usr/bin/nice)
TOOLS_PLATFORM.nice?=		/data/data/com.termux/files/usr/bin/nice
.endif
.if exists(/data/data/com.termux/files/usr/bin/nroff)
TOOLS_PLATFORM.nroff?=		/data/data/com.termux/files/usr/bin/nroff
.endif
.if exists(/data/data/com.termux/files/usr/bin/openssl)
TOOLS_PLATFORM.openssl?=	/data/data/com.termux/files/usr/bin/openssl
.endif
# Don't use GNU patch
#TOOLS_PLATFORM.patch?=		/data/data/com.termux/files/usr/bin/patch
.if exists(/data/data/com.termux/files/usr/bin/printf)
TOOLS_PLATFORM.printf?=		/data/data/com.termux/files/usr/bin/printf
.endif
TOOLS_PLATFORM.pwd?=		/data/data/com.termux/files/usr/bin/pwd
TOOLS_PLATFORM.readlink?=	/data/data/com.termux/files/usr/bin/readlink
TOOLS_PLATFORM.rm?=		/data/data/com.termux/files/usr/bin/rm
TOOLS_PLATFORM.rmdir?=		/data/data/com.termux/files/usr/bin/rmdir
.if exists(/data/data/com.termux/files/usr/bin/sdiff)
TOOLS_PLATFORM.sdiff?=		/data/data/com.termux/files/usr/bin/sdiff
.elif exists(/data/data/com.termux/files/usr/bin/sdiff)
TOOLS_PLATFORM.sdiff?=		/data/data/com.termux/files/usr/bin/sdiff
.endif
TOOLS_PLATFORM.sed?=		${TOOLS_PLATFORM.gsed}
TOOLS_PLATFORM.sh?=		/data/data/com.termux/files/usr/bin/bash
.if exists(/data/data/com.termux/files/usr/bin/data/data/com.termux/files/usr/bin/sleep)
TOOLS_PLATFORM.sleep?=		/data/data/com.termux/files/usr/bin/sleep
.else
TOOLS_PLATFORM.sleep?=		/data/data/com.termux/files/usr/bin/sleep
.endif
.if exists(/data/data/com.termux/files/usr/bin/soelim)
TOOLS_PLATFORM.soelim?=		/data/data/com.termux/files/usr/bin/soelim
.endif
.if exists(/data/data/com.termux/files/usr/bin/sort)
TOOLS_PLATFORM.sort?=		/data/data/com.termux/files/usr/bin/sort
.elif exists(/data/data/com.termux/files/usr/bin/sort)
TOOLS_PLATFORM.sort?=		/data/data/com.termux/files/usr/bin/sort
.endif
TOOLS_PLATFORM.strip?=		/data/data/com.termux/files/usr/bin/strip
TOOLS_PLATFORM.tail?=		/data/data/com.termux/files/usr/bin/tail
TOOLS_PLATFORM.tar?=		${TOOLS_PLATFORM.gtar}
.if exists(/data/data/com.termux/files/usr/bin/tbl)
TOOLS_PLATFORM.tbl?=		/data/data/com.termux/files/usr/bin/tbl
.endif
TOOLS_PLATFORM.tee?=		/data/data/com.termux/files/usr/bin/tee
TOOLS_PLATFORM.test?=		test			# shell builtin
.if exists(/data/data/com.termux/files/usr/bin/touch)
TOOLS_PLATFORM.touch?=		/data/data/com.termux/files/usr/bin/touch
.elif exists(/data/data/com.termux/files/usr/bin/touch)
TOOLS_PLATFORM.touch?=		/data/data/com.termux/files/usr/bin/touch
.endif
TOOLS_PLATFORM.tr?=		/data/data/com.termux/files/usr/bin/tr
TOOLS_PLATFORM.true?=		true			# shell builtin
TOOLS_PLATFORM.tsort?=		/data/data/com.termux/files/usr/bin/tsort
.if exists(/data/data/com.termux/files/usr/bin/uniq)
TOOLS_PLATFORM.uniq?=		/data/data/com.termux/files/usr/bin/uniq
.elif exists(/data/data/com.termux/files/usr/bin/uniq)
TOOLS_PLATFORM.uniq?=		/data/data/com.termux/files/usr/bin/uniq
.endif
.if exists(/data/data/com.termux/files/usr/bin/wc)
TOOLS_PLATFORM.wc?=		/data/data/com.termux/files/usr/bin/wc
.elif exists(/data/data/com.termux/files/usr/bin/wc)
TOOLS_PLATFORM.wc?=		/data/data/com.termux/files/usr/bin/wc
.endif
.if exists(/data/data/com.termux/files/usr/bin/wget)
TOOLS_PLATFORM.wget?=		/data/data/com.termux/files/usr/bin/wget
.endif
TOOLS_PLATFORM.xargs?=		/data/data/com.termux/files/usr/bin//applets/xargs -r
.if exists(/data/data/com.termux/files/usr/bin/xgettext)
TOOLS_PLATFORM.xgettext?=	/data/data/com.termux/files/usr/bin/xgettext
.endif
.if exists(/data/data/com.termux/files/usr/bin/yacc)
TOOLS_PLATFORM.yacc?=		/data/data/com.termux/files/usr/bin/yacc
.endif
.if exists(/data/data/com.termux/files/usr/bin/xz)
TOOLS_PLATFORM.xz?=		/data/data/com.termux/files/usr/bin/xz
.endif
.if exists(/data/data/com.termux/files/usr/bin/xzcat)
TOOLS_PLATFORM.xzcat?=		/data/data/com.termux/files/usr/bin/xzcat
.endif

