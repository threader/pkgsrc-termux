# $NetBSD: options.mk,v 1.2 2017/09/05 04:22:09 dholland Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.lablgtk
PKG_SUPPORTED_OPTIONS=	glade gnomecanvas gtksourceview gtksourceview2 gtkspell svg gnome
PKG_SUGGESTED_OPTIONS=	glade gnomecanvas gtksourceview gtksourceview2 gtkspell svg gnome

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mglade)
.include "../../devel/libglade/buildlink3.mk"
CONFIGURE_ARGS+=	--with-glade
PLIST_SRC+=		PLIST.glade
.else
CONFIGURE_ARGS+=	--without-glade
.endif

.if !empty(PKG_OPTIONS:Mgtkspell)
.include "../../textproc/gtkspell/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gtkspell
PLIST_SRC+=		PLIST.gtkspell
.else
CONFIGURE_ARGS+=	--without-gtkspell
.endif

.if !empty(PKG_OPTIONS:Mgnomecanvas)
.include "../../graphics/libgnomecanvas/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gnomecanvas
PLIST_SRC+=		PLIST.gnomecanvas
.else
CONFIGURE_ARGS+=	--without-gnomecanvas
.endif

# Note: it looks like it should work to split these, but I don't
# want to build gnome-panel tonight to check.
.if !empty(PKG_OPTIONS:Mgnome)
.include "../../devel/libgnomeui/buildlink3.mk"
.include "../../x11/gnome-panel/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gnomeui --with-panel
PLIST_SRC+=		PLIST.gnome
PLIST_SRC+=		PLIST.gnomepanel
.else
CONFIGURE_ARGS+=	--without-gnomeui --without-panel
.endif

.if !empty(PKG_OPTIONS:Mgtksourceview)
.include "../../x11/gtksourceview/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gtksourceview
PLIST_SRC+=		PLIST.gtksourceview
.else
CONFIGURE_ARGS+=	--without-gtksourceview
.endif

.if !empty(PKG_OPTIONS:Mgtksourceview2)
.include "../../x11/gtksourceview2/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gtksourceview2
PLIST_SRC+=		PLIST.gtksourceview2
.else
CONFIGURE_ARGS+=	--without-gtksourceview2
.endif

.if !empty(PKG_OPTIONS:Msvg)
.include "../../graphics/librsvg/buildlink3.mk"
CONFIGURE_ARGS+=	--with-rsvg
PLIST_SRC+=		PLIST.svg
.else
CONFIGURE_ARGS+=	--without-rsvg
.endif

PLIST_SRC+=	PLIST
