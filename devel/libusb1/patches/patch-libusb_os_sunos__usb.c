$NetBSD: patch-libusb_os_sunos__usb.c,v 1.2 2017/10/02 13:20:28 leot Exp $

add di_prop_exists() for cases such as illumos not having the function yet
add timerfd support for cases such as illumos already having support

--- libusb/os/sunos_usb.c.orig	2016-04-01 02:22:35.735471484 +0000
+++ libusb/os/sunos_usb.c
@@ -1,6 +1,7 @@
 /*
  *
  * Copyright (c) 2016, Oracle and/or its affiliates.
+ * Copyright 2016 PALO, Richard.
  *
  * This library is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public
@@ -38,6 +39,12 @@
 #include "libusbi.h"
 #include "sunos_usb.h"
 
+#ifndef di_prop_exists
+static int di_prop_exists(dev_t dev, di_node_t node, const char *prop_name) {
+	return (di_prop_find(dev, node, prop_name) != DI_PROP_NIL);
+}
+#endif
+
 /*
  * Backend functions
  */
@@ -1254,6 +1261,13 @@
 	return (status);
 }
 
+#ifdef USBI_TIMERFD_AVAILABLE
+static clockid_t op_get_timerfd_clockid(void)
+{
+	return CLOCK_REALTIME;
+}
+#endif
+
 const struct usbi_os_backend sunos_backend = {
         .name = "Solaris",
         .caps = 0,
@@ -1286,6 +1300,9 @@
         .clear_transfer_priv = sunos_clear_transfer_priv,
         .handle_transfer_completion = sunos_handle_transfer_completion,
         .clock_gettime = sunos_clock_gettime,
+#ifdef USBI_TIMERFD_AVAILABLE
+	.get_timerfd_clockid = op_get_timerfd_clockid,
+#endif
         .device_priv_size = sizeof(sunos_dev_priv_t),
         .device_handle_priv_size = sizeof(sunos_dev_handle_priv_t),
         .transfer_priv_size = sizeof(sunos_xfer_priv_t),
