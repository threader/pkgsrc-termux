# $NetBSD: buildlink3.mk,v 1.7 2017/11/30 16:45:05 adam Exp $

BUILDLINK_TREE+=	attica-qt5

.if !defined(ATTICA_QT5_BUILDLINK3_MK)
ATTICA_QT5_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.attica-qt5+=	attica-qt5>=5.18.0
BUILDLINK_ABI_DEPENDS.attica-qt5?=	attica-qt5>=5.25.0nb6
BUILDLINK_PKGSRCDIR.attica-qt5?=	../../misc/attica-qt5

.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# ATTICA_QT5_BUILDLINK3_MK

BUILDLINK_TREE+=	-attica-qt5
