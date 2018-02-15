$NetBSD: patch-ex_ex__script.c,v 1.1 2013/01/23 17:33:28 wiz Exp $

--- ex/ex_script.c.orig	2007-11-18 16:41:42.000000000 +0000
+++ ex/ex_script.c
@@ -23,8 +23,10 @@ static const char sccsid[] = "$Id: ex_sc
 #include <sys/select.h>
 #endif
 #include <sys/stat.h>
-#ifdef HAVE_SYS5_PTY
+#ifdef HAVE_SYS_STROPTS_H
 #include <sys/stropts.h>
+#elif defined(HAVE_STROPTS_H)
+#include <stropts.h>
 #endif
 #include <sys/time.h>
 #include <sys/wait.h>
@@ -750,6 +752,7 @@ ptys_open(int fdm, char *pts_name)
 		return (-5);
 	}
 
+#ifndef __linux__
 	if (ioctl(fds, I_PUSH, "ptem") < 0) {
 		close(fds);
 		close(fdm);
@@ -767,6 +770,7 @@ ptys_open(int fdm, char *pts_name)
 		close(fdm);
 		return (-8);
 	}
+#endif
 
 	return (fds);
 }
