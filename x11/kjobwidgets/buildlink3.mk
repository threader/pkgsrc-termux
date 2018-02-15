# $NetBSD: buildlink3.mk,v 1.7 2017/11/30 16:45:11 adam Exp $

BUILDLINK_TREE+=	kjobwidgets

.if !defined(KJOBWIDGETS_BUILDLINK3_MK)
KJOBWIDGETS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kjobwidgets+=	kjobwidgets>=5.19.0
BUILDLINK_ABI_DEPENDS.kjobwidgets?=	kjobwidgets>=5.25.0nb10
BUILDLINK_PKGSRCDIR.kjobwidgets?=	../../x11/kjobwidgets

.include "../../devel/kcoreaddons/buildlink3.mk"
.include "../../x11/kwidgetsaddons/buildlink3.mk"
.include "../../x11/qt5-qtx11extras/buildlink3.mk"
.endif	# KJOBWIDGETS_BUILDLINK3_MK

BUILDLINK_TREE+=	-kjobwidgets
