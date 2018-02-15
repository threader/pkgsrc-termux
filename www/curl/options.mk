# $NetBSD: options.mk,v 1.16 2017/08/17 13:55:39 schmonz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.curl
PKG_SUPPORTED_OPTIONS=	inet6 libssh2 gssapi ldap rtmp idn http2
PKG_SUGGESTED_OPTIONS=	inet6 idn
PKG_OPTIONS_LEGACY_OPTS=libidn:idn

# Kerberos is built in - no additional dependency
PKG_SUGGESTED_OPTIONS.NetBSD+=	gssapi

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Minet6)
CONFIGURE_ARGS+=	--enable-ipv6
.else
CONFIGURE_ARGS+=	--disable-ipv6
.endif

.if !empty(PKG_OPTIONS:Mlibssh2)
CONFIGURE_ARGS+=	--with-libssh2=${BUILDLINK_PREFIX.libssh2}
.  include "../../security/libssh2/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-libssh2
.endif

.if !empty(PKG_OPTIONS:Mgssapi)
.include "../../mk/krb5.buildlink3.mk"
CONFIGURE_ARGS+=	--with-gssapi=${KRB5BASE}
CONFIGURE_ARGS+=	--with-gssapi-includes=${KRB5BASE}/include/gssapi
.else
CONFIGURE_ARGS+=	--without-gssapi
.endif

.if !empty(PKG_OPTIONS:Mldap)
.include "../../databases/openldap-client/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-ldap
CONFIGURE_ARGS+=	--enable-ldaps
.else
CONFIGURE_ARGS+=	--disable-ldap
.endif

.if !empty(PKG_OPTIONS:Mrtmp)
.include "../../net/rtmpdump/buildlink3.mk"
CONFIGURE_ARGS+=	--with-librtmp
.else
CONFIGURE_ARGS+=	--without-librtmp
.endif

.if !empty(PKG_OPTIONS:Midn)
.include "../../devel/libidn2/buildlink3.mk"
CONFIGURE_ARGS+=	--with-libidn2
.else
CONFIGURE_ARGS+=	--without-libidn2
.endif

.if !empty(PKG_OPTIONS:Mhttp2)
USE_TOOLS+=		pkg-config
CONFIGURE_ARGS+=	--with-nghttp2=${BUILDLINK_PREFIX.nghttp2}
.include "../../www/nghttp2/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-nghttp2
.endif
