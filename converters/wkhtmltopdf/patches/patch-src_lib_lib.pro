$NetBSD: patch-src_lib_lib.pro,v 1.1 2017/09/10 19:58:36 joerg Exp $

--- src/lib/lib.pro.orig	2017-09-10 12:16:27.317023665 +0000
+++ src/lib/lib.pro
@@ -18,6 +18,8 @@
 TEMPLATE = lib
 CONFIG += dll
 
+LIBS+= ${COMPILER_RPATH_FLAG}${X11PREFIX}/lib ${COMPILER_RPATH_FLAG}${PREFIX}/lib
+
 include(../../common.pri)
 include(lib.pri)
 
