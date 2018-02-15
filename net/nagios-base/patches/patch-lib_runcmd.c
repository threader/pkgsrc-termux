$NetBSD: patch-lib_runcmd.c,v 1.1 2015/04/03 17:06:08 rodent Exp $

Include config.h generated during configure.
setenv(3) was tested there. No need to check for it here.
Can't assign a value to a constant. Ensure we don't do that.

--- lib/runcmd.c.orig	2014-08-12 15:00:01.000000000 +0000
+++ lib/runcmd.c
@@ -15,6 +15,7 @@
 #define NAGIOSPLUG_API_C 1
 
 /* includes **/
+#include "../include/config.h"
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
@@ -35,11 +36,6 @@
 # define WIFEXITED(stat_val) (((stat_val) & 255) == 0)
 #endif
 
-/* Determine whether we have setenv()/unsetenv() (see setenv(3) on Linux) */
-#if _BSD_SOURCE || _POSIX_C_SOURCE >= 200112L || _XOPEN_SOURCE >= 600
-# define HAVE_SETENV
-#endif
-
 /*
  * This variable must be global, since there's no way the caller
  * can forcibly slay a dead or ungainly running program otherwise.
@@ -304,13 +300,13 @@ int runcmd_cmd2strv(const char *str, int
  * through this API and thus achieve async-safeness throughout the API. */
 void runcmd_init(void)
 {
-#if defined(RLIMIT_NOFILE)
+#if defined(RLIMIT_NOFILE) && !defined(maxfd)
 	if (!maxfd) {
 		struct rlimit rlim;
 		getrlimit(RLIMIT_NOFILE, &rlim);
 		maxfd = rlim.rlim_cur;
 	}
-#elif !defined(OPEN_MAX) && !defined(IOV_MAX) && defined(_SC_OPEN_MAX)
+#elif !defined(OPEN_MAX) && !defined(IOV_MAX) && defined(_SC_OPEN_MAX) && !defined(maxfd)
 	if(!maxfd) {
 		if((maxfd = sysconf(_SC_OPEN_MAX)) < 0) {
 			/* possibly log or emit a warning here, since there's no
