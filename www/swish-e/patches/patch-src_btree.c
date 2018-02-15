$NetBSD: patch-src_btree.c,v 1.1 2017/02/09 00:18:01 joerg Exp $

--- src/btree.c.orig	2017-02-08 21:49:08.790805235 +0000
+++ src/btree.c
@@ -321,7 +321,7 @@ unsigned char *key_k;
     {
         k = j + (i - j) / 2;
         key_k = BTREE_KeyData(pg,k);
-        key_len_k = uncompress2(&key_k);
+        key_len_k = swish_uncompress2(&key_k);
         isbigger = BTREE_CompareKeys(key,key_len,key_k,key_len_k);
         if (!isbigger)
             break;
@@ -358,7 +358,7 @@ sw_off_t data_pointer;
         return 0;
 
     *found = BTREE_KeyData(pg,k);
-    *found_len = uncompress2(found);
+    *found_len = swish_uncompress2(found);
 
     /* Solaris do not like this. Use memcpy instead
     data_pointer = *(sw_off_t *) (*found + *found_len);
@@ -483,7 +483,7 @@ int j, k = pos;
 
     /* Compute length of deleted key */
     del_key_start = q = BTREE_KeyData(pg,k);
-    q += uncompress2(&q);
+    q += swish_uncompress2(&q);
     q += sizeof(sw_off_t);
     del_key_end = q;
     del_entry_len = del_key_end - del_key_start;
@@ -610,7 +610,7 @@ int tmp;
     for(i = 0; i < n; i++)
     {
         key_data = start = BTREE_KeyData(pg, pg->n - n + i);
-        key_len = uncompress2(&key_data);
+        key_len = swish_uncompress2(&key_data);
 
         memcpy(p, start, (key_data - start) + key_len + sizeof(sw_off_t));
         tmp = p - new_pg->data;
@@ -628,7 +628,7 @@ int tmp;
     for(i = 0; i < (int)pg->n ; i++)
     {
         key_data = start = BTREE_KeyData(pg,i);
-        key_len = uncompress2(&key_data);
+        key_len = swish_uncompress2(&key_data);
 
         memmove(p, start, (key_data - start) + key_len + sizeof(sw_off_t));
         tmp = p - pg->data;
@@ -687,7 +687,7 @@ int comp;
             if(!(pg->flags & BTREE_ROOT_NODE))
             {
                 key_data0 = BTREE_KeyData(pg,0);
-                key_len0 = uncompress2(&key_data0);
+                key_len0 = swish_uncompress2(&key_data0);
                 father_pg = BTREE_ReadPage(b,b->tree[level]);
                 BTREE_InsertInPage(b,father_pg, key_data0, key_len0, pg->page_number, level - 1, 1);
             }
@@ -711,7 +711,7 @@ int comp;
     pg->next = new_pg->page_number;
 
     key_data0 = BTREE_KeyData(new_pg,0);
-    key_len0 = uncompress2(&key_data0);
+    key_len0 = swish_uncompress2(&key_data0);
 
             /* Let's see where to put the key */
     if(BTREE_CompareKeys(key, key_len, key_data0, key_len0) > 0)
@@ -740,10 +740,10 @@ int comp;
         root_page = BTREE_NewPage(b,b->page_size, BTREE_ROOT_NODE);
 
         key_data0 = BTREE_KeyData(pg,0);
-        key_len0 = uncompress2(&key_data0);
+        key_len0 = swish_uncompress2(&key_data0);
         BTREE_AddKeyToPage(root_page, 0, key_data0, key_len0 , pg->page_number);
         key_data0 = BTREE_KeyData(new_pg,0);
-        key_len0 = uncompress2(&key_data0);
+        key_len0 = swish_uncompress2(&key_data0);
         BTREE_AddKeyToPage(root_page, 1, key_data0, key_len0, new_pg->page_number);
 
         b->root_page = root_page->page_number;
@@ -769,7 +769,7 @@ int comp;
         BTREE_FreePage(b, pg);
 
         key_data0 = BTREE_KeyData(new_pg,0);
-        key_len0 = uncompress2(&key_data0);
+        key_len0 = swish_uncompress2(&key_data0);
         BTREE_FreePage(b, BTREE_Walk(b,key_data0,key_len0));
     }
     else
@@ -778,7 +778,7 @@ int comp;
         BTREE_FreePage(b, pg);
 
         key_data0 = BTREE_KeyData(new_pg,0);
-        key_len0 = uncompress2(&key_data0);
+        key_len0 = swish_uncompress2(&key_data0);
     }
 
     if(!(new_pg->flags & BTREE_ROOT_NODE))
@@ -827,7 +827,7 @@ BTREE_Page *pg = BTREE_Walk(b,key,key_le
 
     key_k = BTREE_KeyData(pg,k);
 
-    key_len_k = uncompress2(&key_k);
+    key_len_k = swish_uncompress2(&key_k);
 
     if ( key_len_k != key_len)
         return -1;   /* Error - Should never happen */
@@ -903,7 +903,7 @@ int key_len_k;
         b->current_position = 0;
     }
     key_k = BTREE_KeyData(pg,b->current_position);
-    *found_len = key_len_k = uncompress2(&key_k);
+    *found_len = key_len_k = swish_uncompress2(&key_k);
     *found = emalloc(key_len_k);
     memcpy(*found,key_k,key_len_k);
     data_pointer = UNPACKFILEOFFSET(*(unsigned long *) (key_k + key_len_k));
