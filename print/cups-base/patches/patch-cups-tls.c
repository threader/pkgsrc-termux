$NetBSD: patch-cups-tls.c,v 1.1 2017/11/12 14:10:15 khorben Exp $

Add missing stub.

--- cups/tls.c.orig	2014-08-29 15:19:40.000000000 +0000
+++ cups/tls.c
@@ -50,6 +50,13 @@
 #    include "tls-sspi.c"
 #  endif /* HAVE_GNUTLS */
 #else
+
+void                                    
+_httpTLSSetOptions(int options)         /* I - Options */
+{                                       
+	(void)options;
+}
+
 /* Stubs for when TLS is not supported/available */
 int
 httpCopyCredentials(http_t *http, cups_array_t **credentials)
