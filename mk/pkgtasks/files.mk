# $NetBSD: files.mk,v 1.9 2017/08/19 00:30:55 jlam Exp $
#
# Copyright (c) 2017 The NetBSD Foundation, Inc.
# All rights reserved.
#
# This code is derived from software contributed to The NetBSD Foundation
# by Johnny C. Lam.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Generate the data file for the files package task.

###
# CONF_FILES
# REQD_FILES
# _INIT_SCRIPTS
#	List of pairs of files that should be copied and removed when
#	the package is installed and removed.  The pairs are of the
#	form:
#
#		<source> <target>
#
#	During installation, if the target file does not exist, then the
#	source file is copied into place.  During removal, if the target
#	file does not differ from the source file, then the target file
#	is also removed.
#
#	CONF_FILES triggers system changes only if PKG_CONFIG is "yes".
#	REQD_FILES always trigger system changes (PKG_CONFIG is ignored).
#	_INIT_SCRIPTS trigger system changes only if PKG_CONFIG and
#	PKG_INIT_SCRIPTS are both "yes".
#
#	The use-case for REQD_FILES is very specialized, and most packages
#	should be using CONF_FILES instead.
#
#	If the source and target pathnames are relative paths, then they
#	are taken to be relative to ${PREFIX}.
#
# CONF_FILES_MODE
# REQD_FILES_MODE
# _INIT_SCRIPTS_MODE
#	These are the file modes for the target files listed in CONF_FILES,
#	REQD_FILES, and _INIT_SCRIPTS, respectively.
#
# CONF_FILES_PERMS
# REQD_FILES_PERMS
# _INIT_SCRIPTS_PERMS
#	List of sublists representing files with ownership and explicit
#	modes that should be copied and removed when the package is
#	installed and removed.  The sublists are of the form:
#
#		<source> <target> <owner> <group> <mode>
#
#	These variables have the same usage as the similarly-named
#	variables that don't end in "_PERMS".
#
# The _INIT_SCRIPTS* variables are a hook for bsd.init.mk into the config
# file framework.  They should not be used by packages.
#
_PKG_VARS.pkgtasks+=	CONF_FILES CONF_FILES_MODE CONF_FILES_PERMS \
			REQD_FILES REQD_FILES_MODE REQD_FILES_PERMS
CONF_FILES?=		# empty
CONF_FILES_MODE?=	0644
CONF_FILES_PERMS?=	# empty
REQD_FILES?=		# empty
REQD_FILES_MODE?=	0644
REQD_FILES_PERMS?=	# empty
_INIT_SCRIPTS?=		# empty
_INIT_SCRIPTS_MODE?=	0755
_INIT_SCRIPTS_PERMS?=	# empty

# Trigger pkgtasks dependency if needed.
_PKGTASKS_DATAVARS.files+=		\
	CONF_FILES CONF_FILES_PERMS	\
	REQD_FILES REQD_FILES_PERMS	\
	_INIT_SCRIPTS _INIT_SCRIPTS_PERMS
.for _var_ in ${_PKGTASKS_DATAVARS.files}
.  if !empty(${_var_})
USE_PKGTASKS=		yes
.  endif
.endfor

# Strip leading "${PREFIX}/" from the file pathnames.
_CONF_FILES=		${CONF_FILES:S|^${PREFIX}/||g}
_CONF_FILES_PERMS=	${CONF_FILES_PERMS:S|^${PREFIX}/||g}
_REQD_FILES=		${REQD_FILES:S|^${PREFIX}/||g}
_REQD_FILES_PERMS=	${REQD_FILES_PERMS:S|^${PREFIX}/||g}
__INIT_SCRIPTS=		${_INIT_SCRIPTS:S|^${PREFIX}/||g}
__INIT_SCRIPTS_PERMS=	${_INIT_SCRIPTS_PERMS:S|^${PREFIX}/||g}

# ASSERT: The variables have the right number of words and that
#	no target file is listed in more than one variable.
#
_ALL_TARGET_FILES.files=	# empty
.for _var_ in CONF_FILES REQD_FILES _INIT_SCRIPTS
.  if empty(${_var_}) || empty(${_var_}:C/.*/2/:M*:S/2 2//gW)
# ${_var_} has a multiple of 2 words.
.    for s t in ${${_var_}}
_FILE_VARLIST.${t}+=		${_var_}
_ALL_TARGET_FILES.files+=	${t}
.    endfor
.  else
PKG_FAIL_REASON+=	${_var_:Q}" must have a multiple of 2 words."
.  endif
.endfor
.for _var_ in CONF_FILES_PERMS REQD_FILES_PERMS _INIT_SCRIPT_PERMS
.  if empty(${_var_}) || empty(${_var_}:C/.*/5/:M*:S/5 5 5 5 5//gW)
# ${_var_} has a multiple of 5 words.
.    for s t o g m in ${${_var_}}
_FILE_VARLIST.${t}+=		${_var_}
_ALL_TARGET_FILES.files+=	${t}
.    endfor
.  else
PKG_FAIL_REASON+=	${_var_:Q}" must have a multiple of 5 words."
.  endif
.endfor
.for t in ${_ALL_TARGET_FILES.files:O:u}
.  if ${_FILE_VARLIST.${t}:[#]} != 1
PKG_FAIL_REASON+=       ${t:Q}" is listed more than once: "${_FILE_VARLIST.${t}:Q}
.  endif
.endfor

# Hook into directories.mk to create ${PKG_SYSCONFDIR} in the package
# tasks.
#
# The following variables used are set within bsd.pkg.mk:
#
#	PKG_SYSCONFDIR
#	PKG_SYSCONFDIR_PERMS
#	PKG_SYSCONFSUBDIR
#
.if defined(PKG_SYSCONFSUBDIR) && !empty(PKG_SYSCONFSUBDIR)
# Always create ${PKG_SYSCONFDIR} if ${PKG_SYSCONFSUBDIR} is non-empty.
MAKE_DIRS_PERMS+=	${PKG_SYSCONFDIR} ${PKG_SYSCONFDIR_PERMS}
_ALL_DIRS.directories+=	${PKG_SYSCONFDIR}
.elif !empty(_ALL_TARGET_FILES.files:M${PKG_SYSCONFDIR}/*)
# Create ${PKG_SYSCONFDIR} if any target files are in that directory.
MAKE_DIRS+=		${PKG_SYSCONFDIR}
_ALL_DIRS.directories+=	${PKG_SYSCONFDIR}
.endif

# ASSERT: The directories that contain target files are listed in
#	one of the directory variables.  This makes use of
#	${_ALL_DIRS.directories}, which is defined in directories.mk.
#
.for t in ${_ALL_TARGET_FILES.files:O:u}
_FILEMATCH.${t}=	${_ALL_DIRS.directories:@d@${t:M${d}/*}@}
.  if empty(_FILEMATCH.${t})
PKG_FAIL_REASON+=	"This package may need MAKE_DIRS+="${t:C|/[^/]*$||:Q}
.  endif
.endfor

_PKGTASKS_DATA.files=	${_PKGTASKS_DIR}/files
_PKGTASKS_DATAFILES+=	${_PKGTASKS_DATA.files}

${_PKGTASKS_DATA.files}:
	${RUN}${MKDIR} ${.TARGET:H:Q}
	${RUN}exec > ${.TARGET:Q}.tmp
	${RUN}set -- args ${_CONF_FILES}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2"; shift 2;			\
		${ECHO} "# FILE: $$file c $$egfile "${CONF_FILES_MODE:Q} \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}set -- args ${_CONF_FILES_PERMS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2";				\
		owner="$$3"; group="$$4"; mode="$$5"; shift 5;		\
		${ECHO} "# FILE: $$file c $$egfile $$mode $$owner $$group" \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}set -- args ${_REQD_FILES}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2"; shift 2;			\
		${ECHO} "# FILE: $$file cf $$egfile "${REQD_FILES_MODE:Q} \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}set -- args ${_REQD_FILES_PERMS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2";				\
		owner="$$3"; group="$$4"; mode="$$5"; shift 5;		\
		${ECHO} "# FILE: $$file cf $$egfile $$mode $$owner $$group" \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}set -- args ${__INIT_SCRIPTS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2"; shift 2;			\
		${ECHO} "# FILE: $$file cr $$egfile "${_INIT_SCRIPTS_MODE:Q} \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}set -- args ${__INIT_SCRIPTS_PERMS}; shift;		\
	while ${TEST} "$$#" -gt 0; do					\
		egfile="$$1"; file="$$2";				\
		owner="$$3"; group="$$4"; mode="$$5"; shift 5;		\
		${ECHO} "# FILE: $$file cr $$egfile $$mode $$owner $$group" \
			>> ${.TARGET:Q}.tmp;				\
	done
	${RUN}${MV} ${.TARGET:Q}.tmp ${.TARGET:Q}

privileged-install-hook: _pkgtasks-files-postinstall-check

# _PKGTASKS_CHECK_EGFILE
#	Shell script macro to test for the existence of $$egfile in
#	${DESTDIR} after normalizing it with respect to ${PREFIX}, and
#	an error message is emitted if it is missing.
#
#	If $$egfile is an absolute path that is not rooted inside
#	${PREFIX}, then it is checked to see if it is in the host system,
#	and not under ${DESTDIR}, and only a warning message is emitted
#	if it is missing.  This allows for specifying source files for a
#	cross-build without requiring that the source file exists on the
#	host system.
#
_PKGTASKS_CHECK_EGFILE=	\
	${TEST} -n "$$varname" -a -n "$$egfile" ||			\
	${FAIL_MSG} "_PKGTASKS_CHECK_EGFILES called with missing variables"; \
	case $$egfile in						\
	${PREFIX:Q}/*)	canon_egfile=${DESTDIR:Q}"$$egfile" ;;		\
	/*)		canon_egfile= ;;				\
	*)		canon_egfile=${DESTDIR:Q}${PREFIX:Q}"/$$egfile" ;; \
	esac;								\
	if ${TEST} -n "$$canon_egfile"; then				\
		${TEST} -f "$$canon_egfile" ||				\
		${TEST} -c "$$canon_egfile" ||				\
		${FAIL_MSG} "$$varname - $$canon_egfile does not exist."; \
	else								\
		${TEST} -f "$$egfile" ||				\
		${TEST} -c "$$egfile" ||				\
		${WARNING_MSG} "$$varname - $$egfile does not exist.";	\
	fi

_pkgtasks-files-postinstall-check: .PHONY
	${RUN}set -- args ${_CONF_FILES}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 2 || break;				\
		egfile="$$1"; shift 2;					\
		varname="CONF_FILES"; ${_PKGTASKS_CHECK_EGFILE};	\
	done
	${RUN}set -- args ${_CONF_FILES_PERMS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 5 || break;				\
		egfile="$$1"; shift 5;					\
		varname="CONF_FILES_PERMS"; ${_PKGTASKS_CHECK_EGFILE};	\
	done
	${RUN}set -- args ${_REQD_FILES}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 2 || break;				\
		egfile="$$1"; shift 2;					\
		varname="REQD_FILES"; ${_PKGTASKS_CHECK_EGFILE};	\
	done
	${RUN}set -- args ${_REQD_FILES_PERMS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 5 || break;				\
		egfile="$$1"; shift 5;					\
		varname="REQD_FILES_PERMS"; ${_PKGTASKS_CHECK_EGFILE};	\
	done
	${RUN}set -- args ${__INIT_SCRIPTS}; shift;			\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 2 || break;				\
		egfile="$$1"; shift 2;					\
		varname="INIT_SCRIPTS"; ${_PKGTASKS_CHECK_EGFILE};	\
	done
	${RUN}set -- args ${__INIT_SCRIPTS_PERMS}; shift;		\
	while ${TEST} "$$#" -gt 0; do					\
		${TEST} "$$#" -ge 5 || break;				\
		egfile="$$1"; shift 5;					\
		varname="INIT_SCRIPTS_PERMS"; ${_PKGTASKS_CHECK_EGFILE}; \
	done
