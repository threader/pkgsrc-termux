# $NetBSD: Makefile,v 1.10 2017/11/03 19:40:31 wiz Exp $

DISTNAME=	suds-0.4
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
CATEGORIES=	net python
MASTER_SITES=	${MASTER_SITE_PYPI:=s/suds/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://pypi.python.org/pypi/suds
COMMENT=	Lightweight SOAP python client for consuming Web Services
LICENSE=	gnu-lgpl-v3

USE_LANGUAGES=		# empty
PYTHON_VERSIONS_INCOMPATIBLE=	34 35 36 # not yet ported as of 0.4

.include "../../lang/python/egg.mk"
.include "../../mk/bsd.pkg.mk"
