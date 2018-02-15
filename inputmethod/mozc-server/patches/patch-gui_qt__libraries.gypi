$NetBSD: patch-gui_qt__libraries.gypi,v 1.4 2017/12/17 14:15:43 tsutsui Exp $

* NetBSD support

--- gui/qt_libraries.gypi.orig	2017-11-02 13:32:47.000000000 +0000
+++ gui/qt_libraries.gypi
@@ -98,7 +98,7 @@
         '$(SDKROOT)/System/Library/Frameworks/Carbon.framework',
       ]
     }],
-    ['target_platform=="Linux"', {
+    ['target_platform=="Linux" or target_platform=="NetBSD"', {
       'cflags': ['<!@(pkg-config --cflags Qt5Widgets Qt5Gui Qt5Core)'],
       'libraries': ['<!@(pkg-config --libs Qt5Widgets Qt5Gui Qt5Core)'],
     }],
