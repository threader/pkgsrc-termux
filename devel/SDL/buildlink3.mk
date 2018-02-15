# $NetBSD: buildlink3.mk,v 1.33 2015/09/05 11:21:53 jperkin Exp $

BUILDLINK_TREE+=	SDL

.if !defined(SDL_BUILDLINK3_MK)
SDL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.SDL+=	SDL>=1.2.5nb5
BUILDLINK_ABI_DEPENDS.SDL+=	SDL>=1.2.15nb17
BUILDLINK_PKGSRCDIR.SDL?=	../../devel/SDL

PTHREAD_OPTS+=	require

.include "../../mk/bsd.fast.prefs.mk"

.if ${OPSYS} != "IRIX" && ${OPSYS} != "Darwin"
.include "../../graphics/MesaLib/buildlink3.mk"
.include "../../graphics/glu/buildlink3.mk"
.include "../../x11/libXrandr/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.endif

.include "../../converters/libiconv/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"

# SDL tests on OSX only work for the user logged in on the console, otherwise
# they hang or crash.
.if ${OPSYS} == "Darwin" && defined(GNU_CONFIGURE)
CONFIGURE_ARGS+=	--disable-sdltest
.endif

pkgbase := SDL
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.SDL:Maalib)
.include "../../graphics/aalib/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.SDL:Mnas)
.include "../../audio/nas/buildlink3.mk"
.endif

.endif # SDL_BUILDLINK3_MK

BUILDLINK_TREE+=	-SDL
