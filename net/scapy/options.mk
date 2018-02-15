# $NetBSD: options.mk,v 1.7 2017/01/01 14:43:53 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.scapy

PKG_SUPPORTED_OPTIONS=	scapy-crypto gnuplot scapy-pyx

.include "../../mk/bsd.options.mk"

###
### Add in crypto support for WEP operations
###
.if !empty(PKG_OPTIONS:Mscapy-crypto)
DEPENDS+=	${PYPKGPREFIX}-amkCrypto-[0-9]*:../../security/py-amkCrypto
.endif

###
### Add in gnuplot support for plotting
###
.if !empty(PKG_OPTIONS:Mgnuplot)
DEPENDS+=	${PYPKGPREFIX}-gnuplot-[0-9]*:../../graphics/py-gnuplot
PYTHON_VERSIONS_INCOMPATIBLE=	34 35 36 # py-gnuplot
.endif

###
### Add in TeX support for psdump() and/or pdfdump()
###
.if !empty(PKG_OPTIONS:Mscapy-pyx)
PYTHON_VERSIONED_DEPENDENCIES=	X
.include "../../lang/python/versioned_dependencies.mk"
.endif
