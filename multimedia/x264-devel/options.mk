# $NetBSD: options.mk,v 1.3 2011/01/17 16:46:42 drochner Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.x264-devel
PKG_SUPPORTED_OPTIONS=	debug threads

.if !empty(X264_BUILD_THREADS_SUPPORT:M[Yy][Ee][Ss])
PKG_SUGGESTED_OPTIONS+=	threads
.endif

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mthreads)
.  include "../../mk/pthread.buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-pthread
.endif

.if !empty(PKG_OPTIONS:Mdebug) || \
    !empty(INSTALL_UNSTRIPPED:Uno:M[Yy][Ee][Ss])
CONFIGURE_ARGS+=	--enable-debug
BUILDLINK_TRANSFORM+=	rm:-fomit-frame-pointer
.endif
