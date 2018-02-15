# $NetBSD: hacks.mk,v 1.3 2015/10/25 11:00:18 wiz Exp $

.if !defined(VLC_HACKS_MK)
VLC_HACKS_MK=		# empty

# vlc_atomic.h rightly assumes "uses clang (support for C11)" implies
# "ships stdatomic.h" but for us this is not yet the case.
# This hack should be removed when -current has stdatomic.h.
.if	${OPSYS} == "NetBSD" &&		\
	exists(/usr/bin/clang) &&	\
	!exists(/usr/include/stdatomic.h)
CPPFLAGS+=		-D__STDC_NO_ATOMICS__
.endif

.endif
