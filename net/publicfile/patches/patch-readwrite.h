$NetBSD: patch-readwrite.h,v 1.1 2013/05/23 14:57:32 joerg Exp $

--- readwrite.h.orig	1999-11-09 07:23:46.000000000 +0000
+++ readwrite.h
@@ -1,7 +1,9 @@
 #ifndef READWRITE_H
 #define READWRITE_H
 
-extern int read();
-extern int write();
+#include <sys/stat.h>
+#include <unistd.h>
+
+void out_puts(char *s);
 
 #endif
