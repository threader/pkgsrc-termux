$NetBSD: patch-mfbt_double-conversion_utils.h,v 1.1 2016/08/30 07:45:51 richard Exp $
deal with aarch64
--- mfbt/double-conversion/utils.h.orig	2013-02-11 22:33:28.000000000 +0000
+++ mfbt/double-conversion/utils.h
@@ -58,7 +58,7 @@
     defined(__mips__) || defined(__powerpc__) || \
     defined(__sparc__) || defined(__sparc) || defined(__s390__) || \
     defined(__SH4__) || defined(__alpha__) || \
-    defined(_MIPS_ARCH_MIPS32R2)
+    defined(_MIPS_ARCH_MIPS32R2) || defined(__aarch64__)
 #define DOUBLE_CONVERSION_CORRECT_DOUBLE_OPERATIONS 1
 #elif defined(_M_IX86) || defined(__i386__) || defined(__i386)
 #if defined(_WIN32)
