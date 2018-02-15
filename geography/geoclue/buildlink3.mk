# $NetBSD: buildlink3.mk,v 1.7 2012/09/15 10:04:44 obache Exp $

BUILDLINK_TREE+=	geoclue

.if !defined(GEOCLUE_BUILDLINK3_MK)
GEOCLUE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.geoclue+=	geoclue>=0.12.0
BUILDLINK_ABI_DEPENDS.geoclue+=	geoclue>=0.12.0nb10
BUILDLINK_PKGSRCDIR.geoclue?=	../../geography/geoclue

.include "../../devel/glib2/buildlink3.mk"
.include "../../sysutils/dbus-glib/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif	# GEOCLUE_BUILDLINK3_MK

BUILDLINK_TREE+=	-geoclue
