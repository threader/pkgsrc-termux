# $NetBSD: hacks.mk,v 1.8 2017/10/27 18:01:43 ryoon Exp $

# workround for link of thunderbird-bin etc.
LDFLAGS+=	${COMPILER_RPATH_FLAG}${PREFIX}/lib/${MOZILLA_NAME}

.if ${OPSYS} == "SunOS"
# workaround for strip problems with libxul.so
# https://www.illumos.org/issues/4383
INSTALL_UNSTRIPPED=yes
.endif
