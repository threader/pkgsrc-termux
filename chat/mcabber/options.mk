# $NetBSD: options.mk,v 1.1 2014/01/10 09:50:42 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.mcabber
PKG_SUPPORTED_OPTIONS=	aspell enchant gpgme otr ssl
PKG_SUGGESTED_OPTIONS=	gpgme otr ssl

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mgpgme)
.include "../../security/gpgme/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-gpgme
.endif

.if !empty(PKG_OPTIONS:Motr)
.include "../../chat/libotr/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-otr
.endif

.if !empty(PKG_OPTIONS:Maspell)
.include "../../textproc/aspell/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-aspell
.endif

.if !empty(PKG_OPTIONS:Menchant)
.include "../../textproc/enchant/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-enchant
.endif

.if !empty(PKG_OPTIONS:Mssl)
.include "../../security/openssl/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-ssl
.endif
