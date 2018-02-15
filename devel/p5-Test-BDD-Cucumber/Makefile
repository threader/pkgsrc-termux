# $NetBSD: Makefile,v 1.28 2017/07/09 15:02:11 schmonz Exp $

DISTNAME=		Test-BDD-Cucumber-0.53
PKGNAME=		p5-${DISTNAME}
CATEGORIES=		devel perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Test/}

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		http://search.cpan.org/dist/Test-BDD-Cucumber/
COMMENT=		Feature-complete Cucumber-style testing in Perl
LICENSE=		${PERL5_LICENSE}

DEPENDS+=		p5-Clone-[0-9]*:../../devel/p5-Clone
DEPENDS+=		p5-Devel-Refcount-[0-9]*:../../devel/p5-Devel-Refcount
DEPENDS+=		p5-File-Find-Rule-[0-9]*:../../devel/p5-File-Find-Rule
DEPENDS+=		p5-JSON-MaybeXS>=1.001000:../../converters/p5-JSON-MaybeXS
DEPENDS+=		p5-List-MoreUtils-[0-9]*:../../devel/p5-List-MoreUtils
DEPENDS+=		p5-Module-Runtime-[0-9]*:../../devel/p5-Module-Runtime
DEPENDS+=		p5-Moo-[0-9]*:../../devel/p5-Moo
DEPENDS+=		p5-MooX-HandlesVia-[0-9]*:../../devel/p5-MooX-HandlesVia
DEPENDS+=		p5-Number-Range-[0-9]*:../../math/p5-Number-Range
DEPENDS+=		p5-Path-Class-[0-9]*:../../devel/p5-Path-Class
#DEPENDS+=		p5-Storable-[0-9]*:../../devel/p5-Storable
#DEPENDS+=		p5-Term-ANSIColor>=3.00:../../devel/p5-Term-ANSIColor
DEPENDS+=		p5-Test-Differences-[0-9]*:../../devel/p5-Test-Differences
DEPENDS+=		p5-YAML-Syck-[0-9]*:../../textproc/p5-YAML-Syck

#BUILD_DEPENDS+=	p5-Test-Exception-[0-9]*:../../devel/p5-Test-Exception

REPLACE_PERL+=		bin/pherkin
PERL5_PACKLIST=		auto/Test/BDD/Cucumber/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
