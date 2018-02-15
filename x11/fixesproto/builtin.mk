# $NetBSD: builtin.mk,v 1.10 2015/06/18 21:48:52 jperkin Exp $

BUILTIN_PKG:=	fixesproto
PKGCONFIG_FILE.fixesproto=	${X11BASE}/lib/pkgconfig/fixesproto.pc
PKGCONFIG_FILE.fixesproto+=	${X11BASE}/lib${LIBABISUFFIX}/pkgconfig/fixesproto.pc
PKGCONFIG_FILE.fixesproto+=	${X11BASE}/share/pkgconfig/fixesproto.pc

.include "../../mk/buildlink3/pkgconfig-builtin.mk"
.include "../../mk/x11.builtin.mk"

CHECK_BUILTIN.fixesproto?=	no
.if !empty(CHECK_BUILTIN.fixesproto:M[nN][oO])

# following so old pkg-config name fixesext.pc will be available
# this is temporary and can be removed once not used
BUILDLINK_TARGETS+=	fixesext-symlink-pc

fixesext-symlink-pc:
	src=${FIND_FILES_fixesproto} \
	dst=${BUILDLINK_DIR}/lib/pkgconfig/fixesext.pc; \
	${MKDIR} ${BUILDLINK_DIR}/lib/pkgconfig; \
	if ${TEST} -f $${src}; then \
		${LN} -sf $${src} $${dst}; \
	fi

.endif	# CHECK_BUILTIN.fixesproto
