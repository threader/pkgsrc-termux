$NetBSD: patch-src_src.pro,v 1.1 2016/05/07 09:46:14 joerg Exp $

--- src/src.pro.orig	2016-05-06 14:13:19.000000000 +0000
+++ src/src.pro
@@ -1330,4 +1330,6 @@ unix {
 	target.path = /usr/bin
 
 	INSTALLS += target
+
+	QMAKE_LFLAGS += ${COMPILER_RPATH_FLAG}${X11BASE}/lib
 }
