$NetBSD: patch-cfparse.y,v 1.2 2015/02/10 19:28:29 joerg Exp $

Fix build with gcc-4.5.

--- cfparse.y.orig	2003-10-21 08:15:45.000000000 +0000
+++ cfparse.y
@@ -41,6 +41,7 @@
 #include <string.h>
 #include <syslog.h>
 #include <stdio.h>
+#include <stdlib.h>
 
 #include "defs.h"
 #include "vif.h"
@@ -1232,7 +1232,7 @@ cf_post_config()
 
 /* initialize all the temporary variables */
 void
-cf_init(s, d)
+cf_init(int s, int d)
 {
 	struct uvif *v;
 	mifi_t vifi;
