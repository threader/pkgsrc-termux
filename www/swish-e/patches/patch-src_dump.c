$NetBSD: patch-src_dump.c,v 1.1 2017/02/09 00:18:01 joerg Exp $

--- src/dump.c.orig	2017-02-08 21:49:02.064016668 +0000
+++ src/dump.c
@@ -249,9 +249,9 @@ void    DB_decompress(SWISH * sw, IndexF
                 /* parse and print word's data */
                 s = worddata;
 
-                tmpval = uncompress2(&s);     /* tfrequency */
-                metaID = uncompress2(&s);     /* metaID */
-                metadata_length = uncompress2(&s);
+                tmpval = swish_uncompress2(&s);     /* tfrequency */
+                metaID = swish_uncompress2(&s);     /* metaID */
+                metadata_length = swish_uncompress2(&s);
 
                 filenum = 0;
                 start = s;
@@ -276,8 +276,8 @@ void    DB_decompress(SWISH * sw, IndexF
                     if ( metadata_length == (s - start))
                     {
                         filenum = 0;
-                        metaID = uncompress2(&s);
-                        metadata_length = uncompress2(&s);
+                        metaID = swish_uncompress2(&s);
+                        metadata_length = swish_uncompress2(&s);
                         start = s;
                     }
 
@@ -337,9 +337,9 @@ void    DB_decompress(SWISH * sw, IndexF
                 /* parse and print word's data */
                 s = worddata;
 
-                tmpval = uncompress2(&s);     /* tfrequency */
-                metaID = uncompress2(&s);     /* metaID */
-                metadata_length = uncompress2(&s);
+                tmpval = swish_uncompress2(&s);     /* tfrequency */
+                metaID = swish_uncompress2(&s);     /* metaID */
+                metadata_length = swish_uncompress2(&s);
 
                 filenum = 0;
                 start = s;
@@ -437,8 +437,8 @@ void    DB_decompress(SWISH * sw, IndexF
                     if ( metadata_length == (s - start))
                     {
                         filenum = 0;
-                        metaID = uncompress2(&s);
-                        metadata_length = uncompress2(&s);
+                        metaID = swish_uncompress2(&s);
+                        metadata_length = swish_uncompress2(&s);
                         start = s;
                     }
                 }
