$NetBSD: patch-lib_param_loadparm.h,v 1.2 2017/04/08 08:56:27 ryoon Exp $

* Fix NetBSD build.

--- lib/param/loadparm.h.orig	2017-01-11 07:55:14.000000000 +0000
+++ lib/param/loadparm.h
@@ -31,6 +31,9 @@
 #define _LOADPARM_H
 
 #include <talloc.h>
+#if defined(__NetBSD__)
+#include <sys/time.h>
+#endif
 
 struct parmlist_entry {
 	struct parmlist_entry *prev, *next;
