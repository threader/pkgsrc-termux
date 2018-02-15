$NetBSD: patch-strip_non_asm_libtool_args.sh,v 1.1 2017/01/01 11:52:36 adam Exp $

Support -kPIC and simplify.

--- strip_non_asm_libtool_args.sh.orig	2004-07-29 08:43:23.000000000 +0200
+++ strip_non_asm_libtool_args.sh	2007-02-22 20:11:41.000000000 +0100
@@ -5,15 +5,12 @@
 # Also, on some versions of OS X it tries to pass -fno-common
 # to 'as' which causes problems.
 command=""
-while [ $1 ]; do
-	if [ "$1" != "-fPIC" ]; then
-		if [ "$1" != "-DPIC" ]; then
-			if [ "$1" != "-fno-common" ]; then
-				command="$command $1"
-			fi
-		fi
-	fi
-	shift
+for arg; do
+	case "$arg" in
+	-[DfK]PIC |\
+	-fno-common)	continue;;
+	esac
+	command="$command $arg"
 done
-echo $command
+echo "$command"
 exec $command
