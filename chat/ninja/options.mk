# $NetBSD: options.mk,v 1.3 2012/06/12 15:45:55 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.ninja
PKG_SUPPORTED_OPTIONS=	inet6
PKG_SUGGESTED_OPTIONS=	inet6

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Minet6)
CONFIGURE_ARGS+=	--enable-ipv6
.endif
