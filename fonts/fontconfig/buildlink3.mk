# $NetBSD: buildlink3.mk,v 1.33 2013/06/04 22:16:02 tron Exp $

BUILDLINK_TREE+=	fontconfig

.if !defined(FONTCONFIG_BUILDLINK3_MK)
FONTCONFIG_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.fontconfig+=	fontconfig>=2.10.93
BUILDLINK_ABI_DEPENDS.fontconfig+=	fontconfig>=2.10.93nb2
BUILDLINK_PKGSRCDIR.fontconfig?=	../../fonts/fontconfig

.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.endif # FONTCONFIG_BUILDLINK3_MK

BUILDLINK_TREE+=	-fontconfig
