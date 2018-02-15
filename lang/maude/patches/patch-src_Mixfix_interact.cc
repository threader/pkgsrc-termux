$NetBSD: patch-src_Mixfix_interact.cc,v 1.2 2015/12/29 23:34:51 dholland Exp $

Fix build with newer bison.

--- src/Mixfix/interact.cc.orig	2013-11-28 01:17:11.000000000 +0000
+++ src/Mixfix/interact.cc
@@ -25,13 +25,14 @@
 //
 #include <signal.h>
 
+#include "surface.h"
+
 bool UserLevelRewritingContext::interactiveFlag = true;
 bool UserLevelRewritingContext::ctrlC_Flag = false;
 bool UserLevelRewritingContext::stepFlag = false;
 bool UserLevelRewritingContext::abortFlag = false;
 int UserLevelRewritingContext::debugLevel = 0;
 
-int yyparse(void*);
 void cleanUpParser();
 void cleanUpLexer();
 
