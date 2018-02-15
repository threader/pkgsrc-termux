$NetBSD: patch-outgoing_tnstate.c,v 1.2 2013/09/10 14:15:11 joerg Exp $

Add missing header files (for cleanup()).

--- outgoing/tnstate.c.orig	1996-04-30 07:02:49.000000000 +0000
+++ outgoing/tnstate.c
@@ -40,6 +40,8 @@ static char sccsid[] = "@(#)state.c	8.1 
 
 #include "tndefs.h"
 #include "tnext.h"
+#include "cdefs.h"
+#include "global.h"
 
 unsigned char	doopt[] = { IAC, DO, '%', 'c', 0 };
 unsigned char	dont[] = { IAC, DONT, '%', 'c', 0 };
@@ -105,7 +107,7 @@ telrcv()
 			state = TS_DATA;
 			/* Strip off \n or \0 after a \r */
 			if (his_state_is_wont(TELOPT_BINARY)
-			    && (c == 0) || (c == '\n')) {
+			    && ((c == 0) || (c == '\n'))) {
 				break;
 			}
 			/* FALL THROUGH */
