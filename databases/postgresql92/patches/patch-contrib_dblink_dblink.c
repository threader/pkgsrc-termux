$NetBSD: patch-contrib_dblink_dblink.c,v 1.2 2013/04/04 21:08:36 adam Exp $

--- contrib/dblink/dblink.c.orig	2013-04-01 18:20:36.000000000 +0000
+++ contrib/dblink/dblink.c
@@ -46,7 +46,7 @@
 #include "parser/scansup.h"
 #include "utils/acl.h"
 #include "utils/builtins.h"
-#include "utils/fmgroids.h"
+#include "postgresql/server/utils/fmgroids.h"
 #include "utils/guc.h"
 #include "utils/lsyscache.h"
 #include "utils/memutils.h"
