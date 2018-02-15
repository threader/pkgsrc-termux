$NetBSD: patch-src_cmd_5l_asm.c,v 1.1 2015/07/31 14:46:25 bsiegert Exp $

Support cgo on illumos.

--- src/cmd/5l/asm.c.orig	2014-12-11 01:18:10.000000000 +0000
+++ src/cmd/5l/asm.c
@@ -502,27 +502,8 @@ adddynsym(Link *ctxt, LSym *s)
 		adduint8(ctxt, d, t);
 		adduint8(ctxt, d, 0);
 
-		/* shndx */
-		if(s->type == SDYNIMPORT)
-			adduint16(ctxt, d, SHN_UNDEF);
-		else {
-			switch(s->type) {
-			default:
-			case STEXT:
-				t = 11;
-				break;
-			case SRODATA:
-				t = 12;
-				break;
-			case SDATA:
-				t = 13;
-				break;
-			case SBSS:
-				t = 14;
-				break;
-			}
-			adduint16(ctxt, d, t);
-		}
+		/* shndx; see dodynsym(). */
+		adduint16(ctxt, d, SHN_UNDEF);
 	} else {
 		diag("adddynsym: unsupported binary format");
 	}
