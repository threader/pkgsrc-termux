# $NetBSD: buildlink3.mk,v 1.10 2016/09/19 13:04:18 wiz Exp $

BUILDLINK_TREE+=	libggz

.if !defined(LIBGGZ_BUILDLINK3_MK)
LIBGGZ_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libggz+=	libggz>=0.0.14.1
BUILDLINK_ABI_DEPENDS.libggz+=	libggz>=0.0.14.1nb6
BUILDLINK_PKGSRCDIR.libggz?=	../../games/libggz

.include "../../security/gnutls/buildlink3.mk"
.include "../../security/libgcrypt/buildlink3.mk"
.endif # LIBGGZ_BUILDLINK3_MK

BUILDLINK_TREE+=	-libggz
