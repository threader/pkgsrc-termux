$NetBSD: patch-src-post-mosaico-switch.c,v 1.2 2014/05/18 15:38:18 wiz Exp $

https://bugs.xine-project.org/show_bug.cgi?id=524

--- src/post/mosaico/switch.c.orig	2011-08-30 13:13:40.000000000 +0000
+++ src/post/mosaico/switch.c
@@ -51,7 +51,8 @@ typedef struct switch_parameter_s {
 
 
 START_PARAM_DESCR(switch_parameter_t)
-PARAM_ITEM(POST_PARAM_TYPE_INT, select, NULL, 1, INT_MAX, 1,
+PARAM_ITEM(switch_parameter_t, 
+  POST_PARAM_TYPE_INT, select, NULL, 1, INT_MAX, 1,
   "the input source which will be passed through to the output")
 END_PARAM_DESCR(switch_param_descr)
 
