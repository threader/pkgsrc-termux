$NetBSD: patch-misc_cgo_test_cthread__unix.c,v 1.1 2015/07/31 14:46:25 bsiegert Exp $

Support cgo on illumos.

--- misc/cgo/test/cthread_unix.c.orig	2014-12-11 01:18:10.000000000 +0000
+++ misc/cgo/test/cthread_unix.c
@@ -2,7 +2,7 @@
 // Use of this source code is governed by a BSD-style
 // license that can be found in the LICENSE file.
 
-// +build darwin dragonfly freebsd linux netbsd openbsd
+// +build darwin dragonfly freebsd linux netbsd openbsd solaris
 
 #include <pthread.h>
 #include "_cgo_export.h"
