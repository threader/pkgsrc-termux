$NetBSD: patch-audio_audio.c,v 1.1 2017/12/14 08:01:10 adam Exp $

Avoid conflicts with SSP read() macro in NetBSD's <ssp/unistd.h>
(PR lib/43832: ssp causes common names to be defines)

--- audio/audio.c.orig	2016-09-02 15:34:17.000000000 +0000
+++ audio/audio.c
@@ -1156,7 +1156,7 @@ int AUD_read (SWVoiceIn *sw, void *buf, 
         return 0;
     }
 
-    return sw->hw->pcm_ops->read(sw, buf, size);
+    return (sw->hw->pcm_ops->read)(sw, buf, size);
 }
 
 int AUD_get_buffer_size_out (SWVoiceOut *sw)
