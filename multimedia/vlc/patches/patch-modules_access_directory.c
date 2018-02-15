$NetBSD: patch-modules_access_directory.c,v 1.1 2015/10/25 11:00:18 wiz Exp $

Mainly due to lack of bits for new fcntl flags, O_DIRECTORY isn't currently
supported by DragonFly's openat.  This patch checks which flags are supported
before passing them to vlc_openat.

--- modules/access/directory.c.orig	2014-11-16 18:57:58.000000000 +0000
+++ modules/access/directory.c
@@ -316,8 +316,14 @@ block_t *DirBlock (access_t *p_access)
     {
         DIR *handle;
 #ifdef HAVE_OPENAT
-        int fd = vlc_openat (dirfd (current->handle), entry,
-                             O_RDONLY | O_DIRECTORY);
+        int flags = 0;
+#ifdef O_RDONLY
+        flags |= O_RDONLY;
+#endif
+#ifdef O_DIRECTORY
+        flags |= O_DIRECTORY;
+#endif
+        int fd = vlc_openat (dirfd (current->handle), entry, flags);
         if (fd == -1)
         {
             if (errno == ENOTDIR)
