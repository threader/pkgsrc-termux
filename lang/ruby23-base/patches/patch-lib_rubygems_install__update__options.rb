$NetBSD: patch-lib_rubygems_install__update__options.rb,v 1.1 2015/12/30 14:59:42 taca Exp $

* Add install_root option for pkgsrc's rubygems support.

--- lib/rubygems/install_update_options.rb.orig	2015-12-16 05:07:31.000000000 +0000
+++ lib/rubygems/install_update_options.rb
@@ -37,6 +37,12 @@ module Gem::InstallUpdateOptions
       value
     end
 
+    add_option(:"Install/Update", '-B', '--install-root DIR',
+               'Root directory for gem files on install') do |value, options|
+      options[:install_root] = File.expand_path(value)
+      Gem.ensure_gem_subdirectories File.join options[:install_root], Gem.dir
+    end
+
     add_option(:"Install/Update", '-i', '--install-dir DIR',
                'Gem repository directory to get installed',
                'gems') do |value, options|
