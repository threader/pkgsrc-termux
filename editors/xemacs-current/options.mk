# $NetBSD: options.mk,v 1.15 2017/11/15 14:46:31 hauke Exp $

PKG_OPTIONS_VAR=		PKG_OPTIONS.xemacs
PKG_SUPPORTED_OPTIONS+=		ldap canna debug

.include "../../mk/bsd.options.mk"

# Option "xft" implies "x11".
.if  empty(PKG_OPTIONS:Mx11) && !empty(PKG_OPTIONS:Mxft)
PKG_OPTIONS+=		x11
.endif

###
### Support drawing pretty X11 Lucid widgets
###
PLIST_VARS+=		x11
.if !empty(PKG_OPTIONS:Mx11)
.  include "../../mk/jpeg.buildlink3.mk"
.  include "../../graphics/png/buildlink3.mk"
.  include "../../graphics/tiff/buildlink3.mk"
.  include "../../x11/libXpm/buildlink3.mk"
.  include "../../mk/xaw.buildlink3.mk"
.  include "../../x11/xbitmaps/buildlink3.mk"
PLIST.x11=		yes
CONFIGURE_ARGS+=	--with-x
CONFIGURE_ARGS+=	--with-jpeg
CONFIGURE_ARGS+=	--with-png
CONFIGURE_ARGS+=	--with-tiff
CONFIGURE_ARGS+=	--with-xpm
CONFIGURE_ARGS+=	--with-site-includes=${PREFIX}/include:${X11BASE}/include
CONFIGURE_ARGS+=	--with-site-libraries=${PREFIX}/lib:${X11BASE}/lib
CONFIGURE_ARGS+=	--with-site-runtime-libraries=${PREFIX}/lib:${X11BASE}/lib
# Lucid widgets
CONFIGURE_ARGS+=	--with-toolbars=yes
CONFIGURE_ARGS+=	--with-menubars=yes
CONFIGURE_ARGS+=	--with-scrollbars=lucid
CONFIGURE_ARGS+=	--with-dialogs=lucid
CONFIGURE_ARGS+=	--with-widgets=lucid
CONFIGURE_ARGS+=	--with-athena=xaw
CONFIGURE_ARGS+=	--with-xim=xlib
.else
CONFIGURE_ARGS+=	--without-x
CONFIGURE_ARGS+=	--without-jpeg
CONFIGURE_ARGS+=	--without-png
CONFIGURE_ARGS+=	--without-tiff
CONFIGURE_ARGS+=	--without-xpm
CONFIGURE_ARGS+=	--with-site-includes=${PREFIX}/include
CONFIGURE_ARGS+=	--with-site-libraries=${PREFIX}/lib
CONFIGURE_ARGS+=	--with-site-runtime-libraries=${PREFIX}/lib
.endif

.if !empty(PKG_OPTIONS:Mldap)
CONFIGURE_ARGS+=	--with-ldap
.  include "../../databases/openldap-client/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-ldap
.endif

.if !empty(PKG_OPTIONS:Mxft)
.  include "../../fonts/fontconfig/buildlink3.mk"
.  include "../../graphics/freetype2/buildlink3.mk"
.  include "../../x11/libXft/buildlink3.mk"
.  include "../../x11/libXrender/buildlink3.mk"
CONFIGURE_ARGS+=	--with-xft=emacs,tabs,menubars,gauges
.else
CONFIGURE_ARGS+=	--with-xft=no
.endif

.if !empty(PKG_OPTIONS:Mxface)
CONFIGURE_ARGS+=	--with-xface
.  include "../../mail/faces/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-xface
.endif

PLIST_VARS+=		canna
.if !empty(PKG_OPTIONS:Mcanna)
.  include "../../inputmethod/canna-lib/buildlink3.mk"
CONFIGURE_ARGS+=	--with-canna
PLIST.canna=		yes
.else
CONFIGURE_ARGS+=	--without-canna
.endif

PLIST_VARS+=            debug
.if !empty(PKG_OPTIONS:Mdebug)
CONFIGURE_ARGS+=	--enable-debug=yes --with-debug
CFLAGS+=                -g3
INSTALL_UNSTRIPPED=     yes
.endif
