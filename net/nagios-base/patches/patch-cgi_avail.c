$NetBSD: patch-cgi_avail.c,v 1.5 2017/05/24 07:42:39 manu Exp $

64bit time_t workaround

--- cgi/avail.c.orig	2017-05-09 19:03:31.000000000 +0200
+++ cgi/avail.c	2017-05-22 06:11:42.000000000 +0200
@@ -366,12 +366,12 @@
 			if(display_type == DISPLAY_HOST_AVAIL && show_all_hosts == FALSE) {
 				host_report_url("all", "View Availability Report For All Hosts");
 				printf("<BR>\n");
 #ifdef USE_TRENDS
-				printf("<a href='%s?host=%s&t1=%lu&t2=%lu&assumestateretention=%s&assumeinitialstates=%s&includesoftstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d'>View Trends For This Host</a><BR>\n", TRENDS_CGI, url_encode(host_name), t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
+				printf("<a href='%s?host=%s&t1=%lu&t2=%lu&assumestateretention=%s&assumeinitialstates=%s&includesoftstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d'>View Trends For This Host</a><BR>\n", TRENDS_CGI, url_encode(host_name), (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
 #endif
 #ifdef USE_HISTOGRAM
-				printf("<a href='%s?host=%s&t1=%lu&t2=%lu&assumestateretention=%s'>View Alert Histogram For This Host</a><BR>\n", HISTOGRAM_CGI, url_encode(host_name), t1, t2, (assume_state_retention == TRUE) ? "yes" : "no");
+				printf("<a href='%s?host=%s&t1=%lu&t2=%lu&assumestateretention=%s'>View Alert Histogram For This Host</a><BR>\n", HISTOGRAM_CGI, url_encode(host_name), (unsigned long)t1, (unsigned long)t2, (assume_state_retention == TRUE) ? "yes" : "no");
 #endif
 				printf("<a href='%s?host=%s'>View Status Detail For This Host</a><BR>\n", STATUS_CGI, url_encode(host_name));
 				printf("<a href='%s?host=%s'>View Alert History For This Host</a><BR>\n", HISTORY_CGI, url_encode(host_name));
 				printf("<a href='%s?host=%s'>View Notifications For This Host</a><BR>\n", NOTIFICATIONS_CGI, url_encode(host_name));
@@ -382,13 +382,13 @@
 				service_report_url("null", "all", "View Availability Report For All Services");
 				printf("<BR>\n");
 #ifdef USE_TRENDS
 				printf("<a href='%s?host=%s", TRENDS_CGI, url_encode(host_name));
-				printf("&service=%s&t1=%lu&t2=%lu&assumestateretention=%s&includesoftstates=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d'>View Trends For This Service</a><BR>\n", url_encode(svc_description), t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
+				printf("&service=%s&t1=%lu&t2=%lu&assumestateretention=%s&includesoftstates=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d'>View Trends For This Service</a><BR>\n", url_encode(svc_description), (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
 #endif
 #ifdef USE_HISTOGRAM
 				printf("<a href='%s?host=%s", HISTOGRAM_CGI, url_encode(host_name));
-				printf("&service=%s&t1=%lu&t2=%lu&assumestateretention=%s'>View Alert Histogram For This Service</a><BR>\n", url_encode(svc_description), t1, t2, (assume_state_retention == TRUE) ? "yes" : "no");
+				printf("&service=%s&t1=%lu&t2=%lu&assumestateretention=%s'>View Alert Histogram For This Service</a><BR>\n", url_encode(svc_description), (unsigned long)t1, (unsigned long)t2, (assume_state_retention == TRUE) ? "yes" : "no");
 #endif
 				printf("<A HREF='%s?host=%s&", HISTORY_CGI, url_encode(host_name));
 				printf("service=%s'>View Alert History For This Service</A><BR>\n", url_encode(svc_description));
 				printf("<A HREF='%s?host=%s&", NOTIFICATIONS_CGI, url_encode(host_name));
@@ -3959,15 +3959,15 @@
 
 #ifdef USE_TRENDS
 		printf("<p align='center'>\n");
 		printf("<a href='%s?host=%s", TRENDS_CGI, url_encode(host_name));
-		printf("&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d'>", t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
+		printf("&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d'>", (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
 #ifdef LEGACY_GRAPHICAL_CGIS
 		printf("<img src='%s?createimage&smallimage&host=%s", TRENDS_CGI, url_encode(host_name));
 #else
 		printf("<img src='%s?createimage&smallimage&host=%s", LEGACY_TRENDS_CGI, url_encode(host_name));
 #endif
-		printf("&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d' border=1 alt='Host State Trends' title='Host State Trends' width='500' height='20'>", t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
+		printf("&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedhoststate=%d&backtrack=%d' border=1 alt='Host State Trends' title='Host State Trends' width='500' height='20'>", (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_host_state, backtrack_archives);
 		printf("</a><br>\n");
 		printf("</p>\n");
 #endif
 		printf("<DIV ALIGN=CENTER>\n");
@@ -4447,15 +4447,15 @@
 		printf("<DIV ALIGN=CENTER CLASS='dataTitle'>Service State Breakdowns:</DIV>\n");
 #ifdef USE_TRENDS
 		printf("<p align='center'>\n");
 		printf("<a href='%s?host=%s", TRENDS_CGI, url_encode(host_name));
-		printf("&service=%s&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d'>", url_encode(svc_description), t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
+		printf("&service=%s&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d'>", url_encode(svc_description), (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
 #ifdef LEGACY_GRAPHICAL_CGIS
 		printf("<img src='%s?createimage&smallimage&host=%s", TRENDS_CGI, url_encode(host_name));
 #else
 		printf("<img src='%s?createimage&smallimage&host=%s", LEGACY_TRENDS_CGI, url_encode(host_name));
 #endif
-		printf("&service=%s&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d' border=1 alt='Service State Trends' title='Service State Trends' width='500' height='20'>", url_encode(svc_description), t1, t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
+		printf("&service=%s&t1=%lu&t2=%lu&includesoftstates=%s&assumestateretention=%s&assumeinitialstates=%s&assumestatesduringnotrunning=%s&initialassumedservicestate=%d&backtrack=%d' border=1 alt='Service State Trends' title='Service State Trends' width='500' height='20'>", url_encode(svc_description), (unsigned long)t1, (unsigned long)t2, (include_soft_states == TRUE) ? "yes" : "no", (assume_state_retention == TRUE) ? "yes" : "no", (assume_initial_states == TRUE) ? "yes" : "no", (assume_states_during_notrunning == TRUE) ? "yes" : "no", initial_assumed_service_state, backtrack_archives);
 		printf("</a><br>\n");
 		printf("</p>\n");
 #endif
 
@@ -4692,9 +4692,9 @@
 void host_report_url(const char *hn, const char *label) {
 
 	printf("<a href='%s?host=%s", AVAIL_CGI, url_encode(hn));
 	printf("&show_log_entries");
-	printf("&t1=%lu&t2=%lu", t1, t2);
+	printf("&t1=%lu&t2=%lu", (unsigned long)t1, (unsigned long)t2);
 	printf("&backtrack=%d", backtrack_archives);
 	printf("&assumestateretention=%s", (assume_state_retention == TRUE) ? "yes" : "no");
 	printf("&assumeinitialstates=%s", (assume_initial_states == TRUE) ? "yes" : "no");
 	printf("&assumestatesduringnotrunning=%s", (assume_states_during_notrunning == TRUE) ? "yes" : "no");
@@ -4716,9 +4716,9 @@
 void service_report_url(const char *hn, const char *sd, const char *label) {
 
 	printf("<a href='%s?host=%s", AVAIL_CGI, url_encode(hn));
 	printf("&service=%s", url_encode(sd));
-	printf("&t1=%lu&t2=%lu", t1, t2);
+	printf("&t1=%lu&t2=%lu", (unsigned long)t1, (unsigned long)t2);
 	printf("&backtrack=%d", backtrack_archives);
 	printf("&assumestateretention=%s", (assume_state_retention == TRUE) ? "yes" : "no");
 	printf("&assumeinitialstates=%s", (assume_initial_states == TRUE) ? "yes" : "no");
 	printf("&assumestatesduringnotrunning=%s", (assume_states_during_notrunning == TRUE) ? "yes" : "no");
