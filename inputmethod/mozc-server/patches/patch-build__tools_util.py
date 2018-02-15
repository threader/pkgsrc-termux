$NetBSD: patch-build__tools_util.py,v 1.5 2017/12/17 14:15:43 tsutsui Exp $

* NetBSD support

--- build_tools/util.py.orig	2016-05-15 08:11:10.000000000 +0000
+++ build_tools/util.py
@@ -59,6 +59,11 @@ def IsLinux():
   return os.name == 'posix' and os.uname()[0] == 'Linux'
 
 
+def IsNetBSD():
+  """Returns true if the platform is NetBSD."""
+  return os.name == 'posix' and os.uname()[0] == 'NetBSD'
+
+
 def GetNumberOfProcessors():
   """Returns the number of CPU cores available.
 
