$NetBSD: patch-boehm-gc_pthread__support.c,v 1.1 2014/05/31 13:06:25 ryoon Exp $

--- boehm-gc/pthread_support.c.orig	2012-11-04 22:56:02.000000000 +0000
+++ boehm-gc/pthread_support.c
@@ -118,6 +118,10 @@
 # include <fcntl.h>
 # include <signal.h>
 
+#if defined(GC_OPENBSD_THREADS)
+# include <pthread_np.h>
+#endif
+
 #if defined(GC_DARWIN_THREADS)
 # include "private/darwin_semaphore.h"
 #else
@@ -884,7 +888,8 @@ void GC_thr_init()
 	  GC_nprocs = pthread_num_processors_np();
 #       endif
 #	if defined(GC_OSF1_THREADS) || defined(GC_AIX_THREADS) \
-	   || defined(GC_SOLARIS_PTHREADS) || defined(GC_GNU_THREADS)
+	   || defined(GC_SOLARIS_PTHREADS) || defined(GC_GNU_THREADS) \
+	   || defined(GC_OPENBSD_THREADS)
 	  GC_nprocs = sysconf(_SC_NPROCESSORS_ONLN);
 	  if (GC_nprocs <= 0) GC_nprocs = 1;
 #	endif
@@ -970,7 +975,6 @@ void GC_init_parallel()
 int WRAP_FUNC(pthread_sigmask)(int how, const sigset_t *set, sigset_t *oset)
 {
     sigset_t fudged_set;
-    
     if (set != NULL && (how == SIG_BLOCK || how == SIG_SETMASK)) {
         fudged_set = *set;
         sigdelset(&fudged_set, SIG_SUSPEND);
@@ -1156,6 +1160,10 @@ GC_PTR GC_get_thread_stack_base()
       return stack_addr;
 #   endif
 
+#  elif defined(GC_OPENBSD_THREADS)
+     stack_t stack;
+     pthread_stackseg_np(pthread_self(), &stack);
+     return stack.ss_sp;
 # else
 #   ifdef DEBUG_THREADS
 	GC_printf0("Can not determine stack base for attached thread");
