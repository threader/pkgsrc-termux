# $NetBSD: linux.mk,v 1.30 2017/08/21 12:49:17 jlam Exp $
#
# Linux binary emulation framework
#

.if ${OPSYS} == "Linux"
.  if ${EMUL_ARCH} == ${MACHINE_ARCH}
EMUL_TYPE.linux?=	native
.  else
EMUL_TYPE.linux?=	none
.  endif
.else

# Pick appropriate SuSE Linux version for NetBSD amd64 and i386.
.if ${OPSYS} == "NetBSD" && ${EMUL_ARCH} != "powerpc"
# Use 13.1 under NetBSD 7.* and newer,
.  if empty(OS_VERSION:M[0-6].*)
SUSE_PREFER?=	13.1
# 12.1 under NetBSD 6.*, and 10.0 otherwise.
.  elif empty(OS_VERSION:M[0-5].*)
SUSE_PREFER?=	12.1
.  endif
.endif
SUSE_PREFER?=	10.0

.for _version_ in ${EMUL_REQD:Msuse>=*:S/suse>=//}
SUSE_VERSION_REQD?=	${_version_}
.endfor
.if !defined(SUSE_VERSION_REQD) || ${SUSE_PREFER} > ${SUSE_VERSION_REQD}
SUSE_VERSION_REQD=	${SUSE_PREFER}
.endif

EMUL_TYPE.linux?=	suse-${SUSE_VERSION_REQD}
.endif
EMUL_MODULES.linux?=	# empty

.if ((${EMUL_ARCH} == "i386") && (${MACHINE_ARCH} == "x86_64")) || \
    ((${EMUL_ARCH} == "sparc") && (${MACHINE_ARCH} == "sparc64"))
_LINUX_BASE=		linux32
EMULSUBDIR=		emul/linux32
.else
_LINUX_BASE=		linux
EMULSUBDIR=		emul/linux
.endif

EMULDIR=		${PREFIX}/${EMULSUBDIR}
OPSYS_EMULDIR=		${_OPSYS_EMULDIR.${_LINUX_BASE}}

# _EMUL_TYPES
#	List of recognized Linux types that a user may request.
#
# _EMUL_MODULES
#	List of recognized Linux "modules" that packages may request.
#
_EMUL_TYPES=		builtin
_EMUL_TYPES+=		native
_EMUL_TYPES+=		suse

.if !empty(EMUL_TYPE.linux:Msuse-*)
_EMUL_TYPE?=		suse
.endif
_EMUL_TYPE?=		${EMUL_TYPE.linux}

_EMUL_MODULES=		alsa
_EMUL_MODULES+=		aspell
_EMUL_MODULES+=		base
_EMUL_MODULES+=		compat
_EMUL_MODULES+=		cups
_EMUL_MODULES+=		curl
_EMUL_MODULES+=		cyrus-sasl
_EMUL_MODULES+=		drm
_EMUL_MODULES+=		dbus
_EMUL_MODULES+=		dbus-glib
_EMUL_MODULES+=		expat
_EMUL_MODULES+=		fontconfig
_EMUL_MODULES+=		freetype2
_EMUL_MODULES+=		glib2
_EMUL_MODULES+=		glx
_EMUL_MODULES+=		gstreamer
_EMUL_MODULES+=		gtk2
_EMUL_MODULES+=		jpeg
_EMUL_MODULES+=		krb5
_EMUL_MODULES+=		libSDL
_EMUL_MODULES+=		libaudiofile
_EMUL_MODULES+=		libesd
_EMUL_MODULES+=		libffi
_EMUL_MODULES+=		libjson
_EMUL_MODULES+=		libidn
_EMUL_MODULES+=		libsigc++2
_EMUL_MODULES+=		libsndfile
_EMUL_MODULES+=		libssh
_EMUL_MODULES+=		libwrap
_EMUL_MODULES+=		locale
_EMUL_MODULES+=		motif
_EMUL_MODULES+=		nspr
_EMUL_MODULES+=		nss
_EMUL_MODULES+=		openldap
_EMUL_MODULES+=		openssl
_EMUL_MODULES+=		png
_EMUL_MODULES+=		pulseaudio
_EMUL_MODULES+=		qt4
_EMUL_MODULES+=		resmgr
_EMUL_MODULES+=		slang
_EMUL_MODULES+=		sqlite3
_EMUL_MODULES+=		tiff
_EMUL_MODULES+=		webp
_EMUL_MODULES+=		x11
_EMUL_MODULES+=		xml2
_EMUL_MODULES+=		xslt

.if ${_EMUL_TYPE} == "builtin"
EMUL_DISTRO=		builtin-linux	# managed outside pkgsrc
.elif ${_EMUL_TYPE} == "none"
EMUL_DISTRO=		none
NOT_FOR_PLATFORM=	Linux-*-${MACHINE_ARCH}
.elif ${_EMUL_TYPE} == "native"
EMUL_DISTRO=		native-linux	# native Linux installation
EMULDIR=		${PREFIX}
EMULSUBDIR=		# empty
.else
.  include "linux-${_EMUL_TYPE}.mk"
.endif

.if (${_EMUL_TYPE} == "builtin") || (${_EMUL_TYPE} == "native") || \
    (${_EMUL_TYPE} == "none")
.  for _mod_ in ${_EMUL_MODULES}
DEPENDS_${EMUL_DISTRO}.${_mod_}=	# empty
.  endfor
.endif
