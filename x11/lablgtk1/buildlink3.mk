# $NetBSD: buildlink3.mk,v 1.15 2017/09/08 09:51:27 jaapb Exp $

BUILDLINK_TREE+=	lablgtk1

.if !defined(LABLGTK1_BUILDLINK3_MK)
LABLGTK1_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.lablgtk1+=	lablgtk1>=1.2.5nb3
BUILDLINK_ABI_DEPENDS.lablgtk1+=	lablgtk1>=1.2.7nb16
BUILDLINK_PKGSRCDIR.lablgtk1?=		../../x11/lablgtk1

.include "../../x11/gtk/buildlink3.mk"
.include "../../lang/ocaml/buildlink3.mk"
.endif # LABLGTK1_BUILDLINK3_MK

BUILDLINK_TREE+=	-lablgtk1
