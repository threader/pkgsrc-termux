$NetBSD: patch-lib_bch.c,v 1.2 2017/11/19 16:50:35 jmcneill Exp $

--- lib/bch.c.orig	2017-09-21 06:16:57.000000000 +0000
+++ lib/bch.c
@@ -61,8 +61,11 @@
 #include <linux/bitops.h>
 #else
 #include <errno.h>
-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__NetBSD__)
 #include <sys/endian.h>
+#elif defined(__APPLE__)
+#include <machine/endian.h>
+#define htobe32 htonl
 #else
 #include <endian.h>
 #endif
@@ -117,7 +120,7 @@ struct gf_poly_deg1 {
 };
 
 #ifdef USE_HOSTCC
-#if !defined(__DragonFly__) && !defined(__FreeBSD__)
+#if !defined(__DragonFly__) && !defined(__FreeBSD__) && !defined(__APPLE__)
 static int fls(int x)
 {
 	int r = 32;
