$NetBSD: patch-src_mongo_platform_random.cpp,v 1.3 2016/02/12 03:37:24 ryoon Exp $

Add NetBSD support.
--- src/mongo/platform/random.cpp.orig	2016-01-05 18:31:44.000000000 +0000
+++ src/mongo/platform/random.cpp
@@ -145,7 +145,7 @@ SecureRandom* SecureRandom::create() {
     return new WinSecureRandom();
 }
 
-#elif defined(__linux__) || defined(__sun) || defined(__APPLE__) || defined(__FreeBSD__)
+#elif defined(__linux__) || defined(__sun) || defined(__APPLE__) || defined(__FreeBSD__) || defined(__DragonFly__) || defined(__NetBSD__)
 
 class InputStreamSecureRandom : public SecureRandom {
 public:
