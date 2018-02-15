# $NetBSD: x11.builtin.mk,v 1.4 2008/10/06 12:58:11 cube Exp $
#
# x11.builtin.mk will include the builtin.mk file from the appropriate
# X11 distribution.
#
# BUILTIN_PKG and USE_BUILTIN.<BUILTIN_PKG> must be defined by the caller

.if ${X11_TYPE} == "modular"
USE_BUILTIN.${BUILTIN_PKG}=	no
.endif

# XXX make(1) idiosyncrasy
# 'CHECK_BUILTIN.${BUILTIN_PKG}?= no' will overwrite the value on older
# version of make (in NetBSD's base system, prior to 20080331).
.if !defined(CHECK_BUILTIN.${BUILTIN_PKG})
CHECK_BUILTIN.${BUILTIN_PKG}=	no
.endif

.if !empty(CHECK_BUILTIN.${BUILTIN_PKG}:M[Nn][Oo])
.  if !empty(USE_BUILTIN.${BUILTIN_PKG}:M[Yy][Ee][Ss])

BUILDLINK_PREFIX.${BUILTIN_PKG}=	${X11BASE}

.    include "../../mk/x11.buildlink3.mk"
.    include "../../mk/x11.version.mk"
.    include "${X11_PKGSRCDIR.${X11_TYPE}}/builtin.mk"

.  endif
.endif
