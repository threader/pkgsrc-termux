$NetBSD: patch-src_fdevent__solaris__port.c,v 1.1 2017/10/25 14:27:20 fhajny Exp $

Obviously proper header is needed for POLL* events.

--- src/fdevent_solaris_port.c.orig	2017-10-22 20:09:57.000000000 +0000
+++ src/fdevent_solaris_port.c
@@ -5,6 +5,7 @@
 #include "log.h"
 
 #include <sys/types.h>
+#include <sys/poll.h>
 
 #include <unistd.h>
 #include <stdlib.h>
