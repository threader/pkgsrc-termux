# $NetBSD: replace.mk,v 1.5 2017/08/19 00:30:19 jlam Exp $
#

# _pkgformat-destdir-replace:
#	Updates a package in-place on the system.
#
# See also:
#	replace
#
# XXX: The whole replacement, from deinstalling the old package up
# to installing the new package, should be one transaction.
#
_pkgformat-replace: \
	replace-names \
	replace-tarup \
	replace-preserve-installed-info \
	replace-preserve-required-by \
	deinstall \
	install-clean \
	install \
	replace-fixup-required-by \
	replace-fixup-installed-info \
	.PHONY

# tarup is omitted for DESTDIR, because the benefits are very small
_pkgformat-destdir-replace: \
	replace-names \
	replace-destdir \
	.PHONY

# _pkgformat-undo-replace:
#	Undoes the actions from a previous _pkgformat-replace.
#
# See also:
#	undo-replace
#
_pkgformat-undo-replace: \
	undo-replace-check \
	replace-preserve-installed-info \
	replace-preserve-required-by \
	deinstall \
	undo-replace-install \
	replace-fixup-required-by \
	replace-clean \
	.PHONY

_pkgformat-destdir-undo-replace: \
	undo-replace-check \
	undo-destdir-replace-install \
	replace-clean \
	.PHONY

_INSTALLED_INFO_FILE=	${WRKDIR}/.replace-+INSTALLED_INFO
_REQUIRED_BY_FILE=	${WRKDIR}/.replace-+REQUIRED_BY

_COOKIE.replace=	${WRKDIR}/.replace_done
_REPLACE_OLDNAME_FILE=	${WRKDIR}/.replace_oldname
_REPLACE_NEWNAME_FILE=	${WRKDIR}/.replace_newname

_REPLACE_OLDNAME_CMD=	\
	[ -f ${_REPLACE_OLDNAME_FILE} ] \
	|| ${FAIL_MSG} "[${.TARGET}] ${_REPLACE_OLDNAME_FILE}: File not found"; \
	oldname=`${CAT} ${_REPLACE_OLDNAME_FILE}`

_REPLACE_NEWNAME_CMD=	\
	[ -f ${_REPLACE_NEWNAME_FILE} ] \
	|| ${FAIL_MSG} "[${.TARGET}] ${_REPLACE_NEWNAME_FILE}: File not found"; \
	newname=`${CAT} ${_REPLACE_NEWNAME_FILE}`

# Verifies that there was a previous "replace" action performed that can be undone.
#
undo-replace-check: .PHONY
	${RUN} [ -f ${_COOKIE.replace} ] \
	|| ${FAIL_MSG} "No replacement to undo!"

# Generates a binary package for the (older) installed package using pkg_tarup.
#
replace-tarup: .PHONY
	${RUN} [ -x ${_PKG_TARUP_CMD:Q} ] \
	|| ${FAIL_MSG} ${_PKG_TARUP_CMD:Q}" was not found.";		\
	${_REPLACE_OLDNAME_CMD};					\
	${PKGSRC_SETENV} PKG_DBDIR=${_PKG_DBDIR} PKG_SUFX=${PKG_SUFX}	\
		PKGREPOSITORY=${WRKDIR}					\
		${_PKG_TARUP_CMD} $${oldname} ||			\
	${FAIL_MSG} "Could not pkg_tarup $${oldname}".

# Re-installs the old package that has been saved by replace-tarup.
#
undo-replace-install: .PHONY
	@${PHASE_MSG} "Re-adding ${PKGNAME} from saved tar-up package."
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	${ECHO} "Installing saved package ${WRKDIR}/$${oldname}${PKG_SUFX}"; \
	${SETENV} ${PKGTOOLS_ENV} ${PKG_ADD} ${WRKDIR}/$${oldname}${PKG_SUFX}

undo-destdir-replace-install: .PHONY
	@${PHASE_MSG} "Re-adding ${PKGNAME} from saved tar-up package."
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	${ECHO} "Installing saved package ${WRKDIR}/$${oldname}${PKG_SUFX}"; \
	${SETENV} ${PKGTOOLS_ENV} ${PKG_ADD} -U -D ${WRKDIR}/$${oldname}${PKG_SUFX}

# Computes and saves the full names of the installed package to be replaced
# (oldname) and the package that will be installed (newname), so that these
# names are available later.
#
replace-names: .PHONY
	${RUN} if [ x"${OLDNAME}" = x ]; then				\
		wildcard=${PKGWILDCARD:Q};				\
	else								\
		wildcard="${OLDNAME}-[0-9]*";				\
	fi;								\
	${_PKG_BEST_EXISTS} "$${wildcard}" > ${_REPLACE_OLDNAME_FILE}
	${RUN} ${ECHO} ${PKGNAME} > ${_REPLACE_NEWNAME_FILE}
	${RUN} ${CP} -f ${_REPLACE_NEWNAME_FILE} ${_COOKIE.replace}

# Saves and removes the +INSTALLED_INFO file from the installed package.
#
replace-preserve-installed-info: .PHONY
	@${STEP_MSG} "Preserving existing +INSTALLED_INFO file."
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	installed_info="${_PKG_DBDIR}/$$oldname/+INSTALLED_INFO";	\
	${TEST} ! -f "$$installed_info" ||				\
	${MV} $$installed_info ${_INSTALLED_INFO_FILE}

# Saves and removes the +REQUIRED_BY file from the installed package.
#
replace-preserve-required-by: .PHONY
	@${STEP_MSG} "Preserving existing +REQUIRED_BY file."
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	required_by="${_PKG_DBDIR}/$$oldname/+REQUIRED_BY";		\
	${TEST} ! -f "$$required_by" ||					\
	${MV} $$required_by ${_REQUIRED_BY_FILE}

# Fixes the +CONTENTS files of dependent packages to refer to the
# replacement package, and puts the +REQUIRED_BY file back into place.
# It also sets the unsafe_depends_strict tag on each dependent package,
# and sets the unsafe_depends tag if the replaced package has a different
# version.
#
# XXX Only set unsafe_depends if there is an ABI change.
#
replace-fixup-required-by: .PHONY
	@${STEP_MSG} "Fixing @pkgdep entries in dependent packages."
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	${_REPLACE_NEWNAME_CMD};					\
	${TEST} -f ${_REQUIRED_BY_FILE} || exit 0;			\
	${CAT} ${_REQUIRED_BY_FILE} |					\
	while read pkg; do						\
		case $$pkg in						\
		"")	continue ;;					\
		/*)	pkgdir="$$pkg" ;;				\
		*)	pkgdir="${_PKG_DBDIR}/$$pkg" ;;			\
		esac;							\
		contents="$$pkgdir/+CONTENTS";				\
		newcontents="$$contents.$$$$";				\
		${PKGSRC_SETENV} OLDNAME="$$oldname" NEWNAME="$$newname"	\
		${AWK} '($$0 ~ "^@pkgdep " ENVIRON["OLDNAME"])		\
			{ print "@pkgdep " ENVIRON["NEWNAME"]; next }	\
			{ print }'					\
			$$contents > $$newcontents;			\
		${MV} -f $$newcontents $$contents;			\
		${PKG_ADMIN} set unsafe_depends_strict=YES $$pkg;	\
		if ${TEST} "$$oldname" != "$$newname"; then		\
			${PKG_ADMIN} set unsafe_depends=YES $$pkg;	\
		fi;							\
	done;								\
	${MV} ${_REQUIRED_BY_FILE} ${_PKG_DBDIR}/$$newname/+REQUIRED_BY

# Removes unsafe_depends* and rebuild tags from this package.
#
# XXX: pkg_admin should not complain on unset with no +INSTALLED_INFO.
#
replace-fixup-installed-info: .PHONY
	@${STEP_MSG} "Removing unsafe_depends and rebuild tags."
	${RUN} ${_REPLACE_NEWNAME_CMD};					\
	[ ! -f ${_INSTALLED_INFO_FILE} ] ||			\
	${MV} ${_INSTALLED_INFO_FILE} ${_PKG_DBDIR}/$$newname/+INSTALLED_INFO; \
	for var in unsafe_depends unsafe_depends_strict rebuild; do	\
		${TEST} ! -f ${_PKG_DBDIR}/$$newname/+INSTALLED_INFO || \
		${PKG_ADMIN} unset $$var $$newname;			\
	done

# Removes the state files for the "replace" target, so that it may be re-invoked.
#
replace-clean: .PHONY
	${RUN} ${_REPLACE_OLDNAME_CMD};					\
	${_REPLACE_NEWNAME_CMD};					\
	${RM} -f ${WRKDIR}/$$oldname${PKG_SUFX};			\
	${RM} -f ${WRKDIR}/$$newname${PKG_SUFX};			\
	${RM} -f ${_REPLACE_OLDNAME_FILE} ${_REPLACE_NEWNAME_FILE}	\
		${_COOKIE.replace}

# Logically we would like to do a "pkg_add -U".  However, that fails
# if there is a depending package that exactly depends on the package
# being replaced, so we override that check with -D.  Historically,
# 'make replace' would replace a package regardless of whether that
# broke depending packages (typically due to shlib ABI changes,
# especially major version bumps).  Therefore, make replace in DESTDIR
# mode should behave the same way.  unsafe_depends will be set on
# depending packages, and then those may be rebuilt via a manual
# process or by pkg_rolling-replace.
replace-destdir: .PHONY
	@${PHASE_MSG} "Updating using binary package of "${PKGNAME:Q}
.if !empty(USE_CROSS_COMPILE:M[yY][eE][sS])
	@${MKDIR} ${_CROSS_DESTDIR}${PREFIX}
	${SETENV} ${PKGTOOLS_ENV} ${PKG_ADD} -U -D -m ${MACHINE_ARCH} -I -p ${_CROSS_DESTDIR}${PREFIX} ${STAGE_PKGFILE}
	@${ECHO} "Fixing recorded cwd..."
	@${SED} -e 's|@cwd ${_CROSS_DESTDIR}|@cwd |' ${_PKG_DBDIR}/${PKGNAME:Q}/+CONTENTS > ${_PKG_DBDIR}/${PKGNAME:Q}/+CONTENTS.tmp
	@${MV} ${_PKG_DBDIR}/${PKGNAME:Q}/+CONTENTS.tmp ${_PKG_DBDIR}/${PKGNAME:Q}/+CONTENTS
.else
	${SETENV} ${PKGTOOLS_ENV} ${PKG_ADD} -U -D ${STAGE_PKGFILE}
.endif
	${RUN}${_REPLACE_OLDNAME_CMD}; \
	${PKG_INFO} -qR ${PKGNAME:Q} | while read pkg; do \
		[ -n "$$pkg" ] || continue; \
		${PKG_ADMIN} set unsafe_depends_strict=YES "$$pkg"; \
		if [ "$$oldname" != ${PKGNAME:Q} ]; then \
			${PKG_ADMIN} set unsafe_depends=YES "$$pkg"; \
		fi; \
	done
	${RUN}${PKG_ADMIN} unset unsafe_depends ${PKGNAME:Q}
	${RUN}${PKG_ADMIN} unset unsafe_depends_strict ${PKGNAME:Q}
	${RUN}${PKG_ADMIN} unset rebuild ${PKGNAME:Q}
