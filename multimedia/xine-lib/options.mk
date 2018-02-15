# $NetBSD: options.mk,v 1.2 2016/04/19 13:48:31 jperkin Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.xine-lib

PKG_SUPPORTED_OPTIONS=	dts

.include "../../mk/bsd.options.mk"

# Marked NO_BIN_ON_*.  Only enable if you don't want to distribute packages.
PLIST_VARS+=		dts
.if !empty(PKG_OPTIONS:Mdts)
.include "../../audio/libdca/buildlink3.mk"
PLIST.dts=		yes
.else
CONFIGURE_ARGS+=	--disable-dts
.endif
