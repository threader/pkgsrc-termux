# $NetBSD: buildlink3.mk,v 1.3 2016/07/22 12:39:22 nros Exp $
#

BUILDLINK_TREE+=	qore-yaml-module

.if !defined(QORE_YAML_MODULE_BUILDLINK3_MK)
QORE_YAML_MODULE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.qore-yaml-module+=	qore-yaml-module>=0.4
BUILDLINK_ABI_DEPENDS.qore-yaml-module?=	qore-yaml-module>=0.5
BUILDLINK_PKGSRCDIR.qore-yaml-module?=	../../textproc/qore-yaml-module


.include "../../lang/qore/buildlink3.mk"
.endif	# QORE_YAML_MODULE_BUILDLINK3_MK

BUILDLINK_TREE+=	-qore-yaml-module
