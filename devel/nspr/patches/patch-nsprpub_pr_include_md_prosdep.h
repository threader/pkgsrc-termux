$NetBSD: patch-nsprpub_pr_include_md_prosdep.h,v 1.3 2013/07/20 08:57:20 ryoon Exp $

--- nsprpub/pr/include/md/prosdep.h.orig	2012-03-06 13:13:55.000000000 +0000
+++ nspr/pr/include/md/prosdep.h
@@ -34,7 +34,7 @@ PR_BEGIN_EXTERN_C
 #if defined(AIX)
 #include "md/_aix.h"
 
-#elif defined(FREEBSD)
+#elif defined(FREEBSD) || defined(__DragonFly__)
 #include "md/_freebsd.h"
 
 #elif defined(NETBSD)
