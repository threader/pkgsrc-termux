# $NetBSD: buildlink3.mk,v 1.17 2017/11/30 16:45:13 adam Exp $

BUILDLINK_TREE+=	qt5-qtsvg

.if !defined(QT5_QTSVG_BUILDLINK3_MK)
QT5_QTSVG_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.qt5-qtsvg+=	qt5-qtsvg>=5.5.1
BUILDLINK_ABI_DEPENDS.qt5-qtsvg+=	qt5-qtsvg>=5.5.1nb9
BUILDLINK_PKGSRCDIR.qt5-qtsvg?=	../../x11/qt5-qtsvg

BUILDLINK_INCDIRS.qt5-qtsvg+=	qt5/include
BUILDLINK_LIBDIRS.qt5-qtsvg+=	qt5/lib
BUILDLINK_LIBDIRS.qt5-qtsvg+=	qt5/plugins

.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# QT5_QTSVG_BUILDLINK3_MK

BUILDLINK_TREE+=	-qt5-qtsvg
