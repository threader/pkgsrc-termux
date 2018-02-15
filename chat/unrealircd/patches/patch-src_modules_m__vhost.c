$NetBSD: patch-src_modules_m__vhost.c,v 1.2 2015/11/26 16:36:00 jperkin Exp $

Avoid unnecessary use of legacy sys/timeb.h, which doesn't exist on OpenBSD.

--- src/modules/m_vhost.c.orig	2015-11-09 16:16:59.000000000 +0000
+++ src/modules/m_vhost.c
@@ -32,8 +32,8 @@
 #include <string.h>
 #ifdef _WIN32
 #include <io.h>
-#endif
 #include <sys/timeb.h>
+#endif
 #include <fcntl.h>
 #include "h.h"
 #include "proto.h"
