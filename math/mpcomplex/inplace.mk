# $NetBSD: inplace.mk,v 1.4 2015/09/15 20:56:33 joerg Exp $
#
# Include this file to extract math/mpcomplex source into the WRKSRC of
# another package. This is to be used by GCC packages to avoid the numerous
# dependencies math/mpcomplex has.

post-fetch: fetch-inplace-mpcomplex

post-extract: extract-inplace-mpcomplex

fetch-inplace-mpcomplex:
	(cd ../../math/mpcomplex && ${MAKE} WRKDIR=${WRKSRC}/.devel.mpcomplex EXTRACT_DIR=${WRKSRC} \
		WRKSRC='$${EXTRACT_DIR}/$${DISTNAME}' SKIP_DEPENDS=YES checksum)

extract-inplace-mpcomplex:
	(cd ../../math/mpcomplex && ${MAKE} WRKDIR=${WRKSRC}/.devel.mpcomplex EXTRACT_DIR=${WRKSRC} \
		WRKSRC='$${EXTRACT_DIR}/$${DISTNAME}' SKIP_DEPENDS=YES patch)
	${MV} ${WRKSRC}/mpc-* ${WRKSRC}/mpc
