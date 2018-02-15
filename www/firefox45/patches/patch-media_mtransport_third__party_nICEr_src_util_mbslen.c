$NetBSD: patch-media_mtransport_third__party_nICEr_src_util_mbslen.c,v 1.1 2016/04/27 16:36:50 ryoon Exp $

--- media/mtransport/third_party/nICEr/src/util/mbslen.c.orig	2016-02-25 23:02:01.000000000 +0000
+++ media/mtransport/third_party/nICEr/src/util/mbslen.c
@@ -47,6 +47,13 @@ OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 #define HAVE_XLOCALE
 #endif
 
+#ifdef __DragonFly__
+#include <osreldate.h>
+# if __DragonFly_version > 300502
+#  define HAVE_XLOCALE
+# endif
+#endif
+
 #ifdef HAVE_XLOCALE
 #include <xlocale.h>
 #endif /* HAVE_XLOCALE */
