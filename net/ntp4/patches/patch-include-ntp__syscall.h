$NetBSD: patch-include-ntp__syscall.h,v 1.1 2015/10/29 11:23:47 christos Exp $

--- include/ntp_syscall.h.orig	2011-03-31 10:03:53.000000000 +0000
+++ include/ntp_syscall.h
@@ -10,6 +10,14 @@
 # include <sys/timex.h>
 #endif
 
+#if defined(ADJ_NANO) && !defined(MOD_NANO)
+#define MOD_NANO ADJ_NANO
+#endif
+
+#if defined(ADJ_TAI) && !defined(MOD_TAI)
+#define MOD_TAI ADJ_TAI
+#endif
+
 #ifndef NTP_SYSCALLS_LIBC
 # ifdef NTP_SYSCALLS_STD
 #  define ntp_adjtime(t)	syscall(SYS_ntp_adjtime, (t))
