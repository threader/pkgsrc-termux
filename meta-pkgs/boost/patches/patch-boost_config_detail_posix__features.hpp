$NetBSD: patch-boost_config_detail_posix__features.hpp,v 1.1 2017/08/24 19:31:32 adam Exp $

Add OpenBSD conditionals, fix build under OpenBSD 5.5
OpenBSD has no _POSIX_TIMERS

--- boost/config/detail/posix_features.hpp.orig	2005-10-14 14:16:26.000000000 +0000
+++ boost/config/detail/posix_features.hpp
@@ -18,12 +18,12 @@
 #     include <unistd.h>
 
       // XOpen has <nl_types.h>, but is this the correct version check?
-#     if defined(_XOPEN_VERSION) && (_XOPEN_VERSION >= 3)
+#     if defined(_XOPEN_VERSION) && (_XOPEN_VERSION >= 3) || defined(__OpenBSD__)
 #        define BOOST_HAS_NL_TYPES_H
 #     endif
 
       // POSIX version 6 requires <stdint.h>
-#     if defined(_POSIX_VERSION) && (_POSIX_VERSION >= 200100)
+#     if defined(_POSIX_VERSION) && (_POSIX_VERSION >= 200100) || defined(__OpenBSD__)
 #        define BOOST_HAS_STDINT_H
 #     endif
 
@@ -33,7 +33,7 @@
 #     endif
 
       // POSIX version 3 requires <signal.h> to have sigaction:
-#     if defined(_POSIX_VERSION) && (_POSIX_VERSION >= 199506L)
+#     if defined(_POSIX_VERSION) && (_POSIX_VERSION >= 199506L) || defined(__OpenBSD__)
 #        define BOOST_HAS_SIGACTION
 #     endif
       // POSIX defines _POSIX_THREADS > 0 for pthread support,
@@ -49,7 +49,8 @@
       // BOOST_HAS_NANOSLEEP:
       // This is predicated on _POSIX_TIMERS or _XOPEN_REALTIME:
 #     if (defined(_POSIX_TIMERS) && (_POSIX_TIMERS+0 >= 0)) \
-             || (defined(_XOPEN_REALTIME) && (_XOPEN_REALTIME+0 >= 0))
+             || (defined(_XOPEN_REALTIME) && (_XOPEN_REALTIME+0 >= 0) \
+             || defined(__OpenBSD__))
 #        define BOOST_HAS_NANOSLEEP
 #     endif
 
@@ -57,7 +58,7 @@
       // This is predicated on _POSIX_TIMERS (also on _XOPEN_REALTIME
       // but at least one platform - linux - defines that flag without
       // defining clock_gettime):
-#     if (defined(_POSIX_TIMERS) && (_POSIX_TIMERS+0 >= 0))
+#     if (defined(_POSIX_TIMERS) && (_POSIX_TIMERS+0 >= 0) || defined(__OpenBSD__))
 #        define BOOST_HAS_CLOCK_GETTIME
 #     endif
 
@@ -75,7 +76,7 @@
       // These are predicated on _XOPEN_VERSION, and appears to be first released
       // in issue 4, version 2 (_XOPEN_VERSION > 500).
       // Likewise for the functions log1p and expm1.
-#     if defined(_XOPEN_VERSION) && (_XOPEN_VERSION+0 >= 500)
+#     if (defined(_XOPEN_VERSION) && (_XOPEN_VERSION+0 >= 500)) || defined(__OpenBSD__)
 #        define BOOST_HAS_GETTIMEOFDAY
 #        if defined(_XOPEN_SOURCE) && (_XOPEN_SOURCE+0 >= 500)
 #           define BOOST_HAS_PTHREAD_MUTEXATTR_SETTYPE
