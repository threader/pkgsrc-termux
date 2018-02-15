$NetBSD: patch-mod_encoding.c,v 1.1 2016/08/30 12:34:40 manu Exp $

Patches for Apache 2 from https://github.com/aosm/apache_mod_encoding2

--- mod_encoding.c.orig
+++ mod_encoding.c
@@ -4,4 +4,68 @@
  *
  */
+/*
+ * mod_encoding core module test implementation for Apache2.
+ *  by Kunio Miyamoto (wakatono@todo.gr.jp)
+ * Original security fix port 2002/06/06
+ *  by Kunio Miyamoto (wakatono@todo.gr.jp)
+ * Port new function of 20020611a
+ *  by Kunio Miyamoto (wakatono@todo.gr.jp)
+ * Port new function of 20020611a
+ *  by Kunio Miyamoto (wakatono@todo.gr.jp)
+ * Add COPYING statement for redistribute only this code.
+ *  by Kunio Miyamoto (wakatono@todo.gr.jp)
+ */
+/*
+
+
+Copyright (c) 2000-2004
+Internet Initiative Japan Inc. and Kunio Miyamoto All rights reserved.
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions
+are met:
+
+1. Redistributions of source code must retain the above copyright
+   notice, this list of conditions and the following disclaimer. 
+
+2. Redistributions in binary form must reproduce the above copyright
+   notice, this list of conditions and the following disclaimer in
+   the documentation and/or other materials provided with the
+   distribution.
+
+3. All advertising materials mentioning features or use of this
+   software must display the following acknowledgment:
+
+     This product includes software developed by Internet
+     Initiative Japan Inc. and Kunio Miyamoto for use in the 
+     mod_encoding module for Apache2.
+
+4. Products derived from this software may not be called "mod_encoding"
+   nor may "mod_encoding" appear in their names without prior written
+   permission of Internet Initiative Japan Inc. For written permission,
+   please contact tai@iij.ad.jp (Taisuke Yamada).
+
+5. Redistributions of any form whatsoever must retain the following
+   acknowledgment:
+
+     This product includes software developed by Internet
+     Initiative Japan Inc. and Kunio Miyamoto for use in the
+     mod_encoding module for Apache2 (http://www.apache.org/).
+
+THIS SOFTWARE IS PROVIDED BY INTERNET INITIATIVE JAPAN INC. AND KUNIO
+MIYAMOTO ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
+BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
+FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+INTERNET INITIATIVE JAPAN INC., KUNIO MIYAMOTO OR ITS CONTRIBUTORS
+BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
+OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+BUSINESS INTERRUPTION)
+HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+OF THE POSSIBILITY OF SUCH DAMAGE.
+
+*/
 
 #include <httpd.h>
@@ -21,26 +88,21 @@
  *
  * Note UTF-8 is the implicit default and will be tried first,
  * regardless of user configuration.
  */
+#define DEBUG 0
 
 #ifndef MOD_ENCODING_DEBUG
-#ifdef DEBUG
+#if DEBUG
 #define MOD_ENCODING_DEBUG 1
 #else
 #define MOD_ENCODING_DEBUG 0
 #endif
 #endif
 
 #define DBG(expr) if (MOD_ENCODING_DEBUG) { expr; }
 
-#ifdef __GNUC__
-#define LOG(level, server, args...) \
-        ap_log_error(APLOG_MARK, APLOG_NOERRNO|level, server, ##args)
-#else
-#define LOG(level, server, ...) \
-        ap_log_error(APLOG_MARK, APLOG_NOERRNO|level, server, __VA_ARGS__)
-#endif
+/* FIXME: remove gcc-dependency */
 
 #define ENABLE_FLAG_UNSET 0
 #define ENABLE_FLAG_OFF   1
 #define ENABLE_FLAG_ON    2
@@ -54,15 +116,15 @@
  */
 typedef struct {
   int           enable_function;  /* flag to enable this module */
   char         *server_encoding;  /* server-side filesystem encoding */
-  array_header *client_encoding;  /* useragent-to-encoding-list sets */
-  array_header *default_encoding; /* useragent-to-encoding-list sets */
+  apr_array_header_t *client_encoding;  /* useragent-to-encoding-list sets */
+  apr_array_header_t *default_encoding; /* useragent-to-encoding-list sets */
 
-  int           strip_msaccount;  /* normalize wierd WinXP username */
+ int strip_msaccount;                   /* normalize wierd WinXP username */
 } encoding_config;
 
-module MODULE_VAR_EXPORT encoding_module;
+module AP_MODULE_DECLARE_DATA encoding_module;
 
 /***************************************************************************
  * utility methods
  ***************************************************************************/
@@ -82,24 +144,21 @@
   char   *outbuf, *marker;
   size_t  outlen;
 
   if (srclen == 0) {
-    LOG(APLOG_DEBUG, r->server, "iconv_string: skipping zero-length input");
     return srcbuf;
   }
 
   /* Allocate space for conversion. Note max bloat factor is 4 of UCS-4 */
-  marker = outbuf = (char *)ap_palloc(r->pool, outlen = srclen * 4 + 1);
+  marker = outbuf = (char *)apr_palloc(r->pool, outlen = srclen * 4 + 1);
 
   if (outbuf == NULL) {
-    LOG(APLOG_WARNING, r->server, "iconv_string: no more memory");
     return NULL;
   }
 
   /* Convert every character within input string. */
   while (srclen > 0) {
     if (iconv(cd, &srcbuf, &srclen, &outbuf, &outlen) == (size_t)(-1)) {
-      LOG(APLOG_DEBUG, r->server, "iconv_string: conversion error");
       return NULL;
     }
   }
 
@@ -139,13 +198,13 @@
   ap_getparents(r->uri); /* normalize given path for security */
 
   /* Normalize encoding in HTTP request header(s) */
   for (i = 0 ; keys[i] ; i++) {
-    if ((buff = (char *)ap_table_get(r->headers_in, keys[i])) != NULL) {
+    if ((buff = (char *)apr_table_get(r->headers_in, keys[i])) != NULL) {
       ap_unescape_url(buff);
       if ((buff = iconv_string(r, cd, buff, strlen(buff))) == NULL)
 	return -1;
-      ap_table_set(r->headers_in, keys[i], buff);
+      apr_table_set(r->headers_in, keys[i], buff);
     }
   }
 
   return 0;
@@ -158,45 +217,39 @@
  * @param r      Apache request object structure
  * @param encmap Table of UA-to-encoding(s)
  * @param lookup Name of the useragent to look for
  */
-static array_header *
+static apr_array_header_t *
 get_client_encoding(request_rec *r,
-		    array_header *encmap, const char *lookup) {
+		    apr_array_header_t *encmap, const char *lookup) {
   void         **list = (void **)encmap->elts;
-  array_header  *encs = ap_make_array(r->pool, 1, sizeof(char *));
+  apr_array_header_t  *encs = apr_array_make(r->pool, 1, sizeof(char *));
 
   int i;
 
-  LOG(APLOG_DEBUG, r->server, "get_client_encoding: entered");
 
   /* push UTF-8 as the first candidate of expected encoding */
-  *((char **)ap_push_array(encs)) = ap_pstrdup(r->pool, "UTF-8");
+  *((char **)apr_array_push(encs)) = apr_pstrdup(r->pool, "UTF-8");
 
   if (! lookup)
     return encs;
 
-  LOG(APLOG_DEBUG, r->server, "get_client_encoding: lookup == %s", lookup);
 
   for (i = 0 ; i < encmap->nelts ; i += 2) {
-    if (ap_regexec((regex_t *)list[i], lookup, 0, NULL, 0) == 0) {
-      LOG(APLOG_DEBUG, r->server, "get_client_encoding: entry found");
-      ap_array_cat(encs, (array_header *)list[i + 1]);
+    if (ap_regexec((ap_regex_t *)list[i], lookup, 0, NULL, 0) == 0) {
+      apr_array_cat(encs, (apr_array_header_t *)list[i + 1]);
       return encs;
     }
   }
 
-  LOG(APLOG_DEBUG, r->server, "get_client_encoding: entry not found");
   return encs;
 }
 
 /**
  * Handler for "EncodingEngine" directive.
  */
 static const char *
 set_encoding_engine(cmd_parms *cmd, encoding_config *conf, int flag) {
-  LOG(APLOG_DEBUG, cmd->server, "set_encoding_engine: entered");
-  LOG(APLOG_DEBUG, cmd->server, "set_encoding_engine: flag == %d", flag);
 
   if (! cmd->path) {
     conf = ap_get_module_config(cmd->server->module_config, &encoding_module);
   }
@@ -209,15 +262,13 @@
  * Handler for "SetServerEncoding" directive.
  */
 static const char *
 set_server_encoding(cmd_parms *cmd, encoding_config *conf, char *arg) {
-  LOG(APLOG_DEBUG, cmd->server, "set_server_encoding: entered");
-  LOG(APLOG_DEBUG, cmd->server, "set_server_encoding: arg == %s", arg);
 
   if (! cmd->path) {
     conf = ap_get_module_config(cmd->server->module_config, &encoding_module);
   }
-  conf->server_encoding = ap_pstrdup(cmd->pool, arg);
+  conf->server_encoding = apr_pstrdup(cmd->pool, arg);
   
   return NULL;
 }
 
@@ -228,33 +279,29 @@
  * encoding(s) from that useragent.
  */
 static const char *
 add_client_encoding(cmd_parms *cmd, encoding_config *conf, char *args) {
-  array_header    *encs;
+  apr_array_header_t    *encs;
   char            *arg;
 
-  LOG(APLOG_DEBUG, cmd->server, "add_client_encoding: entered");
-  LOG(APLOG_DEBUG, cmd->server, "add_client_encoding: args == %s", args);
 
   if (! cmd->path) {
     conf = ap_get_module_config(cmd->server->module_config, &encoding_module);
   }
 
-  encs = ap_make_array(cmd->pool, 1, sizeof(void *));
+  encs = apr_array_make(cmd->pool, 1, sizeof(void *));
 
   /* register useragent with UserAgent: pattern */
   if (*args && (arg = ap_getword_conf_nc(cmd->pool, &args))) {
-    LOG(APLOG_DEBUG, cmd->server, "add_client_encoding: agent: %s", arg);
-    *(void **)ap_push_array(conf->client_encoding) =
-      ap_pregcomp(cmd->pool, arg, REG_EXTENDED|REG_ICASE|REG_NOSUB);
+    *(void **)apr_array_push(conf->client_encoding) =
+      ap_pregcomp(cmd->pool, arg, AP_REG_EXTENDED|AP_REG_ICASE|AP_REG_NOSUB);
   }
 
   /* register list of possible encodings from above useragent */
   while (*args && (arg = ap_getword_conf_nc(cmd->pool, &args))) {
-    LOG(APLOG_DEBUG, cmd->server, "add_client_encoding: encname: %s", arg);
-    *(void **)ap_push_array(encs) = ap_pstrdup(cmd->pool, arg);
+    *(void **)apr_array_push(encs) = apr_pstrdup(cmd->pool, arg);
   }
-  *(void **)ap_push_array(conf->client_encoding) = encs;
+  *(void **)apr_array_push(conf->client_encoding) = encs;
 
   return NULL;
 }
 
@@ -266,22 +313,19 @@
 static const char *
 default_client_encoding(cmd_parms *cmd, encoding_config *conf, char *args) {
   char *arg;
 
-  LOG(APLOG_DEBUG, cmd->server, "default_client_encoding: entered");
-  LOG(APLOG_DEBUG, cmd->server, "default_client_encoding: args == %s", args);
 
   if (! cmd->path) {
     conf = ap_get_module_config(cmd->server->module_config, &encoding_module);
   }
 
-  conf->default_encoding = ap_make_array(cmd->pool, 1, sizeof(char *));
+  conf->default_encoding = apr_array_make(cmd->pool, 1, sizeof(char *));
 
   /* register list of possible encodings as a default */
   while (*args && (arg = ap_getword_conf_nc(cmd->pool, &args))) {
-    LOG(APLOG_DEBUG, cmd->server, "default_client_encoding: encname: %s", arg);
-    *(void **)ap_push_array(conf->default_encoding)
-      = ap_pstrdup(cmd->pool, arg);
+    *(void **)apr_array_push(conf->default_encoding)
+      = apr_pstrdup(cmd->pool, arg);
   }
 
   return NULL;
 }
@@ -293,10 +337,8 @@
  *       So where should this go?
  */
 static const char *
 set_normalize_username(cmd_parms *cmd, encoding_config *conf, int flag) {
-  LOG(APLOG_DEBUG, cmd->server, "set_normalize_username: entered");
-  LOG(APLOG_DEBUG, cmd->server, "set_normalize_username: flag == %d", flag);
 
   if (! cmd->path) {
     conf = ap_get_module_config(cmd->server->module_config, &encoding_module);
   }
@@ -342,17 +384,17 @@
 /**
  * Setup server-level module internal data strcuture.
  */
 static void *
-server_setup(pool *p, server_rec *s) {
+server_setup(apr_pool_t *p, server_rec *s) {
   encoding_config *conf;
 
   DBG(fprintf(stderr, "server_setup: entered\n"));
 
-  conf = (encoding_config *)ap_pcalloc(p, sizeof(encoding_config));
+  conf = (encoding_config *)apr_pcalloc(p, sizeof(encoding_config));
   conf->enable_function  = ENABLE_FLAG_UNSET;
   conf->server_encoding  = NULL;
-  conf->client_encoding  = ap_make_array(p, 2, sizeof(void *));
+  conf->client_encoding  = apr_array_make(p, 2, sizeof(void *));
   conf->default_encoding = NULL;
   conf->strip_msaccount  = STRIP_FLAG_UNSET;
 
   return conf;
@@ -361,25 +403,25 @@
 /**
  * Setup folder-level module internal data strcuture.
  */
 static void *
-folder_setup(pool *p, char *dir) {
+folder_setup(apr_pool_t *p, char *dir) {
   DBG(fprintf(stderr, "folder_setup: entered\n"));
   return server_setup(p, NULL);
 }
 
 /**
  * Merge configuration.
  */
 static void *
-config_merge(pool *p, void *base, void *override) {
+config_merge(apr_pool_t *p, void *base, void *override) {
   encoding_config *parent = base;
   encoding_config *child  = override;
   encoding_config *merge;
 
   DBG(fprintf(stderr, "config_merge: entered\n"));
 
-  merge = (encoding_config *)ap_pcalloc(p, sizeof(encoding_config));
+  merge = (encoding_config *)apr_pcalloc(p, sizeof(encoding_config));
 
   if (child->enable_function != ENABLE_FLAG_UNSET)
     merge->enable_function =  child->enable_function;
   else
@@ -387,15 +429,16 @@
 
   DBG(fprintf(stderr,
 	      "merged: enable_function == %d\n", merge->enable_function));
 
+
   if (child->strip_msaccount != STRIP_FLAG_UNSET)
     merge->strip_msaccount =  child->strip_msaccount;
   else
     merge->strip_msaccount = parent->strip_msaccount;
 
   DBG(fprintf(stderr,
-	      "merged: strip_msaccount == %d\n", merge->strip_msaccount));
+            "merged: strip_msaccount == %d\n", merge->strip_msaccount));
 
   if (child->server_encoding)
     merge->server_encoding =  child->server_encoding;
   else
@@ -409,9 +452,9 @@
   else
     merge->default_encoding = parent->default_encoding;
 
   merge->client_encoding =
-    ap_append_arrays(p, child->client_encoding, parent->client_encoding);
+    apr_array_append(p, child->client_encoding, parent->client_encoding);
 
   return merge;
 }
 
@@ -423,61 +466,57 @@
  * server-side expected encoding.
  */
 static int
 mod_enc_convert(request_rec *r) {
-  encoding_config *conf, *dconf, *sconf;
+  encoding_config  *conf, *dconf, *sconf;
 
   const char      *oenc; /* server-side encoding */
-  array_header    *ienc; /* list of possible encodings */
+  apr_array_header_t    *ienc; /* list of possible encodings */
   void           **list; /* same as above (for iteration) */
 
   iconv_t cd;            /* conversion descriptor */
 
   int i;
 
-  LOG(APLOG_DEBUG, r->server, "mod_enc_convert: entered");
 
   sconf = ap_get_module_config(r->server->module_config, &encoding_module);
   dconf = ap_get_module_config(r->per_dir_config, &encoding_module);
    conf = config_merge(r->pool, sconf, dconf);
 
+ DBG(fprintf(stderr, "mod_enc_convert: entered\n"));
+
   if (conf->enable_function != ENABLE_FLAG_ON) {
     return DECLINED;
   }
 
   oenc = conf->server_encoding ? conf->server_encoding : "UTF-8";
   ienc = get_client_encoding(r, conf->client_encoding,
-			     ap_table_get(r->headers_in, "User-Agent"));
+			     apr_table_get(r->headers_in, "User-Agent"));
 
   if (conf->default_encoding)
-    ap_array_cat(ienc, conf->default_encoding);
+    apr_array_cat(ienc, conf->default_encoding);
 
   list = (void **)ienc->elts;
 
-  LOG(APLOG_DEBUG, r->server, "mod_enc_convert: oenc == %s", oenc);
 
   /* try specified encodings in order */
   for (i = 0 ; i < ienc->nelts ; i++) {
-    LOG(APLOG_DEBUG,
-	r->server, "mod_enc_convert: ienc <> %s", (char *)list[i]);
-
+    DBG(fprintf(stderr, "mod_enc_convert: trying\n"));
     /* pick appropriate converter module */
     if ((cd = iconv_open(oenc, list[i])) == (iconv_t)(-1))
       continue;
 
     /* conversion tryout */
     if (iconv_header(r, cd) == 0) {
-      LOG(APLOG_DEBUG,
-	  r->server, "mod_enc_convert: ienc == %s", (char *)list[i]);
       iconv_close(cd);
+	DBG(fprintf(stderr, "mod_enc_convert: converted\n"));
       return DECLINED;
     }
 
     /* don't fail, but just continue on until list ends */
     iconv_close(cd);
   }
 
-  LOG(APLOG_WARNING, r->server, "mod_enc_convert: no conversion done");
 
   return DECLINED;
 }
 
@@ -494,10 +533,8 @@
   const char *pass;
   char       *user;
   char       *buff;
 
-  LOG(APLOG_DEBUG, r->server, "mod_enc_parse: entered");
-
   sconf = ap_get_module_config(r->server->module_config, &encoding_module);
   dconf = ap_get_module_config(r->per_dir_config, &encoding_module);
    conf = config_merge(r->pool, sconf, dconf);
 
@@ -512,46 +549,43 @@
     if (ap_get_basic_auth_pw(r, &pass) != OK)
       return DECLINED;
 
     /* Is this username broken? */
-    if ((user = index(r->connection->user, '\\')) == NULL)
+    if ((user = index(r->user, '\\')) == NULL)
       return DECLINED;
 
     /* Re-generate authorization header */
     if (*(user + 1)) {
       buff = ap_pbase64encode(r->pool,
-			      ap_psprintf(r->pool, "%s:%s", user + 1, pass));
-      ap_table_set(r->headers_in, "Authorization",
-		   ap_pstrcat(r->pool, "Basic ", buff, NULL));
+                              apr_psprintf(r->pool, "%s:%s", user + 1, pass));
+      apr_table_set(r->headers_in, "Authorization",
+                   apr_pstrcat(r->pool, "Basic ", buff, NULL));
 
       ap_get_basic_auth_pw(r, &pass); /* update */
     }
   }
 
   return DECLINED;
 }
 
+static void register_hooks(apr_pool_t *p)
+{
+	/* filename-to-URI translation */
+/*	ap_hook_translate_name(mod_enc_convert,NULL,NULL,APR_HOOK_FIRST); */
+	ap_hook_post_read_request(mod_enc_convert,NULL,NULL,APR_HOOK_FIRST);
+	ap_hook_header_parser(mod_enc_parse,NULL,NULL,APR_HOOK_FIRST); 
+}
+
 /***************************************************************************
  * exported module structure
  ***************************************************************************/
 
-module MODULE_VAR_EXPORT encoding_module = {
-  STANDARD_MODULE_STUFF,
-  NULL,             /* initializer */
-  folder_setup,     /* dir config */
-  config_merge,     /* dir config merger */
-  server_setup,     /* server config */
-  config_merge,     /* server config merger */
-  mod_enc_commands, /* command table */
-  NULL,             /* handlers */
-  NULL,             /* filename translation */
-  NULL,             /* check_user_id */
-  NULL,             /* check auth */
-  NULL,             /* check access */
-  NULL,             /* type_checker */
-  NULL,             /* fixups */
-  NULL,             /* logger */
-  mod_enc_parse,    /* header parser */
-  NULL,             /* child_init */
-  NULL,             /* child_exit */
-  mod_enc_convert,  /* post read-request */
+module AP_MODULE_DECLARE_DATA encoding_module = {
+  STANDARD20_MODULE_STUFF,
+  folder_setup,     /* create per-directory config structure */
+  config_merge,     /* merge per-directory(?) config str */
+  server_setup,     /* create per-server config structure */
+  config_merge,     /* merge per-server config ...*/
+  mod_enc_commands, /* command handlers */
+  register_hooks
 };
+
