# $NetBSD: options.mk,v 1.5 2017/12/21 08:18:38 adam Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.nghttp2
PKG_SUPPORTED_OPTIONS=	nghttp2-asio nghttp2-tools
PKG_SUGGESTED_OPTIONS=	#

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	asio tools

###
### Build the ASIO C++ library
###
.if !empty(PKG_OPTIONS:Mnghttp2-asio)
# Requires emplace() for associative containers, introduced in gcc 4.8.0
GCC_REQD+=		4.8
CONFIGURE_ARGS+=	--enable-asio-lib
CONFIGURE_ARGS+=	--with-boost=${BUILDLINK_PREFIX.boost-libs}
CONFIGURE_ARGS+=	--with-boost-asio
CONFIGURE_ARGS+=	--with-boost-system
CONFIGURE_ARGS+=	--with-boost-thread
PLIST.asio=		yes
.include "../../devel/boost-libs/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--with-boost=no
.endif

###
### Build apps and tools
###
.if !empty(PKG_OPTIONS:Mnghttp2-tools)
# Requires emplace() for associative containers, introduced in gcc 4.8.0
GCC_REQD+=		4.8
CONFIGURE_ARGS+=	--enable-app
CONFIGURE_ARGS+=	--enable-hpack-tools
PLIST.tools=		yes
.include "../../devel/libev/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../net/libcares/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/jansson/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-app
CONFIGURE_ARGS+=	--disable-hpack-tools
.endif
