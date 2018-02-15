# $NetBSD: buildlink3.mk,v 1.8 2012/10/23 10:24:19 wiz Exp $

.include "../../mk/bsd.fast.prefs.mk"

BUILDLINK_TREE+=	libXtst

.if !defined(LIBXTST_BUILDLINK3_MK)
LIBXTST_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libXtst+=	libXtst>=1.0.1
BUILDLINK_PKGSRCDIR.libXtst?=	../../x11/libXtst

.include "../../x11/recordproto/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libXi/buildlink3.mk"
.endif # LIBXTST_BUILDLINK3_MK

BUILDLINK_TREE+=	-libXtst
