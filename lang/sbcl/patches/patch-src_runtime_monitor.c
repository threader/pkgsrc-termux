$NetBSD: patch-src_runtime_monitor.c,v 1.1 2016/10/12 11:35:48 asau Exp $

--- src/runtime/monitor.c.orig	2016-09-30 16:41:12.000000000 +0000
+++ src/runtime/monitor.c
@@ -9,6 +9,10 @@
  * files for more information.
  */
 
+#if defined(__NetBSD__)
+#define _KERNTYPES
+#endif
+
 #include "sbcl.h"
 
 #include <stdio.h>
