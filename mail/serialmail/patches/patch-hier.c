$NetBSD: patch-hier.c,v 1.3 2017/09/01 03:46:36 schmonz Exp $

Install docs following hier(7), don't install catpages, set reasonable
permissions, and avoid overwriting "setlock" from sysutils/daemontools.

--- hier.c.orig	1998-11-15 02:28:23.000000000 +0000
+++ hier.c
@@ -2,36 +2,27 @@
 
 void hier()
 {
-  h(auto_home,-1,-1,02755);
+  h(auto_home,-1,-1,0755);
 
-  d(auto_home,"bin",-1,-1,02755);
-  d(auto_home,"doc",-1,-1,02755);
-  d(auto_home,"doc/serialmail",-1,-1,02755);
-  d(auto_home,"man",-1,-1,02755);
-  d(auto_home,"man/man1",-1,-1,02755);
-  d(auto_home,"man/cat1",-1,-1,02755);
+  d(auto_home,"bin",-1,-1,0755);
+  d(auto_home,"share/doc",-1,-1,0755);
+  d(auto_home,"share/doc/serialmail",-1,-1,0755);
+  d(auto_home,"@PKGMANDIR@",-1,-1,0755);
+  d(auto_home,"@PKGMANDIR@/man1",-1,-1,0755);
 
   c(auto_home,"bin","serialqmtp",-1,-1,0755);
   c(auto_home,"bin","serialsmtp",-1,-1,0755);
   c(auto_home,"bin","maildirqmtp",-1,-1,0755);
   c(auto_home,"bin","maildirsmtp",-1,-1,0755);
   c(auto_home,"bin","maildirserial",-1,-1,0755);
-  c(auto_home,"bin","setlock",-1,-1,0755);
 
-  c(auto_home,"man/man1","serialqmtp.1",-1,-1,0644);
-  c(auto_home,"man/cat1","serialqmtp.0",-1,-1,0644);
-  c(auto_home,"man/man1","serialsmtp.1",-1,-1,0644);
-  c(auto_home,"man/cat1","serialsmtp.0",-1,-1,0644);
-  c(auto_home,"man/man1","maildirqmtp.1",-1,-1,0644);
-  c(auto_home,"man/cat1","maildirqmtp.0",-1,-1,0644);
-  c(auto_home,"man/man1","maildirsmtp.1",-1,-1,0644);
-  c(auto_home,"man/cat1","maildirsmtp.0",-1,-1,0644);
-  c(auto_home,"man/man1","maildirserial.1",-1,-1,0644);
-  c(auto_home,"man/cat1","maildirserial.0",-1,-1,0644);
-  c(auto_home,"man/man1","setlock.1",-1,-1,0644);
-  c(auto_home,"man/cat1","setlock.0",-1,-1,0644);
+  c(auto_home,"@PKGMANDIR@/man1","serialqmtp.1",-1,-1,0644);
+  c(auto_home,"@PKGMANDIR@/man1","serialsmtp.1",-1,-1,0644);
+  c(auto_home,"@PKGMANDIR@/man1","maildirqmtp.1",-1,-1,0644);
+  c(auto_home,"@PKGMANDIR@/man1","maildirsmtp.1",-1,-1,0644);
+  c(auto_home,"@PKGMANDIR@/man1","maildirserial.1",-1,-1,0644);
 
-  c(auto_home,"doc/serialmail","FROMISP",-1,-1,0644);
-  c(auto_home,"doc/serialmail","TOISP",-1,-1,0644);
-  c(auto_home,"doc/serialmail","AUTOTURN",-1,-1,0644);
+  c(auto_home,"share/doc/serialmail","FROMISP",-1,-1,0644);
+  c(auto_home,"share/doc/serialmail","TOISP",-1,-1,0644);
+  c(auto_home,"share/doc/serialmail","AUTOTURN",-1,-1,0644);
 }
