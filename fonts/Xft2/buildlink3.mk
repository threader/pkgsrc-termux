# $NetBSD: buildlink3.mk,v 1.23 2013/06/04 22:16:02 tron Exp $

BUILDLINK_TREE+=	Xft2

.if !defined(XFT2_BUILDLINK3_MK)
XFT2_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.Xft2+=	Xft2>=2.1
BUILDLINK_ABI_DEPENDS.Xft2+=	Xft2>=2.1.7nb6
BUILDLINK_PKGSRCDIR.Xft2?=	../../fonts/Xft2

.include "../../fonts/fontconfig/buildlink3.mk"
.include "../../x11/libXrender/buildlink3.mk"
.endif # XFT2_BUILDLINK3_MK

BUILDLINK_TREE+=	-Xft2
