# $NetBSD: buildlink3.mk,v 1.26 2017/08/15 17:24:03 wiz Exp $

BUILDLINK_TREE+=	lesstif

.if !defined(LESSTIF_BUILDLINK3_MK)
LESSTIF_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.lesstif+=	lesstif>=0.95.0nb1
BUILDLINK_ABI_DEPENDS.lesstif+=	lesstif>=0.95.2nb4
BUILDLINK_PKGSRCDIR.lesstif?=	../../x11/lesstif

_MOTIFBASE=	${BUILDLINK_PREFIX.lesstif}
MOTIFLIB=	${COMPILER_RPATH_FLAG}${_MOTIFBASE}/lib \
		-L${_MOTIFBASE}/lib -lXm

.include "../../fonts/fontconfig/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libXrender/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"
.endif # LESSTIF_BUILDLINK3_MK

BUILDLINK_TREE+=	-lesstif
