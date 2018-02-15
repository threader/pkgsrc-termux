# $NetBSD: buildlink3.mk,v 1.18 2016/08/17 23:13:11 maya Exp $

BUILDLINK_TREE+=	libgcrypt

.if !defined(LIBGCRYPT_BUILDLINK3_MK)
LIBGCRYPT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libgcrypt+=	libgcrypt>=1.2.0
BUILDLINK_ABI_DEPENDS.libgcrypt+=	libgcrypt>=1.6.0
BUILDLINK_PKGSRCDIR.libgcrypt?=		../../security/libgcrypt

.include "../../security/libgpg-error/buildlink3.mk"
.endif # LIBGCRYPT_BUILDLINK3_MK

BUILDLINK_TREE+=	-libgcrypt
