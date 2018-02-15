# $NetBSD: options.mk,v 1.9 2012/06/12 15:45:57 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.dkim-milter
PKG_SUPPORTED_OPTIONS=	inet6 dkim-milter-arlib debug dkim-stats without-libsm vbr
PKG_SUGGESTED_OPTIONS=	inet6

.include "../../mk/bsd.options.mk"

###
### IPv6 support.
###
.if !empty(PKG_OPTIONS:Minet6)
SUBST_SED.libs+=	-e 's|@INET6@||g'
.else
SUBST_SED.libs+=	-e 's|@INET6@|dnl|g'
.endif

###
### Debug support
###
.if !empty(PKG_OPTIONS:Mdebug)
SUBST_SED.libs+=	-e 's|@DEBUG@||g'
.else
SUBST_SED.libs+=	-e 's|@DEBUG@|dnl|g'
.endif

###
### Use asynchronous DNS resolver library shipping with dkim-milter.
###
PLIST_VARS+=		arlib
.if !empty(PKG_OPTIONS:Mdkim-milter-arlib)
PLIST.arlib=		yes
SUBST_SED.libs+=	-e 's|@RESOLVLIB@||g'
SUBST_SED.libs+=	-e 's|@ARLIB@||g'
.else
SUBST_SED.libs+=	-e 's|@RESOLVLIB@|resolv bind|g'
SUBST_SED.libs+=	-e 's|@ARLIB@|dnl|g'
.endif

###
### Build with native strl*()
###
.if !empty(PKG_OPTIONS:Mwithout-libsm)
SUBST_SED.libs+=	-e 's|@WITHOUTLIBSM@||g'
.else
SUBST_SED.libs+=	-e 's|@WITHOUTLIBSM@|dnl|g'
.endif

###
### Build with VBR support
###
.if !empty(PKG_OPTIONS:Mvbr)
SUBST_SED.libs+=	-e 's|@VBR@||g'
.else
SUBST_SED.libs+=	-e 's|@VBR@|dnl|g'
.endif

###
### Install dkim-stats(8) which outputs dkim-milter statistics
###
PLIST_VARS+=		stats
.if !empty(PKG_OPTIONS:Mdkim-stats)
.include "../../mk/db1.builtin.mk"
PLIST.stats=		yes
SUBST_SED.libs+=	-e 's|@STATS@||g'
SUBST_SED.libs+=	-e 's|@MAN_STATS@|dkim-stats.8|g'
SUBST_SED.libs+=	-e 's|@DBLIB@|db|g'
.else
SUBST_SED.libs+=	-e 's|@STATS@|dnl|g'
SUBST_SED.libs+=	-e 's|@MAN_STATS@||g'
SUBST_SED.libs+=	-e 's|@DBLIB@||g'
.endif
