$NetBSD: patch-src_rrd__tool.c,v 1.1 2017/07/27 18:31:20 adam Exp $

--- src/rrd_tool.c.orig	2012-01-24 10:08:48.000000000 +0000
+++ src/rrd_tool.c
@@ -670,11 +670,11 @@ int HandleInputLine(
     else if (strcmp("resize", argv[1]) == 0)
         rrd_resize(argc - 1, &argv[1]);
     else if (strcmp("last", argv[1]) == 0)
-        printf("%ld\n", rrd_last(argc - 1, &argv[1]));
+	    printf("%lld\n", (long long)rrd_last(argc - 1, &argv[1]));
     else if (strcmp("lastupdate", argv[1]) == 0) {
         rrd_lastupdate(argc - 1, &argv[1]);
     } else if (strcmp("first", argv[1]) == 0)
-        printf("%ld\n", rrd_first(argc - 1, &argv[1]));
+	    printf("%lld\n", (long long)rrd_first(argc - 1, &argv[1]));
     else if (strcmp("update", argv[1]) == 0)
         rrd_update(argc - 1, &argv[1]);
     else if (strcmp("fetch", argv[1]) == 0) {
@@ -692,7 +692,7 @@ int HandleInputLine(
                 printf("%20s", ds_namv[i]);
             printf("\n\n");
             for (ti = start + step; ti <= end; ti += step) {
-                printf("%10lu:", ti);
+		    printf("%10llu:", (unsigned long long)ti);
                 for (ii = 0; ii < ds_cnt; ii++)
                     printf(" %0.10e", *(datai++));
                 printf("\n");
