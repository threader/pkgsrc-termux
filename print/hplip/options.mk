# $NetBSD: options.mk,v 1.13 2017/01/01 14:43:53 wiz Exp $
#
# HPLIP dependencies are detailed in the following page:
# http://hplipopensource.com/hplip-web/install/manual/distros/other.html

PKG_OPTIONS_VAR=	PKG_OPTIONS.hplip
PKG_SUPPORTED_OPTIONS=	fax sane
PKG_SUGGESTED_OPTIONS=	fax
PKG_OPTIONS_GROUP.gui=	qt4 qt5
PKG_OPTIONS_OPTIONAL_GROUPS += gui

PKG_OPTIONS_LEGACY_OPTS+=	scan:sane
PKG_OPTIONS_LEGACY_OPTS+=	gui:qt4
PKG_OPTIONS_LEGACY_OPTS+=	qt:qt4

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mfax)
PLIST_SRC+=		PLIST.fax
CONFIGURE_ARGS+=	--enable-fax-build
CONFIGURE_ARGS+=	--enable-dbus-build
EGFILES+=		cups/pstotiff.convs cups/pstotiff.types
MAKE_DIRS+=		${PKG_SYSCONFDIR}/cups
DEPENDS+=	${PYPKGPREFIX}-reportlab-[0-9]*:../../print/py-reportlab
.include "../../sysutils/dbus/buildlink3.mk"
.include "../../sysutils/py-dbus/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-dbus-build
CONFIGURE_ARGS+=	--disable-fax-build
.endif

.if !empty(PKG_OPTIONS:Msane)
PLIST_SRC+=		PLIST.scan
CONFIGURE_ARGS+=	--enable-scan-build
MESSAGE_SRC+=		MESSAGE.scan
MESSAGE_SUBST+=		EGDIR=${EGDIR}
.include "../../graphics/sane-backends/buildlink3.mk"
DEPENDS+=	{${PYPKGPREFIX}-Pillow-[0-9]*,${PYPKGPREFIX}-imaging-[0-9]*}:../../graphics/py-Pillow
.else
CONFIGURE_ARGS+=	--disable-scan-build
.endif

.if !empty(PKG_OPTIONS:Mqt4) || !empty(PKG_OPTIONS:Mqt5)
CONFIGURE_ARGS+=	--enable-gui-build
CONFIGURE_ARGS+=	--enable-policykit
EGFILES+=		dbus-1/system.d/com.hp.hplip.conf
MAKE_DIRS+=		${PKG_SYSCONFDIR}/dbus-1/system.d
.include "../../security/policykit/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
DEPENDS+=	${PYPKGPREFIX}-notify-[0-9]*:../../sysutils/py-notify
PYTHON_VERSIONS_INCOMPATIBLE=	34 35 36 # py-notify
. if !empty(PKG_OPTIONS:Mqt4)
PLIST_SRC+=		PLIST.qt4
CONFIGURE_ARGS+=	--enable-qt4
.  include "../../x11/py-qt4/buildlink3.mk"
. endif
. if !empty(PKG_OPTIONS:Mqt5)
PLIST_SRC+=		PLIST.qt5
CONFIGURE_ARGS+=	--enable-qt5
.  include "../../x11/py-qt5/buildlink3.mk"
. endif
.else
CONFIGURE_ARGS+=	--disable-policykit
CONFIGURE_ARGS+=	--disable-qt4
CONFIGURE_ARGS+=	--disable-qt5
CONFIGURE_ARGS+=	--disable-gui-build
.endif
