$NetBSD: patch-libstdc++-v3_config_os_bsd_netbsd_ctype__inline.h,v 1.1 2015/07/16 12:03:36 ryoon Exp $

--- libstdc++-v3/config/os/bsd/netbsd/ctype_inline.h.orig	2013-02-03 17:54:05.000000000 +0000
+++ libstdc++-v3/config/os/bsd/netbsd/ctype_inline.h
@@ -48,7 +48,7 @@ _GLIBCXX_BEGIN_NAMESPACE_VERSION
   is(const char* __low, const char* __high, mask* __vec) const
   {
     while (__low < __high)
-      *__vec++ = _M_table[*__low++];
+      *__vec++ = _M_table[(unsigned char)*__low++];
     return __high;
   }
 
