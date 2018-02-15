$NetBSD: patch-crypto__bio__bio_test.cc,v 1.1.1.1 2015/12/31 02:57:35 agc Exp $

NetBSD portability patches

--- crypto/bio/bio_test.cc.orig	2015-12-30 15:55:50.000000000 -0800
+++ crypto/bio/bio_test.cc	2015-12-30 18:06:05.000000000 -0800
@@ -13,7 +13,9 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. */
 
 #if !defined(_POSIX_C_SOURCE)
+#  if !defined(__NetBSD__)
 #define _POSIX_C_SOURCE 201410L
+#  endif
 #endif
 
 #include <openssl/base.h>
