$NetBSD: patch-tnm_snmp_straps.c,v 1.1 2014/03/05 13:52:29 he Exp $

Provide more robustness for the straps helper program.

--- tnm/snmp/straps.c.orig	1999-03-09 18:06:10.000000000 +0100
+++ tnm/snmp/straps.c	2014-03-04 13:25:45.000000000 +0100
@@ -246,6 +246,17 @@
 #endif
     
     /*
+     * If there is a steady stream of traps bound for this
+     * host, we need to allow some time for the client (scotty)
+     * to connect to us.  Otherwise, straps will just exit when
+     * the first trap message arrives.  The client does 5 retries
+     * with 1 second in-between, so sleeping for 3 should be enough
+     * to let the client connect.  There really ought to be a better
+     * way to do this.
+     */
+    sleep(3);
+
+    /*
      * Fine everything is ready; lets listen for events: 
      * the for(;;) loop aborts, if the last client went away.
      */
@@ -271,7 +282,25 @@
 	      perror("straps: select failed");
 	  }
 	  
-	  if (FD_ISSET(trap_s, &fds)) {
+	  /* 
+	   * Check for new clients before handling any traps.
+	   * If a trap arrived while we were sleeping above,
+	   * we would set go_on to zero before the first client
+	   * had a chance to connect.
+	   */
+	  if (FD_ISSET(serv_s, &fds)) {
+	       /* accept a new client: */
+	       memset((char *) &daddr, 0, sizeof(daddr));
+	       dlen = sizeof(daddr);
+            
+	       rc = accept(serv_s, (struct sockaddr *) &daddr, &dlen);
+	       if (rc < 0) {
+		    perror("straps: accept failed");
+		    continue;
+	       }
+	       cl_addr [rc] = 1;
+
+	  } else if (FD_ISSET(trap_s, &fds)) {
 	      /* read trap message and forward to clients: */
 	      llen = sizeof(laddr);
 	      if ((rc = recvfrom(trap_s, buf, sizeof(buf), 0, 
@@ -329,24 +358,6 @@
 		  go_on += cl_addr [i] > 0;
 	      }
 
-	  } else if (FD_ISSET(serv_s, &fds)) {
-	      memset((char *) &daddr, 0, sizeof(daddr));
-	      dlen = sizeof(daddr);
-	      
-	      rc = accept(serv_s, (struct sockaddr *) &daddr, &dlen);
-	      if (rc < 0) {
-		  perror("straps: accept failed");
-		  continue;
-	      }
-	      /* Check for a potential buffer overflow if the accept()
-		 call returns a file descriptor larger than FD_SETSIZE */
-	      if (rc >= FD_SETSIZE) {
-		  fprintf(stderr, "straps: too many clients\n");
-		  close(rc);
-		  continue;
-	      }
-	      cl_addr [rc] = 1;
-
 	  } else {
 	      /* fd's connected from clients. (XXX: should check for EOF): */
 	      for (i = 0; i < FD_SETSIZE; i++) {
