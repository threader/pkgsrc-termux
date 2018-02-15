# $NetBSD: Makefile,v 1.4 2017/08/14 23:42:08 schmonz Exp $

DISTNAME=		cpputest-3.8
PKGREVISION=		1
CATEGORIES=		devel
MASTER_SITES=		${MASTER_SITE_GITHUB:=cpputest/}
GITHUB_TAG=		v${PKGVERSION_NOREV}
GITHUB_PROJECT=		cpputest

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		http://cpputest.github.io/
COMMENT=		Unit testing and mocking framework for C/C++
LICENSE=		modified-bsd

PKGCONFIG_OVERRIDE+=	cpputest.pc.in

#USE_CMAKE=		yes
USE_LIBTOOL=		yes
GNU_CONFIGURE=		yes
CONFIGURE_SCRIPT=	../configure
CONFIGURE_DIRS=		cpputest_build
BUILD_DIRS=		${CONFIGURE_DIRS}
USE_TOOLS+=		automake autoreconf pkg-config
USE_LANGUAGES=		c c++

TEST_TARGET=		check tdd

INSTALLATION_DIRS=	share/CppUTest

pre-configure:
	cd ${WRKSRC}/${CONFIGURE_DIRS} && autoreconf .. -fiv

post-install:
	${INSTALL_DATA} ${WRKSRC}/build/MakefileWorker.mk ${DESTDIR}${PREFIX}/share/CppUTest/MakefileWorker.mk

.include "../../mk/bsd.pkg.mk"
