$NetBSD: patch-libtest_test.hpp,v 1.3 2017/10/09 07:48:52 adam Exp $

cstdarg needed for va_start.

--- libtest/test.hpp.orig	2014-02-09 11:52:42.000000000 +0000
+++ libtest/test.hpp
@@ -57,6 +57,7 @@
 
 #define LIBYATL_DEFAULT_PARAM __FILE__, __LINE__, __PRETTY_FUNCTION__
 
+#include <cstdarg>
 #include <cstdio>
 #include <cstdlib>
 #include <arpa/inet.h>
