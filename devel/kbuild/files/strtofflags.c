/*
 * From http://ftp.netbsd.org/pub/NetBSD/misc/alc/libc/strtofflags.c
 */

/*	$NetBSD: strtofflags.c,v 1.1 2016/07/08 09:51:34 kamil Exp $	*/

/*-
 * Copyright (c) 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * @(#)stat_flags.c	8.1 (Berkeley) 5/31/93
 * $FreeBSD: src/lib/libc/gen/strtofflags.c,v 1.18.2.1 2000/06/28 01:52:24 joe Exp $
 * $DragonFly: src/lib/libc/gen/strtofflags.c,v 1.5 2008/06/02 20:17:07 dillon Exp $
 */
#include <sys/cdefs.h>
#ifndef lint
__RCSID("$NetBSD: strtofflags.c,v 1.1 2016/07/08 09:51:34 kamil Exp $");
#endif

#include <sys/types.h>
#include <sys/stat.h>

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static struct {
	char *name;
	u_long flag;
	int invert;
} mapping[] = {
	/* shorter names per flag first, all prefixed by "no" */
#ifdef SF_APPEND
	{ "nosappnd",		SF_APPEND,	0 },
	{ "nosappend",		SF_APPEND,	0 },
#endif
#ifdef SF_ARCHIVED
	{ "noarch",		SF_ARCHIVED,	0 },
	{ "noarchived",		SF_ARCHIVED,	0 },
#endif
#ifdef SF_IMMUTABLE
	{ "noschg",		SF_IMMUTABLE,	0 },
	{ "noschange",		SF_IMMUTABLE,	0 },
	{ "nosimmutable",	SF_IMMUTABLE,	0 },
#endif
#ifdef SF_NOHISTORY
	{ "noshistory",		SF_NOHISTORY,	1 },
#endif
#ifdef SF_NOUNLINK
	{ "nosunlnk",		SF_NOUNLINK,	1 },
	{ "nosunlink",		SF_NOUNLINK,	1 },
#endif
#ifdef UF_APPEND
	{ "nouappnd",		UF_APPEND,	0 },
	{ "nouappend",		UF_APPEND,	0 },
#endif
#ifdef UF_IMMUTABLE
	{ "nouchg",		UF_IMMUTABLE,	0 },
	{ "nouchange",		UF_IMMUTABLE,	0 },
	{ "nouimmutable",	UF_IMMUTABLE,	0 },
#endif
#ifdef UF_NODUMP
	{ "nodump",		UF_NODUMP,	1 },
#endif
#ifdef UF_OPAQUE
	{ "noopaque",		UF_OPAQUE,	0 },
#endif
#ifdef UF_NOHISTORY
	{ "nouhistory",		UF_NOHISTORY,	1 },
	{ "nohistory",		UF_NOHISTORY,	1 },
#endif
#ifdef UF_NOUNLINK
	{ "nouunlnk",		UF_NOUNLINK,	1 },
	{ "nouunlink",		UF_NOUNLINK,	1 },
#endif
};

#define MAXFLAGLEN	12
#define NMAPPING	__arraycount(mapping)

/*
 * fflagstostr --
 *	Convert file flags to a comma-separated string.  If no flags
 *	are set, return the empty string.
 */
static inline char *
fflagstostr(u_long flags)
{
	char *string;
	char *sp, *dp;
	u_long setflags;
	int i;

	string = malloc(NMAPPING * (MAXFLAGLEN + 1));
	if (string == NULL)
		goto out;

	setflags = flags;
	dp = string;
	for (i = 0; i < NMAPPING; i++) {
		if ((setflags & mapping[i].flag) == 0)
			continue;

		if (dp > string)
			*dp++ = ',';

		sp = mapping[i].name;
		if (mapping[i].invert)
			sp += 2;

		while (*sp != '\0')
			*dp++ = *sp++;

		setflags &= ~mapping[i].flag;
	}
	*dp = '\0';

out:
	return string;
}

/*
 * strtofflags --
 *	Take string of arguments and return file flags.  Return 0 on
 *	success, 1 on failure.  On failure, stringp is set to point
 *	to the offending token.
 */
static inline int
strtofflags(char **stringp, u_long *setp, u_long *clrp)
{
	u_long setf, clrf;
	char *string, *p;
	int i;

	setf = 0;
	clrf = 0;

	string = *stringp;

	while ((p = strsep(&string, "\t ,")) != NULL) {
		int p_off = 0;

		*stringp = p;
		if (*p == '\0')
			continue;

		if (strcmp(p, "no") == 0)
			p_off = 2;

		for (i = 0; i < NMAPPING; i++) {
			if (strcmp(p, mapping[i].name + p_off) != 0)
				continue;

			if (mapping[i].invert)
				clrf |= mapping[i].flag;
			else
				setf |= mapping[i].flag;
		}

		if (i == NMAPPING)
			return 1;
	}

	if (setp != NULL)
		*setp = setf;

	if (clrp != NULL)
		*clrp = clrf;

	return 0;
}
