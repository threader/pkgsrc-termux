# $NetBSD: Makefile,v 1.10 2017/12/06 00:11:47 prlw1 Exp $

DISTNAME=	get_iplayer-3.07
CATEGORIES=	net multimedia
MASTER_SITES=	${MASTER_SITE_GITHUB:=get-iplayer/}

MAINTAINER=	shattered@NetBSD.org
HOMEPAGE=	https://github.com/get-iplayer/${GITHUB_PROJECT}
COMMENT=	Search, index, record or stream BBC iPlayer broadcasts
LICENSE=	gnu-gpl-v3

GITHUB_TAG=	v${PKGVERSION_NOREV}

DEPENDS+=	p5-XML-LibXML-[0-9]*:../../textproc/p5-XML-LibXML
DEPENDS+=	p5-libwww>=6.0:../../www/p5-libwww
DEPENDS+=	p5-Mojolicious>=6.0:../../www/p5-Mojolicious

USE_LANGUAGES=	# none
NO_BUILD=	yes
REPLACE_PERL=	get_iplayer

PKG_SYSCONFSUBDIR=	get_iplayer

INSTALLATION_DIRS=	bin ${PKGMANDIR}/man1

SUBST_CLASSES+=		paths
SUBST_STAGE.paths=	pre-configure
SUBST_FILES.paths=	get_iplayer
SUBST_SED.paths=	-e "s:/etc/get_iplayer:${PKG_SYSCONFDIR}:g"

do-install:
	${INSTALL_SCRIPT} ${WRKSRC}/get_iplayer ${DESTDIR}${PREFIX}/bin/
	${INSTALL_MAN} ${WRKSRC}/get_iplayer.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1/

.include "../../mk/bsd.pkg.mk"
