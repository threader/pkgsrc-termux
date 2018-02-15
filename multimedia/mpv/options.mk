# $NetBSD: options.mk,v 1.14 2017/07/16 12:06:25 leot Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.mpv

.include "../../multimedia/libva/available.mk"
.include "../../multimedia/libvdpau/available.mk"

PKG_SUPPORTED_OPTIONS=	ass caca lua pulseaudio rpi sdl sdl2 v4l2
PKG_SUGGESTED_OPTIONS=	ass lua pulseaudio

.if ${VAAPI_AVAILABLE} == "yes"
PKG_SUPPORTED_OPTIONS+=	vaapi
PKG_SUGGESTED_OPTIONS+=	vaapi
.endif

.if ${VDPAU_AVAILABLE} == "yes"
PKG_SUPPORTED_OPTIONS+=	vdpau
PKG_SUGGESTED_OPTIONS+=	vdpau
.endif

.include "../../mk/bsd.options.mk"

###
### caca support (video output)
###
.if !empty(PKG_OPTIONS:Mcaca)
WAF_CONFIGURE_ARGS+=	--enable-caca
.include "../../graphics/libcaca/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-caca
.endif

###
### lua support
###
.if !empty(PKG_OPTIONS:Mlua)
WAF_CONFIGURE_ARGS+=	--enable-lua
LUA_VERSIONS_INCOMPATIBLE=	53
.include "../../lang/lua/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-lua
.endif

###
### Pulseaudio support (audio output)
###
.if !empty(PKG_OPTIONS:Mpulseaudio)
WAF_CONFIGURE_ARGS+=	--enable-pulse
.include "../../audio/pulseaudio/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-pulse
.endif

###
### SDL2 support (audio and video output)
###
.if !empty(PKG_OPTIONS:Msdl2)
WAF_CONFIGURE_ARGS+=	--enable-sdl2
.include "../../devel/SDL2/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-sdl2
.endif

###
### SDL support (audio output)
###
.if !empty(PKG_OPTIONS:Msdl)
WAF_CONFIGURE_ARGS+=	--enable-sdl1
.include "../../devel/SDL/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-sdl1
.endif

###
### libASS support
###
.if !empty(PKG_OPTIONS:Mass)
WAF_CONFIGURE_ARGS+=	--enable-libass
.include "../../multimedia/libass/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-libass
.endif

###
### V4L2 support
###
.if !empty(PKG_OPTIONS:Mv4l2)
WAF_CONFIGURE_ARGS+=	--enable-libv4l2
.else
WAF_CONFIGURE_ARGS+=	--disable-libv4l2
.endif

###
### VAAPI support (video output)
###
.if !empty(PKG_OPTIONS:Mvaapi)
WAF_CONFIGURE_ARGS+=	--enable-vaapi
.include "../../multimedia/libva/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-vaapi
.endif

###
### VDPAU support (video output)
###
.if !empty(PKG_OPTIONS:Mvdpau)
WAF_CONFIGURE_ARGS+=	--enable-vdpau
.include "../../multimedia/libvdpau/buildlink3.mk"
.else
WAF_CONFIGURE_ARGS+=	--disable-vdpau
.endif

###
### Raspberry Pi support
###
.if !empty(PKG_OPTIONS:Mrpi)
BUILD_DEPENDS+=		raspberrypi-userland>=20170109:../../misc/raspberrypi-userland
CFLAGS+=		"-L${PREFIX}/lib"
SUBST_CLASSES+=		vc
SUBST_STAGE.vc=		pre-configure
SUBST_MESSAGE.vc=	Fixing path to VideoCore libraries.
SUBST_FILES.vc=		waftools/checks/custom.py
SUBST_SED.vc+=		-e 's;opt/vc;${PREFIX};g'
.endif
