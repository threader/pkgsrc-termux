$NetBSD: patch-sandbox-darwin.c,v 1.2 2016/01/18 12:53:26 jperkin Exp $

Support sandbox on newer OSX, from MacPorts.

--- sandbox-darwin.c.orig	2015-08-21 04:49:03.000000000 +0000
+++ sandbox-darwin.c
@@ -62,8 +62,16 @@ ssh_sandbox_child(struct ssh_sandbox *bo
 	struct rlimit rl_zero;
 
 	debug3("%s: starting Darwin sandbox", __func__);
+#ifdef __APPLE_SANDBOX_NAMED_EXTERNAL__
+#ifndef SANDBOX_NAMED_EXTERNAL
+#define SANDBOX_NAMED_EXTERNAL (0x3)
+#endif
+	if (sandbox_init("@PKG_SYSCONFDIR@/org.openssh.sshd.sb",
+	    SANDBOX_NAMED_EXTERNAL, &errmsg) == -1)
+#else
 	if (sandbox_init(kSBXProfilePureComputation, SANDBOX_NAMED,
 	    &errmsg) == -1)
+#endif
 		fatal("%s: sandbox_init: %s", __func__, errmsg);
 
 	/*
