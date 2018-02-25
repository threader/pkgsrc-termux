#	$NetBSD: bsd.hostprog.mk,v 1.1.1.1 2006/07/14 23:13:00 jlam Exp $
#	@(#)bsd.prog.mk	8.2 (Berkeley) 4/2/94

.if !target(__initialized__)
__initialized__:
.if exists(${.CURDIR}/../Makefile.inc)
.include "${.CURDIR}/../Makefile.inc"
.endif
.include <bsd.own.mk>
.include <bsd.obj.mk>
.include <bsd.depall.mk>
.MAIN:		all
.endif

.PHONY:		cleanprog 
clean cleandir: cleanprog

CFLAGS+=	${COPTS}

LIBBZ2?=	/data/data/com.termux/files/usr/lib/libbz2.a
LIBC?=		/data/data/com.termux/files/usr/lib/libc.a
LIBC_PIC?=	/data/data/com.termux/files/usr/lib/libc_pic.a
LIBCDK?=	/data/data/com.termux/files/usr/lib/libcdk.a
LIBCOMPAT?=	/data/data/com.termux/files/usr/lib/libcompat.a
LIBCRYPT?=	/data/data/com.termux/files/usr/lib/libcrypt.a
LIBCURSES?=	/data/data/com.termux/files/usr/lib/libcurses.a
LIBDBM?=	/data/data/com.termux/files/usr/lib/libdbm.a
LIBDES?=	/data/data/com.termux/files/usr/lib/libdes.a
LIBEDIT?=	/data/data/com.termux/files/usr/lib/libedit.a
LIBFORM?=	/data/data/com.termux/files/usr/lib/libform.a
LIBGCC?=	/data/data/com.termux/files/usr/lib/libgcc.a
LIBGNUMALLOC?=	/data/data/com.termux/files/usr/lib/libgnumalloc.a
LIBINTL?=	/data/data/com.termux/files/usr/lib/libintl.a
LIBIPSEC?=	/data/data/com.termux/files/usr/lib/libipsec.a
LIBKDB?=	/data/data/com.termux/files/usr/lib/libkdb.a
LIBKRB?=	/data/data/com.termux/files/usr/lib/libkrb.a
LIBKVM?=	/data/data/com.termux/files/usr/lib/libkvm.a
LIBL?=		/data/data/com.termux/files/usr/lib/libl.a
LIBM?=		/data/data/com.termux/files/usr/lib/libm.a
LIBMENU?=	/data/data/com.termux/files/usr/lib/libmenu.a
LIBMP?=		/data/data/com.termux/files/usr/lib/libmp.a
LIBNTP?=	/data/data/com.termux/files/usr/lib/libntp.a
LIBOBJC?=	/data/data/com.termux/files/usr/lib/libobjc.a
LIBPC?=		/data/data/com.termux/files/usr/lib/libpc.a
LIBPCAP?=	/data/data/com.termux/files/usr/lib/libpcap.a
LIBPLOT?=	/data/data/com.termux/files/usr/lib/libplot.a
LIBPOSIX?=	/data/data/com.termux/files/usr/lib/libposix.a
LIBRESOLV?=	/data/data/com.termux/files/usr/lib/libresolv.a
LIBRPCSVC?=	/data/data/com.termux/files/usr/lib/librpcsvc.a
LIBSKEY?=	/data/data/com.termux/files/usr/lib/libskey.a
LIBTERMCAP?=	/data/data/com.termux/files/usr/lib/libtermcap.a
LIBTELNET?=	/data/data/com.termux/files/usr/lib/libtelnet.a
LIBUTIL?=	/data/data/com.termux/files/usr/lib/libutil.a
LIBWRAP?=	/data/data/com.termux/files/usr/lib/libwrap.a
LIBY?=		/data/data/com.termux/files/usr/lib/liby.a
LIBZ?=		/data/data/com.termux/files/usr/lib/libz.a

.if defined(SHAREDSTRINGS)
CLEANFILES+=strings
.c.lo:
	${HOST_CC} -E ${CFLAGS} ${.IMPSRC} | xstr -c -
	@${HOST_CC} ${CFLAGS} -c x.c -o ${.TARGET}
	@rm -f x.c

.cc.lo:
	${HOST_CXX} -E ${CXXFLAGS} ${.IMPSRC} | xstr -c -
	@mv -f x.c x.cc
	@${HOST_CXX} ${CXXFLAGS} -c x.cc -o ${.TARGET}
	@rm -f x.cc

.C.lo:
	${HOST_CXX} -E ${CXXFLAGS} ${.IMPSRC} | xstr -c -
	@mv -f x.c x.C
	@${HOST_CXX} ${CXXFLAGS} -c x.C -o ${.TARGET}
	@rm -f x.C
.endif


.if defined(HOSTPROG)
SRCS?=		${HOSTPROG}.c

DPSRCS+=	${SRCS:M*.l:.l=.c} ${SRCS:M*.y:.y=.c}
CLEANFILES+=	${DPSRCS}
.if defined(YHEADER)
CLEANFILES+=	${SRCS:M*.y:.y=.h}
.endif

.if !empty(SRCS:N*.h:N*.sh)
OBJS+=		${SRCS:N*.h:N*.sh:R:S/$/.lo/g}
LOBJS+=		${LSRCS:.c=.ln} ${SRCS:M*.c:.c=.ln}
.endif

.if defined(OBJS) && !empty(OBJS)
.NOPATH: ${OBJS}

${HOSTPROG}: ${DPSRCS} ${OBJS} ${LIBC} ${DPADD}
	${HOST_LINK.c} ${HOST_LDSTATIC} -o ${.TARGET} ${OBJS} ${LDADD}

.endif	# defined(OBJS) && !empty(OBJS)

.if !defined(MAN)
MAN=	${HOSTPROG}.1
.endif	# !defined(MAN)
.endif	# defined(HOSTPROG)

realall: ${HOSTPROG}

cleanprog:
	rm -f a.out [Ee]rrs mklog core *.core \
	    ${HOSTPROG} ${OBJS} ${LOBJS} ${CLEANFILES}

beforedepend:
CPPFLAGS=	${HOST_CPPFLAGS}

.if defined(SRCS)
afterdepend: .depend
	@(TMP=/data/data/com.termux/files/usr/tmp/_depend$$$$; \
	    sed -e 's/^\([^\.]*\).o[ ]*:/\1.lo \1.ln:/' \
	      < .depend > $$TMP; \
	    mv $$TMP .depend)
.endif

lint: ${LOBJS}
.if defined(LOBJS) && !empty(LOBJS)
	${LINT} ${LINTFLAGS} ${LDFLAGS:M-L*} ${LOBJS} ${LDADD}
.endif

.include <bsd.man.mk>
.include <bsd.nls.mk>
.include <bsd.files.mk>
.include <bsd.inc.mk>
.include <bsd.links.mk>
.include <bsd.dep.mk>
.include <bsd.sys.mk>

# Make sure all of the standard targets are defined, even if they do nothing.
regress:
