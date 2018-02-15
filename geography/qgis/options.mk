# $NetBSD: options.mk,v 1.8 2017/01/01 14:43:41 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.qgis
PKG_SUPPORTED_OPTIONS=	python
# Don't enable python by default because it is not
# supported by gdal-lib and as a result we get a
# warning when qgis is launched.
# XXX fix gdal-lib and reenable this.
#PKG_SUGGESTED_OPTIONS+= python

.include "../../mk/bsd.options.mk"

.if empty(PKG_OPTIONS:Mpython)
CMAKE_ARGS+=		-DWITH_BINDINGS:BOOL=FALSE
PYTHON_FOR_BUILD_ONLY=	YES
.include "../../lang/python/application.mk"
.else
CMAKE_ARGS+=		-DWITH_BINDINGS:BOOL=TRUE
CMAKE_ARGS+=		-DSIP_BINARY_PATH:PATH=${BUILDLINK_PREFIX.py-sip}/bin
PLIST_SRC+=             ${PKGDIR}/PLIST.python
#PYTHON_VERSIONS_INCOMPATIBLE=	34 35 36 # ?not yet ported as of ?
.include "../../lang/python/application.mk"
.include "../../math/py-numpy/buildlink3.mk"
.include "../../x11/py-qt4/buildlink3.mk"
.include "../../x11/py-qt4-qscintilla/buildlink3.mk"
.include "../../x11/py-sip/buildlink3.mk"
.endif
