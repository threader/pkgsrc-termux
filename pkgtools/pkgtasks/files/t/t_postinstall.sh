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

task_load createfile
task_load postinstall
task_load unittest

test_setup()
{
	datafile="empty"
	task_createfile "$datafile"

	TASK_DIRECTORIES_SUCCESS="yes"
	TASK_FILES_SUCCESS="yes"
	TASK_FONTS_SUCCESS="yes"
	TASK_FUNCTION_SUCCESS="yes"
	TASK_ICON_THEMES_SUCCESS="yes"
	TASK_INFO_FILES_SUCCESS="yes"
	TASK_OCAML_FINDLIB_SUCCESS="yes"
	TASK_PERMISSIONS_SUCCESS="yes"
	TASK_SHELLS_SUCCESS="yes"
	TASK_SHLIBS_SUCCESS="yes"
}

# Mock actions that return the truthiness of environment variables.
mock_pkgtask()
{
	# required parameters
	local name="$1"; shift
	local varname="$1"; shift

	# pkgtask parameters
	local arg
	local silent=
	local OPTIND=1
	while getopts ":s" arg "$@"; do
		case $arg in
		s)	silent="yes" ;;
		*)	return 127 ;;
		esac
	done
	shift $(( ${OPTIND} - 1 ))
	local action="$1"; shift
	local stage="$1"; shift

	local value symbol result
	eval value="\${$varname}"
	if [ "$value" = "yes" ]; then
		symbol=">"
		result=0
	else
		symbol="!"
		result=1
	fi

	# Skip output if doing a "check" action.
	case $action in
	check-*)
		: "do nothing" ;;
	*)	[ -n "$silent" ] || echo "$symbol $name" ;;
	esac
	return $result
}

task_directories()
{
	mock_pkgtask "directories" "TASK_DIRECTORIES_SUCCESS" "$@"
}

task_files()
{
	mock_pkgtask "files" "TASK_FILES_SUCCESS" "$@"
}

task_fonts()
{
	mock_pkgtask "fonts" "TASK_FONTS_SUCCESS" "$@"
}

task_function()
{
	mock_pkgtask "function" "TASK_FUNCTION_SUCCESS" "$@"
}

task_icon_themes()
{
	mock_pkgtask "icon_themes" "TASK_ICON_THEMES_SUCCESS" "$@"
}

task_info_files()
{
	mock_pkgtask "info_files" "TASK_INFO_FILES_SUCCESS" "$@"
}

task_ocaml_findlib()
{
	mock_pkgtask "ocaml_findlib" "TASK_OCAML_FINDLIB_SUCCESS" "$@"
}

task_permissions()
{
	mock_pkgtask "permissions" "TASK_PERMISSIONS_SUCCESS" "$@"
}

task_shells()
{
	mock_pkgtask "shells" "TASK_SHELLS_SUCCESS" "$@"
}

task_shlibs()
{
	mock_pkgtask "shlibs" "TASK_SHLIBS_SUCCESS" "$@"
}

# Only succeed if all of the actions were successful.

test1()
{
	describe="dirs fail"
	TASK_DIRECTORIES_SUCCESS="no"
	if task_postinstall "$datafile"; then
		: "dirs should only be used to check"
	else
		return 1
	fi
	return 0
}

test2()
{
	describe="files fail"
	TASK_FILES_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test3()
{
	describe="fonts fail"
	TASK_FONTS_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test4()
{
	describe="function fail"
	TASK_FUNCTION_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test5()
{
	describe="icon_themes fail"
	TASK_ICON_THEMES_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test6()
{
	describe="info_files fail"
	TASK_INFO_FILES_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test7()
{
	describe="ocaml_findlib fail"
	TASK_OCAML_FINDLIB_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test8()
{
	describe="permissions fail"
	TASK_PERMISSIONS_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test9()
{
	describe="shells fail"
	TASK_SHELLS_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test10()
{
	describe="shlibs fail"
	TASK_SHLIBS_SUCCESS="no"
	if task_postinstall "$datafile"; then
		return 1
	fi
	return 0
}

test11()
{
	describe="all succeed"
	if task_postinstall "$datafile"; then
		: "success"
	else
		return 1
	fi
	return 0
}

test12()
{
	: ${CAT:=cat}

	describe="\${TASK_VERBOSE} = none"
	TASK_VERBOSE=none
	task_postinstall "$datafile" > output
	${CAT} output
	if [ -s "$output" ]; then
		# no output expected
		return 1
	fi
	return 0
}

test13()
{
	: ${CAT:=cat}
	: ${GREP:=grep}

	describe="\${TASK_VERBOSE} = all"
	TASK_VERBOSE=all
	task_postinstall "$datafile" > output
	${CAT} output
	for task in \
		files fonts function icon_themes info_files \
		ocaml_findlib permissions shells shlibs
	do
		if ${GREP} -q "$task" output; then
			: "success"
		else
			describe="$describe: '$task' missing!"
			return 1
		fi
	done
	return 0
}

task_run_tests "$@"
