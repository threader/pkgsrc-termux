$NetBSD: patch-js_src_jit_arm_Architecture-arm.cpp,v 1.1 2017/04/27 01:55:57 ryoon Exp $

* Support NetBSD/earm

--- js/src/jit/arm/Architecture-arm.cpp.orig	2015-08-24 21:53:12.000000000 +0000
+++ js/src/jit/arm/Architecture-arm.cpp
@@ -16,7 +16,7 @@
 #include "jit/arm/Assembler-arm.h"
 #include "jit/RegisterSets.h"
 
-#if !defined(__linux__) || defined(ANDROID) || defined(JS_SIMULATOR_ARM)
+#if !defined(__linux__) || defined(ANDROID) || defined(JS_SIMULATOR_ARM) || defined(__NetBSD__)
 // The Android NDK and B2G do not include the hwcap.h kernel header, and it is not
 // defined when building the simulator, so inline the header defines we need.
 # define HWCAP_VFP        (1 << 6)
