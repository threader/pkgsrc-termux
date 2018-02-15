$NetBSD: patch-modules_python_src2_cv2.cv.hpp,v 1.1 2015/10/17 10:28:43 fhajny Exp $

Fix build under clang.
"error: C-style cast from 'nullprt_t' to 'CvNextEdgeType' is not allowed."

--- modules/python/src2/cv2.cv.hpp.orig	2014-04-11 10:15:26.000000000 +0000
+++ modules/python/src2/cv2.cv.hpp
@@ -2155,7 +2155,7 @@ static int convert_to_CvSubdiv2DPTR(PyOb
 static int convert_to_CvNextEdgeType(PyObject *o, CvNextEdgeType *dst, const char *name = "no_name")
 {
   if (!PyInt_Check(o)) {
-    *dst = (CvNextEdgeType)NULL;
+    *dst = (CvNextEdgeType)0;
     return failmsg("Expected number for CvNextEdgeType argument '%s'", name);
   } else {
     *dst = (CvNextEdgeType)PyInt_AsLong(o);
