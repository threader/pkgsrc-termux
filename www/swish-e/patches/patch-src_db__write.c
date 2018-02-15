$NetBSD: patch-src_db__write.c,v 1.1 2017/02/09 00:18:01 joerg Exp $

--- src/db_write.c.orig	2017-02-08 21:49:38.714903409 +0000
+++ src/db_write.c
@@ -239,7 +239,7 @@ void build_worddata(SWISH * sw, ENTRY * 
         /* Jump pointer to next element */
         p = compressed_data + sizeof(LOCATION *);
 
-        metaID = uncompress2(&p);
+        metaID = swish_uncompress2(&p);
 
         memcpy((char *)&chunk_size,(char *)p,sizeof(chunk_size));
         p += sizeof(chunk_size);
@@ -386,12 +386,12 @@ unsigned char *q;
     ** are presents to calculate a safe size for olddata with packedlongs */
     p1=olddata;
     num_metaids1=0;
-    uncompress2(&p1);   /* Jump tfreq */
+    swish_uncompress2(&p1);   /* Jump tfreq */
     do
     {
         num_metaids1++;
-        uncompress2(&p1);   /* Jump metaid */
-        metadata_length_1 = uncompress2(&p1);
+        swish_uncompress2(&p1);   /* Jump metaid */
+        metadata_length_1 = swish_uncompress2(&p1);
         p1 += metadata_length_1;
     } while ((p1 - olddata) != sz_olddata);
     maxtotsize = sw->Index->sz_worddata_buffer + (sz_olddata + num_metaids1 * sizeof(long));
@@ -417,17 +417,17 @@ unsigned char *q;
     q = p = sw->Index->worddata_buffer;
 
     /* Now read tfrequency */
-    tfreq1 = uncompress2(&p1); /* tfrequency - number of files with this word */
-    tfreq2 = uncompress2(&p2); /* tfrequency - number of files with this word */
+    tfreq1 = swish_uncompress2(&p1); /* tfrequency - number of files with this word */
+    tfreq2 = swish_uncompress2(&p2); /* tfrequency - number of files with this word */
     /* Write tfrequency */
     p = compress3(tfreq1 + tfreq2, p);
 
     /* Now look for MetaIDs */
-    curmetaID_1 = uncompress2(&p1);
-    curmetaID_2 = uncompress2(&p2);
+    curmetaID_1 = swish_uncompress2(&p1);
+    curmetaID_2 = swish_uncompress2(&p2);
 
     /* Old data is compressed in a different more optimized schema */
-    metadata_length_1 = uncompress2(&p1);
+    metadata_length_1 = swish_uncompress2(&p1);
     nextposmetaname_1 = p1 - olddata + metadata_length_1;
 
     curmetanamepos_1 = p1 - olddata;
@@ -485,8 +485,8 @@ unsigned char *q;
             /* Values for next metaID if exists */
             if(curmetaID_1)
             {
-                curmetaID_1 = uncompress2(&p1);  /* Next metaID */
-                metadata_length_1 = uncompress2(&p1);
+                curmetaID_1 = swish_uncompress2(&p1);  /* Next metaID */
+                metadata_length_1 = swish_uncompress2(&p1);
                 nextposmetaname_1 = p1 - olddata + metadata_length_1;
                 curmetanamepos_1 = p1 - olddata;
             }
@@ -522,7 +522,7 @@ unsigned char *q;
             /* Values for next metaID if exists */
             if(curmetaID_2)
             {
-                curmetaID_2 = uncompress2(&p2);  /* Next metaID */
+                curmetaID_2 = swish_uncompress2(&p2);  /* Next metaID */
                 nextposmetaname_2 = UNPACKLONG2(p2);
                 p2 += sizeof(long);
                 curmetanamepos_2 = p2 - newdata;
@@ -539,8 +539,8 @@ unsigned char *q;
             }
             else
             {
-                curmetaID_1 = uncompress2(&p1);  /* Next metaID */
-                metadata_length_1 = uncompress2(&p1);
+                curmetaID_1 = swish_uncompress2(&p1);  /* Next metaID */
+                metadata_length_1 = swish_uncompress2(&p1);
                 nextposmetaname_1 = p1 - olddata + metadata_length_1;
                 curmetanamepos_1 = p1 - olddata;
             }
@@ -556,7 +556,7 @@ unsigned char *q;
             }
             else
             {
-                curmetaID_2 = uncompress2(&p2);  /* Next metaID */
+                curmetaID_2 = swish_uncompress2(&p2);  /* Next metaID */
                 nextposmetaname_2 = UNPACKLONG2(p2);
                 p2 += sizeof(long);
                 curmetanamepos_2 = p2 - newdata;
@@ -587,8 +587,8 @@ unsigned char *q;
         }
         else
         {
-            curmetaID_1 = uncompress2(&p1);  /* Next metaID */
-            metadata_length_1 = uncompress2(&p1);
+            curmetaID_1 = swish_uncompress2(&p1);  /* Next metaID */
+            metadata_length_1 = swish_uncompress2(&p1);
             nextposmetaname_1 = p1 - olddata + metadata_length_1;
             curmetanamepos_1 = p1 - olddata;
         }
@@ -615,7 +615,7 @@ unsigned char *q;
         }
         else
         {
-            curmetaID_2 = uncompress2(&p2);  /* Next metaID */
+            curmetaID_2 = swish_uncompress2(&p2);  /* Next metaID */
             nextposmetaname_2 = UNPACKLONG2(p2);
             p2+= sizeof(long);
             curmetanamepos_2= p2 - newdata;
