$NetBSD: patch-src_index.c,v 1.1 2017/02/09 00:18:01 joerg Exp $

--- src/index.c.orig	2017-02-08 21:48:59.967412529 +0000
+++ src/index.c
@@ -1748,7 +1748,7 @@ void getPositionsFromIgnoreLimitWords(SW
                  /* Jump pointer to next element */
                  p = compressed_data + sizeof(LOCATION *);
 
-                 metaID = uncompress2(&p);
+                 metaID = swish_uncompress2(&p);
 
                  memcpy((char *)&chunk_size,(char *)p,sizeof(chunk_size));
                  p += sizeof(chunk_size);
@@ -1842,8 +1842,8 @@ void adjustWordPositions(unsigned char *
 
     p = worddata;
 
-    tmpval = uncompress2(&p);     /* tfrequency */
-    metaID = uncompress2(&p);     /* metaID */
+    tmpval = swish_uncompress2(&p);     /* tfrequency */
+    metaID = swish_uncompress2(&p);     /* metaID */
     r_nextposmeta =  UNPACKLONG2(p); 
     w_nextposmeta = p;
     p += sizeof(long);
@@ -1907,7 +1907,7 @@ void adjustWordPositions(unsigned char *
             if(q != p)
                 PACKLONG2(q - worddata, w_nextposmeta);
 
-            metaID = uncompress2(&p);
+            metaID = swish_uncompress2(&p);
             q = compress3(metaID,q);
 
             r_nextposmeta = UNPACKLONG2(p); 
@@ -2035,7 +2035,7 @@ static void    sortChunkLocations(ENTRY 
         /* Jump next offset */
         compressed_data += sizeof(LOCATION *);
 
-        metaID = uncompress2(&compressed_data);
+        metaID = swish_uncompress2(&compressed_data);
         uncompress_location_values(&compressed_data,&flag,&filenum,&frequency);
         pi[0] = metaID;
         pi[1] = filenum;
@@ -2784,7 +2784,7 @@ void add_coalesced(SWISH *sw, ENTRY *e, 
     for(tprev =NULL, tloc = e->allLocationList; tloc; )
     {
         tp = (unsigned char *)tloc + sizeof(void *);
-        tmp = uncompress2(&tp); /* Read metaID */
+        tmp = swish_uncompress2(&tp); /* Read metaID */
         if(tmp > metaID)
              break;
         tprev = tloc;
@@ -2854,7 +2854,7 @@ void    coalesce_word_locations(SWISH * 
         p += sizeof(LOCATION *);
 
         /* get metaID of LOCATION */
-        metaID = uncompress2(&p);
+        metaID = swish_uncompress2(&p);
 
         /* Check for new metaID */
         if(metaID != curmetaID)
@@ -3149,7 +3149,7 @@ static void sortSwapLocData(ENTRY *e)
         /* Jump fileoffset */
         compressed_data += sizeof(LOCATION *);
 
-        metaID = uncompress2(&compressed_data);
+        metaID = swish_uncompress2(&compressed_data);
         pi[0] = metaID;
         pi[1] = i-k;
         ptmp2 += 2 * sizeof(int);
