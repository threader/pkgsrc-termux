# $NetBSD: versioned_dependencies.mk,v 1.30 2017/11/26 09:43:33 wiz Exp $
#
# This file determines which separate distribution of a Python
# package is used as dependency, depending on the Python version
# used.
#
# === User-settable variables ===
#
# PYTHON_VERSIONED_DEPENDENCIES
#       The Python package which should be added as a dependency.
#
#       Possible values: Pmw X dialog ephem flup ipython jsonlib python-digest
#       Default: (nothing)
#

.include "../../lang/python/pyversion.mk"

_SUPPORTED_PACKAGES=	# empty
_SUPPORTED_PACKAGES+=	Pmw x11/py-Pmw x11/py-Pmw2
_SUPPORTED_PACKAGES+=	X textproc/py-X2 textproc/py-X
_SUPPORTED_PACKAGES+=	dialog devel/py-dialog2 devel/py-dialog
_SUPPORTED_PACKAGES+=	ephem math/py-ephem math/py-ephem3
_SUPPORTED_PACKAGES+=	flup www/py-flup www/py-flup3
_SUPPORTED_PACKAGES+=	ipython devel/py-ipython5 devel/py-ipython
_SUPPORTED_PACKAGES+=	jsonlib textproc/py-jsonlib textproc/py-jsonlib3
_SUPPORTED_PACKAGES+=	python-digest www/py-python-digest www/py-python3-digest

.for pattern in ${PYTHON_VERSIONED_DEPENDENCIES}
_PKG_MATCHED=	no
pkg:=	${pattern:C/:.*//}
type:=	${pattern:C/[^:]*//}
.  for name py2dir py3dir in ${_SUPPORTED_PACKAGES}
.    if "${pkg}" == "${name}"
_PKG_MATCHED=	yes
.      if ${PYPKGPREFIX} == "py27"
dir:=	${py2dir}
.      else
dir:=	${py3dir}
.      endif
.      if "${type}" == ":link"
.include "../../${dir}/buildlink3.mk"
.      elif "${type}" == ":build"
BUILD_DEPENDS:=	${BUILD_DEPENDS} ${PYPKGPREFIX}-${pkg}-[0-9]*:../../${dir}
.      else
DEPENDS:=	${DEPENDS} ${PYPKGPREFIX}-${pkg}-[0-9]*:../../${dir}
.      endif
.    endif
.  endfor
.  if ${_PKG_MATCHED} == "no"
PKG_FAIL_REASON+=	"${pkg} unsupported in PYTHON_VERSIONED_DEPENDENCIES"
.  endif
.endfor
