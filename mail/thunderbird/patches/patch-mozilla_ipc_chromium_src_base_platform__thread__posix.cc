$NetBSD: patch-mozilla_ipc_chromium_src_base_platform__thread__posix.cc,v 1.2 2017/04/27 13:32:40 ryoon Exp $

--- mozilla/ipc/chromium/src/base/platform_thread_posix.cc.orig	2017-04-14 04:53:10.000000000 +0000
+++ mozilla/ipc/chromium/src/base/platform_thread_posix.cc
@@ -12,7 +12,9 @@
 #if defined(OS_MACOSX)
 #include <mach/mach.h>
 #elif defined(OS_NETBSD)
+_Pragma("GCC visibility push(default)")
 #include <lwp.h>
+_Pragma("GCC visibility pop")
 #elif defined(OS_LINUX)
 #include <sys/syscall.h>
 #include <sys/prctl.h>
@@ -107,7 +109,8 @@ void PlatformThread::SetName(const char*
   pthread_setname_np(pthread_self(), "%s", (void *)name);
 #elif defined(OS_BSD) && !defined(__GLIBC__)
   pthread_set_name_np(pthread_self(), name);
-#else
+#elif !defined(OS_SOLARIS)
+  prctl(PR_SET_NAME, reinterpret_cast<uintptr_t>(name), 0, 0, 0);
 #endif
 }
 #endif // !OS_MACOSX
