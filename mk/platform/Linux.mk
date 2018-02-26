# $NetBSD: Linux.mk,v 1.78 2017/11/21 19:16:47 bsiegert Exp $
#
# Variable definitions for the Linux operating system.

ECHO_N?=	${ECHO} -n
.if defined(X11_TYPE) && ${X11_TYPE} == "native"
IMAKE_MAKE?=	${GMAKE}	# program which gets invoked by imake
IMAKE_TOOLS=		gmake	# extra tools required when we use imake
.endif
IMAKEOPTS+=	-DBuildHtmlManPages=NO
PKGLOCALEDIR?=	share
PS?=		/data/data/com.termux/files/bin/ps
# XXX: default from defaults/mk.conf.  Verify/correct for this platform
# and remove this comment.
.if exists(/data/data/com.termux/files/usr/bin/su)
SU?=		/data/data/com.termux/files/usr/bin/su
.else
SU?=		/data/data/com.termux/files/bin/su
.endif
TYPE?=		type			# Shell builtin

CPP_PRECOMP_FLAGS?=	# unset
DEF_UMASK?=		022
DEFAULT_SERIAL_DEVICE?=	/dev/null
EXPORT_SYMBOLS_LDFLAGS?=	# Don't add symbols to the dynamic symbol table
GROUPADD?=		/data/data/com.termux/files/usr/sbin/groupadd
MOTIF_TYPE_DEFAULT?=	motif	# default 2.0 compatible libs type
.if exists(/data/data/com.termux/files/etc/ssdlinux_version)
NOLOGIN?=		/data/data/com.termux/files/sbin/nologin
.else
NOLOGIN?=		/data/data/com.termux/files/usr/bin/false
.endif
PKG_TOOLS_BIN?=		${PREFIX}/${LOCALBASE}/sbin
ROOT_CMD?=		${SU} - root -c
.if exists(/data/data/com.termux/files/usr/etc/ssdlinux_version)
ROOT_GROUP?=		wheel
.else
ROOT_GROUP?=		root
.endif
ROOT_USER?=		root
SERIAL_DEVICES?=	/dev/null
ULIMIT_CMD_datasize?=	ulimit -d `ulimit -H -d`
ULIMIT_CMD_stacksize?=	ulimit -s `ulimit -H -s`
ULIMIT_CMD_memorysize?=	ulimit -m `ulimit -H -m`
ULIMIT_CMD_cputime?=	ulimit -t `ulimit -H -t`
USERADD?=		/data/data/com.termux/files/usr/sbin/useradd

_OPSYS_EMULDIR.linux=	# empty
_OPSYS_EMULDIR.linux32=	# empty
# clang
BUILDLINK_TRANSFORM+=   rm:-Wl,-O1
BUILDLINK_TRANSFORM+=   rm:-Wl,-O2
BUILDLINK_TRANSFORM+=   rm:-Wl,-Bdynamic
BUILDLINK_TRANSFORM+=   rm:-Wl,-Bsymbolic
BUILDLINK_TRANSFORM+=   rm:-Wl,-export-dynamic
BUILDLINK_TRANSFORM+=   rm:-Wl,-warn-common
BUILDLINK_TRANSFORM+=   rm:-Wl,--as-needed
BUILDLINK_TRANSFORM+=   rm:-Wl,--no-as-needed
BUILDLINK_TRANSFORM+=   rm:-Wl,--disable-new-dtags
BUILDLINK_TRANSFORM+=   rm:-Wl,--enable-new-dtags
BUILDLINK_TRANSFORM+=   rm:-Wl,--export-dynamic
BUILDLINK_TRANSFORM+=   rm:-Wl,--gc-sections
BUILDLINK_TRANSFORM+=   rm:-Wl,--no-undefined


# Remove GCC-specific flags if using clang
.if ${PKGSRC_COMPILER} == "clang"
BUILDLINK_TRANSFORM+=   rm:-mimpure-text
.endif

# Support Debian/Ubuntu's multiarch hierarchy.
.if exists(/data/data/com.termux/files/usr/etc/tmux.conf)
.  if !empty(MACHINE_ARCH:Mx86_64)
_OPSYS_SYSTEM_RPATH=	/lib${LIBABISUFFIX}:/usr/lib${LIBABISUFFIX}:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu
_OPSYS_LIB_DIRS?=	/lib${LIBABISUFFIX} /usr/lib${LIBABISUFFIX} /lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
.  endif
.  if !empty(MACHINE_ARCH:Mi386)
_OPSYS_SYSTEM_RPATH=	/lib${LIBABISUFFIX}:/usr/lib${LIBABISUFFIX}:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu
_OPSYS_LIB_DIRS?=	/lib${LIBABISUFFIX} /usr/lib${LIBABISUFFIX} /lib/i386-linux-gnu /usr/lib/i386-linux-gnu
.  endif
.  if !empty(MACHINE_ARCH:Marm*)
.    if exists(/data/data/com.termux/files/usr/etc/ld.so.conf.d/arm-linux-gnueabihf.conf)
_OPSYS_SYSTEM_RPATH=	/data/data/com.termux/files/usr/lib:/data/data/com.termux/files/usr/arm-linux-androideabihf:${PREFIX}${LIBABISUFFIX}
_OPSYS_LIB_DIRS?=	/data/data/com.termux/files/usr${LIBABISUFFIX} /data/data/com.termux/files/usr/lib${LIBABISUFFIX} /data/data/com.termux/files/usr/arm-linux-androideabihf ${PREFIX}/lib${LIBABISUFFIX}
.    else
_OPSYS_SYSTEM_RPATH=	/data/data/com.termux/files/usr/lib:/data/data/com.termux/files/usr/lib${LIBABISUFFIX}:/data/data/com.termux/files/usr/arm-linux-androideabi:${PREFIX}/lib${LIBABISUFFIX}
_OPSYS_LIB_DIRS?=	/data/data/com.termux/files/usr/lib${LIBABISUFFIX} /data/data/com.termux/files/usr/arm-linux-androideabi ${PREFIX}/lib${LIBABISUFFIX}
.    endif
.  endif
.  if !empty(MACHINE_ARCH:Maarch64)
LIBABISUFFIX?=		/aarch64-linux-android
_OPSYS_SYSTEM_RPATH=	/data/data/com.termux/files/usr/lib:/data/data/com.termux/files/usr/lib${LIBABISUFFIX}:/data/data/com.termux/files/usr/aarch64-linux-androideabi:${PREFIX}/lib${LIBABISUFFIX}
_OPSYS_LIB_DIRS?=	/data/data/com.termux/files/usr/lib /data/data/com.termux/files/usr/lib${LIBABISUFFIX} /data/data/com.termux/files/usr/aarch64-linux-androideabi ${PREFIX}/lib${LIBABISUFFIX}
.  endif
.  if !empty(MACHINE_ARCH:Mpowerpc64le)
LIBABISUFFIX?=		/powerpc64le-linux-gnu
_OPSYS_SYSTEM_RPATH=	/lib:/usr/lib:/lib${LIBABISUFFIX}:/usr/lib${LIBABISUFFIX}
_OPSYS_LIB_DIRS?=	/lib /usr/lib /lib${LIBABISUFFIX} /usr/lib${LIBABISUFFIX}
.  endif
.else
_OPSYS_SYSTEM_RPATH=	/data/data/com.termux/files/usr/lib:/data/data/com.termux/files/usr/lib${LIBABISUFFIX}:${PREFIX}/lib${LIBABISUFFIX}
_OPSYS_LIB_DIRS?=	/data/data/com.termux/files/usr/lib /data/data/com.termux/files/usr/lib${LIBABISUFFIX} ${PREFIX}/lib${LIBABISUFFIX}
.endif
_OPSYS_INCLUDE_DIRS?=	/data/data/com.termux/files/usr/include ${PREFIX}/include

.if !empty(OS_VARIANT:Mchromeos)
_OPSYS_LIB_DIRS+=	/usr/local/lib
_OPSYS_INCLUDE_DIRS+=	/usr/local/include
.endif

# These are libc builtins
_OPSYS_PREFER.getopt?=		native
_OPSYS_PREFER.gettext?=		native
_OPSYS_PREFER.iconv?=		native
_OPSYS_PREFER.libexecinfo?=	native
_OPSYS_PREFER.libinotify?=	native
_OPSYS_PREFER.sysexits?=	native

.if exists(/data/data/com.termux/files/usr/include/netinet6) || exists(/data/data/com.termux/files/usr/include/linux/in6.h)
_OPSYS_HAS_INET6=	yes	# IPv6 is standard
.else
_OPSYS_HAS_INET6=	no	# IPv6 is not standard
.endif
_OPSYS_HAS_JAVA=	no	# Java is not standard
_OPSYS_HAS_MANZ=	no	# no MANZ for gzipping of man pages
_OPSYS_HAS_OSSAUDIO=	no	# libossaudio is unavailable
_OPSYS_PERL_REQD=		# no base version of perl required
_OPSYS_PTHREAD_AUTO=	no	# -lpthread needed for pthreads
_OPSYS_SHLIB_TYPE=	ELF	# shared lib type
_PATCH_CAN_BACKUP=	yes	# native patch(1) can make backups
_PATCH_BACKUP_ARG?= 	-b -V simple -z	# switch to patch(1) for backup suffix
_USE_RPATH=		yes	# add rpath to LDFLAGS

_STRIPFLAG_CC?=		${_INSTALL_UNSTRIPPED:D:U-s}	# cc(1) option to strip
_STRIPFLAG_INSTALL?=	${_INSTALL_UNSTRIPPED:D:U-s}	# install(1) option to strip

_OPSYS_SUPPORTS_CWRAPPERS=	yes

_OPSYS_CAN_CHECK_SHLIBS=	yes # use readelf in check/bsd.check-vars.mk
_OPSYS_CAN_CHECK_SSP=		no  # only supports libssp at this time

# check for maximum command line length and set it in configure's environment,
# to avoid a test required by the libtool script that takes forever.
.if exists(/data/data/com.termux/files/usr/bin/getconf)
_OPSYS_MAX_CMDLEN_CMD?=	/data/data/com.termux/files/usr/bin/getconf ARG_MAX
.endif

# Register support for FORTIFY (with GCC).  Linux only supports FORTIFY
# when optimisation is enabled, otherwise warnings are issued.
.if !empty(CFLAGS:M-O*)
_OPSYS_SUPPORTS_FORTIFY=yes
.endif

# Register support for RELRO on supported architectures (with GCC)
.if (${MACHINE_ARCH} == "i386") || \
    (${MACHINE_ARCH} == "x86_64")
_OPSYS_SUPPORTS_RELRO=	yes
.endif

# Register support for SSP on x86 architectures
.if (${MACHINE_ARCH} == "i386") || \
    (${MACHINE_ARCH} == "x86_64")
_OPSYS_SUPPORTS_SSP=	yes
.endif

.if ${MACHINE_ARCH} == "x86_64"
ABI?=		64
LIBABISUFFIX?=	64
.endif

.if ${MACHINE_ARCH} == "powerpc64le"
ABI?=		64
LIBABISUFFIX?=	64
.endif

# When building 32-bit packages on x86_64 GNU ld isn't smart enough to
# figure out the target architecture based on the objects so we need to
# explicitly set it.
.if ${HOST_MACHINE_ARCH} == "x86_64" && ${MACHINE_ARCH} == "i386"
_WRAP_EXTRA_ARGS.LD+=	-m elf_i386
CWRAPPERS_APPEND.ld+=	-m elf_i386
.endif

## Use _CMD so the command only gets run when needed!
.if exists(/data/data/com.termux/files/usr/lib${LIBABISUFFIX}/libc.so.6)
_GLIBC_VERSION_CMD=	/data/data/com.termux/files/usr/lib${LIBABISUFFIX}/libc.so.6 --version | \
				sed -ne's/^GNU C.*version \(.*\),.*$$/\1/p'
GLIBC_VERSION=		${_GLIBC_VERSION_CMD:sh}
.endif

# If this is defined pass it to the make process. 
.if defined(NOGCCERROR)
MAKE_ENV+=	NOGCCERROR=true
.endif
