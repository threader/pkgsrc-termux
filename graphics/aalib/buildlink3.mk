# $NetBSD: buildlink3.mk,v 1.15 2015/08/18 07:31:00 wiz Exp $

BUILDLINK_TREE+=	aalib

.if !defined(AALIB_BUILDLINK3_MK)
AALIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.aalib+=	aalib>=1.4.0.4
BUILDLINK_ABI_DEPENDS.aalib+=	aalib>=1.4.0.5nb4
BUILDLINK_PKGSRCDIR.aalib?=	../../graphics/aalib

pkgbase := aalib
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.aalib:Mcurses)
.  include "../../mk/curses.buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.aalib:Mslang)
.  include "../../devel/libslang/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.aalib:Mx11)
.  include "../../x11/libX11/buildlink3.mk"
.endif
.endif # AALIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-aalib
