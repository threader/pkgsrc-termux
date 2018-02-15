$NetBSD: patch-src_gimmix-playlist.c,v 1.1 2013/12/15 19:36:02 joerg Exp $

--- src/gimmix-playlist.c.orig	2013-12-15 15:32:41.000000000 +0000
+++ src/gimmix-playlist.c
@@ -39,7 +39,7 @@ typedef enum {
 
 typedef enum {
 	SONG = 1,
-	DIR,
+	DIRECTORY,
 	PLAYLIST
 } GimmixFileType;
 
@@ -149,7 +149,7 @@ on_drag_data_get (GtkWidget *widget, Gdk
 		gtk_tree_model_get_iter (model, &iter, list->data);
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 		
-		if (type == DIR || type == SONG)
+		if (type == DIRECTORY || type == SONG)
 		{
 			switch (target_type)
 			{
@@ -671,7 +671,7 @@ gimmix_library_and_playlists_populate (v
 						GDK_TYPE_PIXBUF, 	/* icon (0) */
 						G_TYPE_STRING, 		/* name (1) */
 						G_TYPE_STRING,		/* path (2) */
-						G_TYPE_INT,			/* type DIR/SONG (3) */
+						G_TYPE_INT,			/* type DIRECTORY/SONG (3) */
 						G_TYPE_INT);		/* id (4) */
 	
 	pls_store 	= gtk_list_store_new (2, 
@@ -696,7 +696,7 @@ gimmix_library_and_playlists_populate (v
 						0, dir_pixbuf,
 						1, path,
 						2, data->directory,
-						3, DIR,
+						3, DIRECTORY,
 						-1);
 			g_free (path);
 		}
@@ -954,7 +954,7 @@ cb_library_dir_activated (gpointer data)
 		gtk_tree_model_get_iter (model, &iter, list->data);
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 		
-		if (type == DIR)
+		if (type == DIRECTORY)
 		{	
 			gimmix_update_library_with_dir (path);
 		}
@@ -1005,7 +1005,7 @@ cb_library_popup_add_clicked (GtkWidget 
 		gtk_tree_model_get_iter (model, &iter, list->data);
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 		
-		if (type == DIR)
+		if (type == DIRECTORY)
 		{
 			mpd_playlist_queue_add (gmo, path);
 		}
@@ -1023,7 +1023,7 @@ cb_library_popup_add_clicked (GtkWidget 
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 	
 		
-		if (type == DIR)
+		if (type == DIRECTORY)
 		{	
 			mpd_playlist_queue_add (gmo, path);
 			g_free (path);
@@ -1081,7 +1081,7 @@ cd_library_popup_replace_clicked (GtkWid
 		gtk_tree_model_get_iter (model, &iter, list->data);
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 		
-		if (type == DIR)
+		if (type == DIRECTORY)
 		{
 			mpd_playlist_queue_add (gmo, path);
 		}
@@ -1099,7 +1099,7 @@ cd_library_popup_replace_clicked (GtkWid
 		gtk_tree_model_get (model, &iter, 2, &path, 3, &type, -1);
 	
 		
-		if (type == DIR)
+		if (type == DIRECTORY)
 		{	
 			mpd_playlist_queue_add (gmo, path);
 			g_free (path);
@@ -1245,7 +1245,7 @@ gimmix_update_library_with_dir (gchar *d
 					0, dir_pixbuf,
 					1, "..",
 					2, parent,
-					3, DIR,
+					3, DIRECTORY,
 					-1);
 		g_free (parent);
 	}
@@ -1260,7 +1260,7 @@ gimmix_update_library_with_dir (gchar *d
 								0, dir_pixbuf,
 								1, directory,
 								2, data->directory,
-								3, DIR,
+								3, DIRECTORY,
 								-1);
 			g_free (directory);
 		}
@@ -1341,7 +1341,7 @@ gimmix_library_song_info (void)
 	gtk_tree_model_get_iter (model, &iter, list->data);
 	gtk_tree_model_get (model, &iter, 2, &path, 3, &type, 4, &id, -1);
 
-	if (type == DIR)
+	if (type == DIRECTORY)
 	{
 		g_free (path);
 		return;
