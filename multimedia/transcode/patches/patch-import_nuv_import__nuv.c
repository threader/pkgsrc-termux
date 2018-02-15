$NetBSD: patch-import_nuv_import__nuv.c,v 1.1 2015/11/21 17:14:26 adam Exp $

Optionally build LZO support.

--- import/nuv/import_nuv.c.orig	2009-02-21 22:01:57.000000000 +0100
+++ import/nuv/import_nuv.c
@@ -15,7 +15,9 @@
 #include "aclib/ac.h"
 #include "nuppelvideo.h"
 #include "RTjpegN.h"
+#ifdef HAVE_LZO
 #include "libtc/tc_lzo.h"
+#endif
 
 #define MOD_NAME        "import_nuv.so"
 #define MOD_VERSION     "v0.9 (2006-06-03)"
@@ -467,6 +469,7 @@ static int nuv_decode_video(TCModuleInst
     in_framesize = inframe->video_size-5-sizeof(pd->cdata);
     out_framesize = pd->width*pd->height + (pd->width/2)*(pd->height/2)*2;
 
+#ifdef HAVE_LZO
     if (comptype == '2' || comptype == '3') {
         /* Undo LZO compression */
         uint8_t *decompressed_frame;
@@ -489,6 +492,7 @@ static int nuv_decode_video(TCModuleInst
         /* Convert 2 -> 1, 3 -> 0 */
         comptype ^= 3;
     }
+#endif
 
     switch (comptype) {
 
