# $NetBSD: options.mk,v 1.18 2017/09/27 13:46:30 wiz Exp $

PKG_OPTIONS_VAR=		PKG_OPTIONS.cmus
PKG_SUPPORTED_OPTIONS=		flac mad vorbis libao musepack faad wavpack pulseaudio
PKG_SUPPORTED_OPTIONS+=		ffmpeg opus jack
PKG_OPTIONS_OPTIONAL_GROUPS=	mod
PKG_OPTIONS_GROUP.mod=		modplug mikmod
PKG_SUGGESTED_OPTIONS=		flac libao mad modplug opus vorbis
PKG_OPTIONS_LEGACY_OPTS=	ao:libao
PKG_OPTIONS_LEGACY_OPTS=	mpcdec:musepack

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	${PKG_SUPPORTED_OPTIONS}

###
### Backends
###

# AO support
#
.if !empty(PKG_OPTIONS:Mlibao)
.  include "../../audio/libao/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_AO=y
PLIST.libao=		yes
.else
CONFIGURE_ARGS+=	CONFIG_AO=n
.endif

# ALSA support
#
# UNTESTED
#.if !empty(PKG_OPTIONS:Malsa)
#ONLY_FOR_PLATFORM=  Linux-*-* # Alsa is Linux only
#CONFIGURE_ARGS+=	CONFIG_ALSA=y
#.endif

# PULSE support
#
.if !empty(PKG_OPTIONS:Mpulseaudio)
. include "../../audio/pulseaudio/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_PULSE=y
PLIST.pulseaudio=		yes
.else
CONFIGURE_ARGS+=	CONFIG_PULSE=n
.endif

# JACK support
#
.if !empty(PKG_OPTIONS:Mjack)
.include "../../audio/jack/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_JACK=y
PLIST.jack=		yes
.else
CONFIGURE_ARGS+=	CONFIG_JACK=n
.endif

###
### Codecs
###

# MAD support
#
.if !empty(PKG_OPTIONS:Mmad)
.include "../../audio/libmad/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_MAD=y
PLIST.mad=		yes
.else
CONFIGURE_ARGS+=	CONFIG_MAD=n
.endif

# VORBIS support
#
.if !empty(PKG_OPTIONS:Mvorbis)
.include "../../audio/libvorbis/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_VORBIS=y
PLIST.vorbis=		yes
.else
CONFIGURE_ARGS+=	CONFIG_VORBIS=n
.endif

# FLAC support
#
.if !empty(PKG_OPTIONS:Mflac)
.include "../../audio/flac/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_FLAC=y
PLIST.flac=		yes
.else
CONFIGURE_ARGS+=	CONFIG_FLAC=n
.endif

# MPCDEC support
#
.if !empty(PKG_OPTIONS:Mmusepack)
.include "../../audio/musepack/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_MPC=y
PLIST.musepack=		yes
.else
CONFIGURE_ARGS+=	CONFIG_MPC=n
.endif

# VAWPACK support
#
.if !empty(PKG_OPTIONS:Mwavpack)
.include "../../audio/wavpack/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_WAVPACK=y
PLIST.wavpack=		yes
.else
CONFIGURE_ARGS+=	CONFIG_WAVPACK=n
.endif

# FFMPEG support
#
.if !empty(PKG_OPTIONS:Mffmpeg)
.include "../../multimedia/ffmpeg1/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_FFMPEG=y
PLIST.ffmpeg=		yes
.else
CONFIGURE_ARGS+=	CONFIG_FFMPEG=n
.endif

# modplay support
#
.if !empty(PKG_OPTIONS:Mmikmod)
.include "../../audio/libmikmod/buildlink3.mk"
.include "../../audio/libaudiofile/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_MODPLUG=n
CONFIGURE_ARGS+=	CONFIG_MIKMOD=y
PLIST.mikmod=		yes
.endif
.if !empty(PKG_OPTIONS:Mmodplug)
.include "../../audio/libmodplug/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_MODPLUG=y
CONFIGURE_ARGS+=	CONFIG_MIKMOD=n
PLIST.modplug=		yes
.endif

# FAAD support
#
.if !empty(PKG_OPTIONS:Mfaad)
.include "../../audio/faad2/buildlink3.mk"
.include "../../multimedia/mp4v2/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_AAC=y
CONFIGURE_ARGS+=	CONFIG_MP4=y
PLIST.faad=		yes
.else
CONFIGURE_ARGS+=	CONFIG_AAC=n
CONFIGURE_ARGS+=	CONFIG_MP4=n
.endif

# Opus support
#
.if !empty(PKG_OPTIONS:Mopus)
.include "../../audio/opusfile/buildlink3.mk"
CONFIGURE_ARGS+=	CONFIG_OPUS=y
PLIST.opus=		yes
.else
CONFIGURE_ARGS+=	CONFIG_OPUS=n
.endif
