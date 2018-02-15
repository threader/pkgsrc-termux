$NetBSD: patch-lib_hostcheck.c,v 1.4 2015/08/08 02:44:16 spz Exp $

Add missing header for DragonflyBSD.
PR 48691 by David Shao.

--- lib/hostcheck.c.orig	2015-06-03 07:38:20.000000000 +0000
+++ lib/hostcheck.c
@@ -34,6 +34,13 @@
 #include "inet_pton.h"
 
 #include "curl_memory.h"
+
+#ifdef ENABLE_IPV6
+#ifdef HAVE_NETINET_IN_H
+#include <netinet/in.h>
+#endif
+#endif
+
 /* The last #include file should be: */
 #include "memdebug.h"
 
