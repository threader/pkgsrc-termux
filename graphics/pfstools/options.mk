# $NetBSD: options.mk,v 1.5 2017/02/12 21:50:17 adam Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.pfstools
PKG_SUPPORTED_OPTIONS=	fftw imagemagick octave qt opengl

PKG_SUGGESTED_OPTIONS.Darwin+=	opengl

PLIST_VARS+=	fftw im octave qt gl

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mfftw)
.include "../../math/fftwf/buildlink3.mk"
PLIST.fftw=	yes
CMAKE_ARGS+=	-DWITH_FFTW=YES
.else
CMAKE_ARGS+=	-DWITH_FFTW=NO
.endif

.if !empty(PKG_OPTIONS:Mimagemagick)
.include "../../graphics/ImageMagick6/buildlink3.mk"
PLIST.im=	yes
CMAKE_ARGS+=	-DWITH_ImageMagick=YES
.else
CMAKE_ARGS+=	-DWITH_ImageMagick=NO
.endif

.if !empty(PKG_OPTIONS:Moctave)
.include "../../math/octave/buildlink3.mk"
REPLACE_OCTAVE+=	src/octave/pfsoctavelum src/octave/pfsoctavergb
REPLACE_OCTAVE+=	src/octave/pfsstat
.include "../../math/octave/octave.mk"
PLIST.octave=	yes
PLIST_SUBST+=	OCT_LOCALVEROCTFILEDIR=${OCT_LOCALVEROCTFILEDIR:S/${BUILDLINK_PREFIX.octave}\///}
PLIST_SUBST+=	OCT_LOCALVERFCNFILEDIR=${OCT_LOCALVERFCNFILEDIR:S/${BUILDLINK_PREFIX.octave}\///}
CMAKE_ARGS+=	-DWITH_Octave=YES
.else
CMAKE_ARGS+=	-DWITH_Octave=NO
.endif

.if !empty(PKG_OPTIONS:Mqt)
.include "../../x11/qt4-libs/buildlink3.mk"
.include "../../x11/qt4-tools/buildlink3.mk"
PLIST.qt=	yes
CMAKE_ARGS+=	-DWITH_QT=YES
.else
CMAKE_ARGS+=	-DWITH_QT=NO
.endif

.if !empty(PKG_OPTIONS:Mopengl)
.  if ${OPSYS} != "Darwin"
.include "../../graphics/glut/buildlink3.mk"
.  endif
# XXX nasty hack
CXXFLAGS.NetBSD+=	-lpthread
PLIST.gl=	yes
CMAKE_ARGS+=	-DWITH_pfsglview=YES
.else
CMAKE_ARGS+=	-DWITH_pfsglview=NO
.endif
