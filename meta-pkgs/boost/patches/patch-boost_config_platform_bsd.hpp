$NetBSD: patch-boost_config_platform_bsd.hpp,v 1.1 2017/08/24 19:31:32 adam Exp $

--- boost/config/platform/bsd.hpp.orig	2011-03-07 13:07:30.000000000 +0000
+++ boost/config/platform/bsd.hpp
@@ -37,7 +37,7 @@
 // and not in <unistd.h>
 //
 #if (defined(__FreeBSD__) && (__FreeBSD__ <= 3))\
-   || defined(__OpenBSD__) || defined(__DragonFly__) 
+   || defined(__OpenBSD__) || defined(__DragonFly__) || defined(__NetBSD__)
 #  define BOOST_HAS_PTHREADS
 #endif
 
@@ -56,13 +56,15 @@
 #endif
 
 #if !((defined(__FreeBSD__) && (__FreeBSD__ >= 5)) \
-      || (defined(__NetBSD_GCC__) && (__NetBSD_GCC__ >= 2095003)) || defined(__DragonFly__))
+      || (defined(__NetBSD_GCC__) && (__NetBSD_GCC__ >= 2095003)) \
+      || defined(__DragonFly__) \
+      || defined(__OpenBSD__))
 #  define BOOST_NO_CWCHAR
 #endif
 //
 // The BSD <ctype.h> has macros only, no functions:
 //
-#if !defined(__OpenBSD__) || defined(__DragonFly__)
+#if defined(__FreeBSD__) || defined(__DragonFly__)
 #  define BOOST_NO_CTYPE_FUNCTIONS
 #endif
 
