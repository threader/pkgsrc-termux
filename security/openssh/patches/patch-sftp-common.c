$NetBSD: patch-sftp-common.c,v 1.4 2016/01/18 12:53:26 jperkin Exp $

Include <unistd.h> for strmode(3).

--- sftp-common.c.orig	2015-08-21 04:49:03.000000000 +0000
+++ sftp-common.c
@@ -37,6 +37,9 @@
 #include <string.h>
 #include <time.h>
 #include <stdarg.h>
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
 #ifdef HAVE_UTIL_H
 #include <util.h>
 #endif
