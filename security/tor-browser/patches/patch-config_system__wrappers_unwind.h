$NetBSD: patch-config_system__wrappers_unwind.h,v 1.1 2017/01/22 12:27:22 ryoon Exp $

--- config/system_wrappers/unwind.h.orig	2013-05-13 19:56:18.000000000 +0000
+++ config/system_wrappers/unwind.h
@@ -0,0 +1,4 @@
+#pragma GCC system_header
+#pragma GCC visibility push(default)
+#include_next <unwind.h>
+#pragma GCC visibility pop
