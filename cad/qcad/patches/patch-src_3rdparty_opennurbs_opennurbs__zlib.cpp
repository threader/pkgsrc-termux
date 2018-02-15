$NetBSD: patch-src_3rdparty_opennurbs_opennurbs__zlib.cpp,v 1.1 2017/12/18 21:21:44 plunky Exp $

don't provide own zlib

--- src/3rdparty/opennurbs/opennurbs_zlib.cpp.orig	2017-12-18 11:43:25.553607369 +0000
+++ src/3rdparty/opennurbs/opennurbs_zlib.cpp
@@ -293,11 +293,11 @@ size_t ON_BinaryArchive::WriteDeflate( /
       // no uncompressed input is left - switch to finish mode
       flush = Z_FINISH;
     }
-    zrc = z_deflate( &m_zlib.strm, flush ); 
+    zrc = deflate( &m_zlib.strm, flush ); 
     if ( zrc < 0 ) 
     {
       // Something went haywire - bail out.
-      ON_ERROR("ON_BinaryArchive::WriteDeflate - z_deflate failure");
+      ON_ERROR("ON_BinaryArchive::WriteDeflate - deflate failure");
       rc = false;
       break;
     }
@@ -491,11 +491,11 @@ bool ON_BinaryArchive::ReadInflate(
       // no compressed input is left - switch to finish mode
       flush = Z_FINISH;
     }
-    zrc = z_inflate( &m_zlib.strm, flush );
+    zrc = inflate( &m_zlib.strm, flush );
     if ( zrc < 0 ) 
     {
       // Something went haywire - bail out.
-      ON_ERROR("ON_BinaryArchive::ReadInflate - z_inflate failure");
+      ON_ERROR("ON_BinaryArchive::ReadInflate - inflate failure");
       rc = false;
       break;
     }
@@ -1151,11 +1151,11 @@ size_t ON_CompressedBuffer::DeflateHelpe
       // no uncompressed input is left - switch to finish mode
       flush = Z_FINISH;
     }
-    zrc = z_deflate( &m_zlib.strm, flush ); 
+    zrc = deflate( &m_zlib.strm, flush ); 
     if ( zrc < 0 ) 
     {
       // Something went haywire - bail out.
-      ON_ERROR("ON_CompressedBuffer::DeflateHelper - z_deflate failure");
+      ON_ERROR("ON_CompressedBuffer::DeflateHelper - deflate failure");
       rc = false;
       break;
     }
@@ -1284,11 +1284,11 @@ bool ON_CompressedBuffer::InflateHelper(
       // no compressed input is left - switch to finish mode
       flush = Z_FINISH;
     }
-    zrc = z_inflate( &m_zlib.strm, flush );
+    zrc = inflate( &m_zlib.strm, flush );
     if ( zrc < 0 ) 
     {
       // Something went haywire - bail out.
-      ON_ERROR("ON_CompressedBuffer::InflateHelper - z_inflate failure");
+      ON_ERROR("ON_CompressedBuffer::InflateHelper - inflate failure");
       rc = false;
       break;
     }
