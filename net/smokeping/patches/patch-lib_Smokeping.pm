$NetBSD: patch-lib_Smokeping.pm,v 1.1 2013/06/16 21:38:51 wiz Exp $

Fix pod2man error with perl-5.18 -- it does not like slash.

--- lib/Smokeping.pm.orig	2012-01-11 08:48:43.000000000 +0000
+++ lib/Smokeping.pm
@@ -2609,7 +2609,7 @@ DOC
 The base directory where SmokePing keeps the files related to the DYNAMIC function.
 This directory must be writeable by the WWW server. It is also used for temporary
 storage of slave polling results by the master in 
-L<the master/slave mode|smokeping_master_slave>.
+L<the master-slave mode|smokeping_master_slave>.
 
 If this variable is not specified, the value of C<datadir> will be used instead.
 DOC
