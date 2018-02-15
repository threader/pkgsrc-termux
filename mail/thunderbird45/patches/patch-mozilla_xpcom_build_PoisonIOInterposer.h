$NetBSD: patch-mozilla_xpcom_build_PoisonIOInterposer.h,v 1.1 2017/04/27 13:38:19 ryoon Exp $

--- mozilla/xpcom/build/PoisonIOInterposer.h.orig	2016-04-07 21:33:35.000000000 +0000
+++ mozilla/xpcom/build/PoisonIOInterposer.h
@@ -36,7 +36,7 @@ void MozillaUnRegisterDebugFILE(FILE* aF
 
 MOZ_END_EXTERN_C
 
-#if defined(XP_WIN) || defined(XP_MACOSX)
+#if defined(XP_WIN) || defined(XP_DARWIN)
 
 #ifdef __cplusplus
 namespace mozilla {
@@ -54,7 +54,7 @@ bool IsDebugFile(intptr_t aFileID);
  */
 void InitPoisonIOInterposer();
 
-#ifdef XP_MACOSX
+#ifdef XP_DARWIN
 /**
  * Check that writes are dirty before reporting I/O (Mac OS X only)
  * This is necessary for late-write checks on Mac OS X, but reading the buffer
@@ -62,7 +62,7 @@ void InitPoisonIOInterposer();
  * to do this for everything else that uses
  */
 void OnlyReportDirtyWrites();
-#endif /* XP_MACOSX */
+#endif /* XP_DARWIN */
 
 /**
  * Clear IO poisoning, this is only safe to do on the main-thread when no other
@@ -73,19 +73,19 @@ void ClearPoisonIOInterposer();
 } // namespace mozilla
 #endif /* __cplusplus */
 
-#else /* XP_WIN || XP_MACOSX */
+#else /* XP_WIN || XP_DARWIN */
 
 #ifdef __cplusplus
 namespace mozilla {
 inline bool IsDebugFile(intptr_t aFileID) { return true; }
 inline void InitPoisonIOInterposer() {}
 inline void ClearPoisonIOInterposer() {}
-#ifdef XP_MACOSX
+#ifdef XP_DARWIN
 inline void OnlyReportDirtyWrites() {}
-#endif /* XP_MACOSX */
+#endif /* XP_DARWIN */
 } // namespace mozilla
 #endif /* __cplusplus */
 
-#endif /* XP_WIN || XP_MACOSX */
+#endif /* XP_WIN || XP_DARWIN */
 
 #endif // mozilla_PoisonIOInterposer_h
