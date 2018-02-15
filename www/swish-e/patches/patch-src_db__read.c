$NetBSD: patch-src_db__read.c,v 1.1 2017/02/09 00:18:01 joerg Exp $

--- src/db_read.c.orig	2017-02-08 21:49:36.517681427 +0000
+++ src/db_read.c
@@ -308,24 +308,24 @@ void    parse_MetaNames_from_buffer(INDE
     /* First clear out the default metanames */
     freeMetaEntries( header );
 
-    num_metanames = uncompress2(&s);
+    num_metanames = swish_uncompress2(&s);
 
     for (i = 0; i < num_metanames; i++)
     {
-        len = uncompress2(&s);
+        len = swish_uncompress2(&s);
         word = emalloc(len +1);
         memcpy(word,s,len); s += len;
         word[len] = '\0';
         /* Read metaID */
-        metaID = uncompress2(&s);
+        metaID = swish_uncompress2(&s);
         /* metaType was saved as metaType+1 */
-        metaType = uncompress2(&s);
+        metaType = swish_uncompress2(&s);
 
-        alias = uncompress2(&s) - 1;
+        alias = swish_uncompress2(&s) - 1;
 
-        sort_len = uncompress2(&s);
+        sort_len = swish_uncompress2(&s);
 
-        bias = uncompress2(&s) - RANK_BIAS_RANGE - 1;
+        bias = swish_uncompress2(&s) - RANK_BIAS_RANGE - 1;
 
 
         /* add the meta tag */
@@ -350,11 +350,11 @@ static void load_word_hash_from_buffer(W
 
     unsigned char   *s = (unsigned char *)buffer;
 
-    num_words = uncompress2(&s);
+    num_words = swish_uncompress2(&s);
     
     for (i=0; i < num_words ; i++)   
     {
-        len = uncompress2(&s);
+        len = swish_uncompress2(&s);
         word = emalloc(len+1);
         memcpy(word,s,len); s += len;
         word[len] = '\0';
@@ -373,10 +373,10 @@ void parse_integer_table_from_buffer(int
     int     tmp,i;
     unsigned char    *s = (unsigned char *)buffer;
 
-    tmp = uncompress2(&s);   /* Jump the number of elements */
+    tmp = swish_uncompress2(&s);   /* Jump the number of elements */
     for (i = 0; i < table_size; i++)
     {
-        tmp = uncompress2(&s); /* Gut all the elements */
+        tmp = swish_uncompress2(&s); /* Gut all the elements */
         table[i] = tmp - 1;
     }
 }
