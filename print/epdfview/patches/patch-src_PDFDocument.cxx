$NetBSD: patch-src_PDFDocument.cxx,v 1.1 2013/02/03 20:00:28 jakllsch Exp $

Correct colors, presuably due to a change in poppler.

--- src/PDFDocument.cxx.orig	2011-05-28 10:25:01.000000000 +0000
+++ src/PDFDocument.cxx
@@ -20,6 +20,7 @@
 #include <time.h>
 #include <poppler.h>
 #include <unistd.h>
+#include <algorithm>
 #include "epdfview.h"
 
 using namespace ePDFView;
@@ -33,6 +34,24 @@ static PageLayout convertPageLayout (gin
 static PageMode convertPageMode (gint pageMode);
 static gchar *getAbsoluteFileName (const gchar *fileName);
 
+namespace
+{
+    void
+    convert_bgra_to_rgba (guint8 *data, int width, int height)
+    {
+        using std::swap;
+
+        for (int y = 0; y < height; y++)
+        {
+            for (int x = 0; x < width; x++)
+            {
+                swap(data[0], data[2]);
+                data += 4;
+            }
+        }
+    }
+}
+
 ///
 /// @brief Constructs a new PDFDocument object.
 ///
@@ -650,6 +669,7 @@ PDFDocument::renderPage (gint pageNum)
         poppler_page_render (page, context);
         cairo_destroy(context);
         cairo_surface_destroy (surface);
+        convert_bgra_to_rgba(renderedPage->getData (), width, height);
 #else // !HAVE_POPPLER_0_17_0
         // Create the pixbuf from the data and render to it.
         GdkPixbuf *pixbuf = gdk_pixbuf_new_from_data (renderedPage->getData (),
