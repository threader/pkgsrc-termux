# $NetBSD: buildlink3.mk,v 1.12 2017/11/30 16:45:10 adam Exp $

BUILDLINK_TREE+=	frameworkintegration

.if !defined(FRAMEWORKINTEGRATION_BUILDLINK3_MK)
FRAMEWORKINTEGRATION_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.frameworkintegration+=	frameworkintegration>=5.21.0
BUILDLINK_ABI_DEPENDS.frameworkintegration?=	frameworkintegration>=5.25.0nb11
BUILDLINK_PKGSRCDIR.frameworkintegration?=	../../x11/frameworkintegration

.include "../../devel/kio/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# FRAMEWORKINTEGRATION_BUILDLINK3_MK

BUILDLINK_TREE+=	-frameworkintegration
