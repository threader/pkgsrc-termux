$NetBSD: patch-panel-plugin_model.h,v 1.2 2015/04/21 08:56:45 jperkin Exp $

Fix inline use.
--- panel-plugin/model.h.orig	2013-11-10 14:34:13.000000000 +0000
+++ panel-plugin/model.h
@@ -36,13 +36,13 @@ struct _PlacesBookmarkAction
     void        (*finalize) (PlacesBookmarkAction *self);
 };
 
-inline PlacesBookmarkAction*
+PlacesBookmarkAction*
 places_bookmark_action_create(gchar *label);
 
-inline void
+void
 places_bookmark_action_destroy(PlacesBookmarkAction*);
 
-inline void
+void
 places_bookmark_action_call(PlacesBookmarkAction*);
 
 /* Places Bookmark */
@@ -70,10 +70,10 @@ struct _PlacesBookmark
     void                 (*finalize) (PlacesBookmark *self);
 };
 
-inline PlacesBookmark*
+PlacesBookmark*
 places_bookmark_create(gchar *label);
 
-inline void
+void
 places_bookmark_destroy(PlacesBookmark *bookmark);
 
 /* Places Bookmark Group */
@@ -86,16 +86,16 @@ struct _PlacesBookmarkGroup
     gpointer    priv;
 };
 
-inline GList*
+GList*
 places_bookmark_group_get_bookmarks(PlacesBookmarkGroup*);
 
-inline gboolean
+gboolean
 places_bookmark_group_changed(PlacesBookmarkGroup*);
 
-inline PlacesBookmarkGroup*
+PlacesBookmarkGroup*
 places_bookmark_group_create();
 
-inline void
+void
 places_bookmark_group_destroy(PlacesBookmarkGroup*);
 
 #endif
