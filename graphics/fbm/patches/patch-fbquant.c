$NetBSD: patch-fbquant.c,v 1.1 2013/02/26 11:13:22 joerg Exp $

--- fbquant.c.orig	2013-02-25 17:09:23.000000000 +0000
+++ fbquant.c
@@ -131,6 +131,10 @@ int fr = 250, fg = 150, fb = 80;
 
 int outtype = DEF_8BIT;	/* Output format desired */
 
+static void clr_quantize (FBM *input, FBM *output, COLOR *cmap, int colors);
+static void split_box (PIXEL *box, int boxlen, int clr, int numclr, COLOR *cmap);
+static void load_config (char *filenm);
+
 /****************************************************************
  * main
  ****************************************************************/
@@ -319,8 +323,7 @@ char *argv[];
  * load_config: Read a series of fixed/ignore color settings from a file
  ****************************************************************/
 
-load_config (filenm)
-char *filenm;
+static void load_config (char *filenm)
 { FILE *infile = NULL;
   char buf[BUFSIZ];
   int aindx, ard, agr, abl;	/* Get 'i' arguments from sscanf */
@@ -530,10 +533,7 @@ COLOR *cmap;
  *	      algorithm.
  ****************************************************************/
 
-split_box (box, boxlen, clr, numclr, cmap)
-PIXEL *box;
-int boxlen, clr, numclr;
-COLOR *cmap;
+static void split_box (PIXEL *box, int boxlen, int clr, int numclr, COLOR *cmap)
 { int maxv[3], minv[3], numv[3];
   int pcnt[3][CUBSID];
   int sbox, snum, split, half, maxdif, dif;
@@ -841,10 +841,7 @@ PIXEL *a, *b;
  * clr_quantize: Do Floyd Steinberg quantizing on the image
  ****************************************************************/
 
-clr_quantize (input, output, cmap, colors, fmap, fixedcolors)
-FBM *input, *output;
-COLOR *cmap, *fmap;
-int colors, fixedcolors;
+static void clr_quantize (FBM *input, FBM *output, COLOR *cmap, int colors)
 { int **cerr, **lerr, **terr;
   int width = input->hdr.cols, height = input->hdr.rows;
   int rowlen = input->hdr.rowlen, plnlen = input->hdr.plnlen;
