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
task_load makedir
task_load which
task_load unittest

test_setup()
{
	: ${CHMOD:=chmod}

	task_makedir bin usr/bin
	task_createfile bin/cmd1 usr/bin/cmd2
	${CHMOD} +x bin/cmd1 usr/bin/cmd2

	TEST_PATH="${TEST_CURDIR}/bin:${TEST_CURDIR}/usr/bin"
}

test1()
{
	describe="cmd in first directory"
	local expected value
	expected="${TEST_CURDIR}/bin/cmd1"
	value=$( PATH="${TEST_PATH}" task_which cmd1 )
	if [ "$value" != "$expected" ]; then
		echo "$value"
		return 1
	fi
	return 0
}

test2()
{
	describe="cmd in second directory"
	local expected value
	expected="${TEST_CURDIR}/usr/bin/cmd2"
	value=$( PATH="${TEST_PATH}" task_which cmd2 )
	if [ "$value" != "$expected" ]; then
		echo "$value"
		return 1
	fi
	return 0
}

test3()
{
	describe="cmd in no directories"
	local expected value
	expected=""
	value=$( PATH="${TEST_PATH}" task_which cmd3 )
	if [ "$value" != "$expected" ]; then
		echo "$value"
		return 1
	fi
	return 0
}

test4()
{
	describe="empty cmd"
	local expected value
	expected=""
	value="$( task_which '' )"
	if [ "$value" != "$expected" ]; then
		echo "$value"
		return 1
	fi
	return 0
}

task_run_tests "$@"
