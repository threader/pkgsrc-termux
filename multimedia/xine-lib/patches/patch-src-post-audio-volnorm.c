$NetBSD: patch-src-post-audio-volnorm.c,v 1.2 2014/05/18 15:38:18 wiz Exp $

https://bugs.xine-project.org/show_bug.cgi?id=524

--- src/post/audio/volnorm.c.orig	2011-08-30 13:13:33.000000000 +0000
+++ src/post/audio/volnorm.c
@@ -90,7 +90,8 @@ typedef struct volnorm_parameters_s {
  * description of params struct
  */
 START_PARAM_DESCR( volnorm_parameters_t )
-PARAM_ITEM( POST_PARAM_TYPE_INT, method, NULL, 0, 2, 0, "Normalization method" )
+PARAM_ITEM( volnorm_parameters_t,
+	    POST_PARAM_TYPE_INT, method, NULL, 0, 2, 0, "Normalization method" )
 END_PARAM_DESCR( param_descr )
 
 struct post_plugin_volnorm_s {
