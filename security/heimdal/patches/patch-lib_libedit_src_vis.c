$NetBSD: patch-lib_libedit_src_vis.c,v 1.4 2015/09/17 17:12:19 joerg Exp $

* Fix OpenBSD 5.5 build

--- lib/libedit/src/vis.c.orig	2012-12-09 22:06:44.000000000 +0000
+++ lib/libedit/src/vis.c
@@ -67,6 +67,7 @@
 #include <vis.h>
 #include <stdlib.h>
 
+#if !defined(__OpenBSD__)
 #ifdef __weak_alias
 __weak_alias(strsvis,_strsvis)
 __weak_alias(strsvisx,_strsvisx)
@@ -75,6 +76,7 @@ __weak_alias(strvisx,_strvisx)
 __weak_alias(svis,_svis)
 __weak_alias(vis,_vis)
 #endif
+#endif
 
 #if !HAVE_VIS || !HAVE_SVIS
 #include <ctype.h>
