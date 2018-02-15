$NetBSD: patch-src_lispbibl.d,v 1.2 2015/12/29 23:34:45 dholland Exp $

Support clang on x86_64.

--- src/lispbibl.d.orig	2013-06-17 14:15:17.000000000 +0000
+++ src/lispbibl.d
@@ -9090,6 +9090,15 @@ All other long words on the LISP-Stack a
   #define setSP(adresse)  \
     ({ __asm__ __volatile__ ("movel %0,"REGISTER_PREFIX"sp" : : "g" ((aint)(adresse)) : "sp" ); })
   #define FAST_SP
+#elif defined(__clang__) && defined(__x86_64__)
+  /* Access to a register-"variable" %rsp */
+  #define SP()  \
+    ({var aint __SP;                                           \
+      __asm__ __volatile__ ("movq %%rsp,%0" : "=g" (__SP) : ); \
+      __SP;                                                    \
+     })
+  #define setSP(adresse)  \
+      ({ __asm__ __volatile__ ("movq %0,%%rsp" : : "g" ((aint)(adresse)) : "sp" ); })
 #elif (defined(GNU) || defined(INTEL)) && defined(I80386) && !defined(NO_ASM)
   /* Access to a register-"variable" %esp */
   #define SP()  \
