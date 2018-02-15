$NetBSD: patch-embed_downloader-view.c,v 1.1 2013/08/13 01:03:02 obache Exp $

* libnotify-0.7 API change

--- embed/downloader-view.c.orig	2010-09-09 20:33:19.000000000 +0000
+++ embed/downloader-view.c
@@ -337,7 +337,7 @@ show_notification (DownloaderView *dv, c
 	g_object_ref (dv);
 
 	notification = notify_notification_new (title, msg,
-						GTK_STOCK_INFO, NULL);
+						GTK_STOCK_INFO);
 
 	g_signal_connect_after (notification, "closed",
 				G_CALLBACK (notification_closed_cb), dv);
@@ -346,8 +346,6 @@ show_notification (DownloaderView *dv, c
 	notify_notification_set_timeout (notification, NOTIFY_EXPIRES_DEFAULT);
 	notify_notification_set_urgency (notification, NOTIFY_URGENCY_LOW);
 
-	notify_notification_attach_to_status_icon (notification, status_icon);
-
 	/* There are some visual glitches when the notification is shown and
 	 * the GtkStatusIcon is still not visible. To avoid that, we delay the
 	 * popup a bit. */
