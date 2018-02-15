# $NetBSD: options.mk,v 1.1 2014/12/30 16:01:22 wiz Exp $
#

PKG_OPTIONS_VAR=	PKG_OPTIONS.qore-asn1-module
PKG_SUPPORTED_OPTIONS=	debug
.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mdebug)
CONFIGURE_ARGS+=        --enable-debug
.else
CONFIGURE_ARGS+=        --disable-debug
.endif
