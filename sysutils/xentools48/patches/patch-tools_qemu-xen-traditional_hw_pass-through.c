$NetBSD: patch-tools_qemu-xen-traditional_hw_pass-through.c,v 1.1 2017/03/30 09:15:10 bouyer Exp $

--- tools/qemu-xen-traditional/hw/pass-through.c.orig	2014-10-06 17:50:24.000000000 +0200
+++ tools/qemu-xen-traditional/hw/pass-through.c	2015-01-19 13:16:38.000000000 +0100
@@ -84,8 +84,6 @@
  */
 
 #include "pass-through.h"
-#include "pci/header.h"
-#include "pci/pci.h"
 #include "pt-msi.h"
 #include "qemu-xen.h"
 #include "iomulti.h"
