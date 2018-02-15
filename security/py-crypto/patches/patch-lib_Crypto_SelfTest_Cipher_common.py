$NetBSD: patch-lib_Crypto_SelfTest_Cipher_common.py,v 1.2 2017/03/08 01:09:00 sevan Exp $

CVE-2013-7459 backport
https://github.com/dlitz/pycrypto/commit/8dbe0dc3eea5c689d4f76b37b93fe216cf1f00d4

--- lib/Crypto/SelfTest/Cipher/common.py.orig	2017-03-07 16:48:08.000000000 +0000
+++ lib/Crypto/SelfTest/Cipher/common.py
@@ -239,19 +239,33 @@ class RoundtripTest(unittest.TestCase):
         return """%s .decrypt() output of .encrypt() should not be garbled""" % (self.module_name,)
 
     def runTest(self):
-        for mode in (self.module.MODE_ECB, self.module.MODE_CBC, self.module.MODE_CFB, self.module.MODE_OFB, self.module.MODE_OPENPGP):
+        ## ECB mode
+        mode = self.module.MODE_ECB
+        encryption_cipher = self.module.new(a2b_hex(self.key), mode)
+        ciphertext = encryption_cipher.encrypt(self.plaintext)
+        decryption_cipher = self.module.new(a2b_hex(self.key), mode)
+        decrypted_plaintext = decryption_cipher.decrypt(ciphertext)
+        self.assertEqual(self.plaintext, decrypted_plaintext)
+
+        ## OPENPGP mode
+        mode = self.module.MODE_OPENPGP
+        encryption_cipher = self.module.new(a2b_hex(self.key), mode, self.iv)
+        eiv_ciphertext = encryption_cipher.encrypt(self.plaintext)
+        eiv = eiv_ciphertext[:self.module.block_size+2]
+        ciphertext = eiv_ciphertext[self.module.block_size+2:]
+        decryption_cipher = self.module.new(a2b_hex(self.key), mode, eiv)
+        decrypted_plaintext = decryption_cipher.decrypt(ciphertext)
+        self.assertEqual(self.plaintext, decrypted_plaintext)
+
+        ## All other non-AEAD modes (but CTR)
+        for mode in (self.module.MODE_CBC, self.module.MODE_CFB, self.module.MODE_OFB):
             encryption_cipher = self.module.new(a2b_hex(self.key), mode, self.iv)
             ciphertext = encryption_cipher.encrypt(self.plaintext)
-            
-            if mode != self.module.MODE_OPENPGP:
-                decryption_cipher = self.module.new(a2b_hex(self.key), mode, self.iv)
-            else:
-                eiv = ciphertext[:self.module.block_size+2]
-                ciphertext = ciphertext[self.module.block_size+2:]
-                decryption_cipher = self.module.new(a2b_hex(self.key), mode, eiv)
+            decryption_cipher = self.module.new(a2b_hex(self.key), mode, self.iv)
             decrypted_plaintext = decryption_cipher.decrypt(ciphertext)
             self.assertEqual(self.plaintext, decrypted_plaintext)
 
+
 class PGPTest(unittest.TestCase):
     def __init__(self, module, params):
         unittest.TestCase.__init__(self)
