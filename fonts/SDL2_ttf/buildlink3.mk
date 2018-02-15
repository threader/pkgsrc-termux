# $NetBSD: buildlink3.mk,v 1.5 2016/01/17 15:21:34 wiz Exp $

BUILDLINK_TREE+=	SDL2_ttf

.if !defined(SDL2_TTF_BUILDLINK3_MK)
SDL2_TTF_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.SDL2_ttf+=	SDL2_ttf>=2.0.12
BUILDLINK_ABI_DEPENDS.SDL2_ttf+=	SDL2_ttf>=2.0.12nb2
BUILDLINK_PKGSRCDIR.SDL2_ttf?=	../../fonts/SDL2_ttf

.include "../../devel/SDL2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.endif # SDL2_TTF_BUILDLINK3_MK

BUILDLINK_TREE+=	-SDL2_ttf
