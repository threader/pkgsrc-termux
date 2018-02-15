$NetBSD: patch-src_screen.cpp,v 1.2 2017/10/30 11:45:14 jperkin Exp $

Work around NetBSD curses.

--- src/screen.cpp.orig	2017-06-03 12:45:13.000000000 +0000
+++ src/screen.cpp
@@ -215,7 +215,7 @@ static bool is_color_escape_seq(const wc
 
     // Detect these terminfo color escapes with parameter value up to max_colors, all of which
     // don't move the cursor.
-    char *const esc[] = {
+    const char *const esc[] = {
         set_a_foreground, set_a_background, set_foreground, set_background,
     };
 
@@ -223,7 +223,11 @@ static bool is_color_escape_seq(const wc
         if (!esc[p]) continue;
 
         for (int k = 0; k < max_colors; k++) {
+#ifdef __NetBSD__
             size_t esc_seq_len = try_sequence(tparm(esc[p], k), code);
+#else
+            size_t esc_seq_len = try_sequence(tparm((char *)esc[p], k), code);
+#endif
             if (esc_seq_len) {
                 *resulting_length = esc_seq_len;
                 return true;
@@ -238,7 +242,7 @@ static bool is_color_escape_seq(const wc
 /// displayed other than the color.
 static bool is_visual_escape_seq(const wchar_t *code, size_t *resulting_length) {
     if (!cur_term) return false;
-    char *const esc2[] = {
+    const char *const esc2[] = {
         enter_bold_mode,      exit_attribute_mode,    enter_underline_mode,  exit_underline_mode,
         enter_standout_mode,  exit_standout_mode,     flash_screen,          enter_subscript_mode,
         exit_subscript_mode,  enter_superscript_mode, exit_superscript_mode, enter_blink_mode,
@@ -251,7 +255,11 @@ static bool is_visual_escape_seq(const w
         if (!esc2[p]) continue;
         // Test both padded and unpadded version, just to be safe. Most versions of tparm don't
         // actually seem to do anything these days.
+#ifdef __NetBSD__
         size_t esc_seq_len = maxi(try_sequence(tparm(esc2[p]), code), try_sequence(esc2[p], code));
+#else
+        size_t esc_seq_len = maxi(try_sequence(tparm((char *)esc2[p]), code), try_sequence(esc2[p], code));
+#endif
         if (esc_seq_len) {
             *resulting_length = esc_seq_len;
             return true;
@@ -506,7 +514,7 @@ static void s_move(screen_t *s, data_buf
     int i;
     int x_steps, y_steps;
 
-    char *str;
+    const char *str;
     /*
       debug( 0, L"move from %d %d to %d %d",
       s->screen_cursor[0], s->screen_cursor[1],
@@ -540,7 +548,7 @@ static void s_move(screen_t *s, data_buf
         x_steps = 0;
     }
 
-    char *multi_str = NULL;
+    const char *multi_str = NULL;
     if (x_steps < 0) {
         str = cursor_left;
         multi_str = parm_left_cursor;
@@ -554,7 +562,11 @@ static void s_move(screen_t *s, data_buf
     bool use_multi =
         multi_str != NULL && multi_str[0] != '\0' && abs(x_steps) * strlen(str) > strlen(multi_str);
     if (use_multi && cur_term) {
+#ifdef __NetBSD__
         char *multi_param = tparm(multi_str, abs(x_steps));
+#else
+        char *multi_param = tparm((char *)multi_str, abs(x_steps));
+#endif
         writembs(multi_param);
     } else {
         for (i = 0; i < abs(x_steps); i++) {
@@ -594,7 +606,7 @@ static void s_write_char(screen_t *s, da
 }
 
 /// Send the specified string through tputs and append the output to the specified buffer.
-static void s_write_mbs(data_buffer_t *b, char *s) {
+static void s_write_mbs(data_buffer_t *b, const char *s) {
     scoped_buffer_t scoped_buffer(b);
     writembs(s);
 }
