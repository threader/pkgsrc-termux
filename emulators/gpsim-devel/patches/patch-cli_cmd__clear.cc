$NetBSD: patch-cli_cmd__clear.cc,v 1.1 2011/12/19 15:58:40 wiz Exp $

--- cli/cmd_clear.cc.orig	2005-08-31 14:46:29.000000000 +0000
+++ cli/cmd_clear.cc
@@ -22,6 +22,7 @@ Boston, MA 02111-1307, USA.  */
 #include <iostream>
 #include <iomanip>
 #include <string>
+#include <typeinfo>
 
 #include "command.h"
 #include "cmd_clear.h"
