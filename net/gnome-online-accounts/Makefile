# $NetBSD: Makefile,v 1.17 2017/11/30 16:45:33 adam Exp $

DISTNAME=	gnome-online-accounts-3.16.3
PKGREVISION=	13
CATEGORIES=	net devel
MASTER_SITES=	${MASTER_SITE_GNOME:=sources/gnome-online-accounts/3.16/}
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://wiki.gnome.org/Projects/GnomeOnlineAccounts
COMMENT=	Service that allows online accounts to be used with GNOME
LICENSE=	gnu-gpl-v2

BUILD_DEPENDS+=	gtk-doc>=1.3:../../textproc/gtk-doc
TOOL_DEPENDS+=	gdbus-codegen-[0-9]*:../../devel/gdbus-codegen

GNU_CONFIGURE=		yes
USE_LIBTOOL=		yes
USE_PKGLOCALEDIR=	yes
USE_TOOLS+=		gmake intltool pkg-config msgfmt

.include "../../chat/telepathy-glib/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/glib2/schemas.mk"
.include "../../devel/gobject-introspection/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"
.include "../../security/libsecret/buildlink3.mk"
.include "../../sysutils/dbus-glib/buildlink3.mk"
.include "../../textproc/json-glib/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/librest07/buildlink3.mk"
.include "../../www/webkit-gtk/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
