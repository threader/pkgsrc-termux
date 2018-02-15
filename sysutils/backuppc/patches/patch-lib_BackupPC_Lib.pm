$NetBSD: patch-lib_BackupPC_Lib.pm,v 1.1 2016/03/13 01:02:44 tnn Exp $

unescaped left brace in regex is deprecated

--- lib/BackupPC/Lib.pm.orig	2015-01-12 00:19:53.000000000 +0000
+++ lib/BackupPC/Lib.pm
@@ -1261,7 +1261,7 @@ sub cmdVarSubstitute
         #
         # Replace scalar variables first
         #
-        $arg =~ s[\${(\w+)}(\+?)]{
+        $arg =~ s[\$\{(\w+)}(\+?)]{
             exists($vars->{$1}) && ref($vars->{$1}) ne "ARRAY"
                 ? ($2 eq "+" ? $bpc->shellEscape($vars->{$1}) : $vars->{$1})
                 : "\${$1}$2"
@@ -1270,7 +1270,7 @@ sub cmdVarSubstitute
         # Now replicate any array arguments; this just works for just one
         # array var in each argument.
         #
-        if ( $arg =~ m[(.*)\${(\w+)}(\+?)(.*)] && ref($vars->{$2}) eq "ARRAY" ) {
+        if ( $arg =~ m[(.*)\$\{(\w+)}(\+?)(.*)] && ref($vars->{$2}) eq "ARRAY" ) {
             my $pre  = $1;
             my $var  = $2;
             my $esc  = $3;
