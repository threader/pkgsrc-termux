$NetBSD: patch-plugins_subversion_kdevsvncpp_client_ls.cpp,v 1.1 2015/08/29 02:29:53 markd Exp $

make subversion plugin compile with subversion 1.9.

--- plugins/subversion/kdevsvncpp/client_ls.cpp.orig	2014-08-26 19:49:48.000000000 +0000
+++ plugins/subversion/kdevsvncpp/client_ls.cpp
@@ -29,6 +29,7 @@
 #include "svn_client.h"
 #include "svn_path.h"
 #include "svn_sorts.h"
+#include "svn_version.h"
 //#include "svn_utf.h"
 
 // svncpp
@@ -37,6 +38,8 @@
 #include "kdevsvncpp/exception.hpp"
 
 
+#if SVN_VER_MAJOR == 1 && SVN_VER_MINOR < 8
+
 static int
 compare_items_as_paths(const svn_sort__item_t *a, const svn_sort__item_t *b)
 {
@@ -90,6 +93,72 @@ namespace svn
   }
 }
 
+#else
+
+#include <algorithm>
+
+static svn_error_t* store_entry(
+        void *baton,
+        const char *path,
+        const svn_dirent_t *dirent,
+        const svn_lock_t *,
+        const char *abs_path,
+        const char *,
+        const char *,
+        apr_pool_t *scratch_pool)
+{
+  svn::DirEntries *entries = reinterpret_cast<svn::DirEntries*>(baton);
+  if (path[0] == '\0') {
+    if (dirent->kind == svn_node_file) {
+      // for compatibility with svn_client_ls behaviour, listing a file
+      // stores that file name
+      entries->push_back(svn::DirEntry(svn_path_basename(abs_path, scratch_pool), dirent));
+    }
+  } else {
+    entries->push_back(svn::DirEntry(path, dirent));
+  }
+  return SVN_NO_ERROR;
+}
+
+static bool sort_by_path(svn::DirEntry const& a, svn::DirEntry const& b)
+{
+  return svn_path_compare_paths(a.name(), b.name()) < 0;
+}
+
+namespace svn
+{
+  DirEntries
+  Client::list(const char * pathOrUrl,
+               svn_opt_revision_t * revision,
+               bool recurse) throw(ClientException)
+  {
+    Pool pool;
+    DirEntries entries;
+
+    svn_error_t * error =
+      svn_client_list3(pathOrUrl,
+                       revision,
+                       revision,
+                       SVN_DEPTH_INFINITY_OR_IMMEDIATES(recurse),
+                       SVN_DIRENT_ALL,
+                       FALSE, // fetch locks
+                       FALSE, // include externals
+                       &store_entry,
+                       &entries,
+                       *m_context,
+                       pool);
+
+    if (error != SVN_NO_ERROR)
+      throw ClientException(error);
+
+    std::sort(entries.begin(), entries.end(), &sort_by_path);
+
+    return entries;
+  }
+}
+
+#endif
+
 /* -----------------------------------------------------------------
  * local variables:
  * eval: (load-file "../../rapidsvn-dev.el")
