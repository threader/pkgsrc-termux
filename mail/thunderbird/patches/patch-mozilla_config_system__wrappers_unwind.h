$NetBSD: patch-mozilla_config_system__wrappers_unwind.h,v 1.5 2017/04/27 13:32:40 ryoon Exp $

--- mozilla/config/system_wrappers/unwind.h.orig	2017-04-25 12:22:45.864950181 +0000
+++ mozilla/config/system_wrappers/unwind.h
@@ -0,0 +1,4 @@
+#pragma GCC system_header
+#pragma GCC visibility push(default)
+#include_next <unwind.h>
+#pragma GCC visibility pop
