# $NetBSD: bjam.mk,v 1.19 2017/07/14 18:18:57 wiz Exp $

.include "../../devel/boost-jam/buildlink3.mk"
.include "../../devel/boost-build/toolset.mk"

BJAM=			${BUILDLINK_PREFIX.boost-jam}/bin/bjam

BJAM_ARGS+=		${MAKE_JOBS:D-j${MAKE_JOBS}}
BJAM_ARGS+=		--builddir=${WRKSRC}/build
BJAM_ARGS+=		--layout=system
BJAM_ARGS+=		--toolset=${BOOST_TOOLSET}
BJAM_ARGS+=		--disable-long-double
BJAM_ARGS+=		${BJAM_BUILD}

# XXX: we can't use USE_LANGUAGES here as it needs to be set before
# including compiler.mk.  Perhaps we should just enforce c++11?
#
.include "../../mk/compiler.mk"

.if !empty(PKGSRC_COMPILER:Mgcc)
.  if !empty(CC_VERSION:Mgcc-4.[4-7]*)
BJAM_ARGS+=		cxxflags=-std=c++0x
CXXFLAGS+=		-std=c++0x
.  elif !empty(CC_VERSION:Mgcc-4.[89]*)
BJAM_ARGS+=		cxxflags=-std=c++11
CXXFLAGS+=		-std=c++11
.  elif !empty(CC_VERSION:Mgcc-5.[0-9]*)
BJAM_ARGS+=		cxxflags=-std=c++14
CXXFLAGS+=		-std=c++14
.  endif
.endif

.if !empty(PKGSRC_COMPILER:Mclang)
BJAM_ARGS+=		cxxflags=-std=c++11
CXXFLAGS+=		-std=c++11
.  if ${OPSYS} == "Darwin"
BJAM_ARGS+=		cxxflags=-stdlib=libc++ linkflags=-stdlib=libc++
.  endif
.endif

BJAM_BUILD+=		variant=release
BJAM_BUILD+=		threading=multi
BJAM_BUILD+=		link=shared,static
BJAM_BUILD+=		linkflags=${LDFLAGS:Q}

BJAM_CMD=		${SETENV} ${MAKE_ENV} ${BJAM} ${BJAM_ARGS}

UNLIMIT_RESOURCES+=	datasize

bjam-build:
	${_ULIMIT_CMD} \
	cd ${WRKSRC} && ${BJAM_CMD} --prefix=${PREFIX} stage

bjam-install:
	${_ULIMIT_CMD} \
	cd ${WRKSRC} && ${BJAM_CMD} --prefix=${DESTDIR}${PREFIX} install
