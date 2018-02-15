$NetBSD: patch-src_core_core.pro,v 1.2 2017/12/18 21:21:44 plunky Exp $

fix build for pkgsrc, by allowing qmake to link binaries in situ
and create an install target

--- src/core/core.pro.orig	2016-07-01 07:13:14.000000000 +0000
+++ src/core/core.pro
@@ -281,8 +281,9 @@ TARGET = $${NAME}
 RESOURCES = resources/core.qrc
 OTHER_FILES += core.dox math/math.dox
 DEFINES += QCADCORE_LIBRARY
+INSTALLS += target

-LIBS += -lopennurbs -lzlib
+LIBS += -L../3rdparty/opennurbs/opennurbs -lopennurbs

 win32 {
     LIBS += -lRpcrt4 -lAdvapi32
