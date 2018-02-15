$NetBSD: patch-src_lua.c,v 1.2 2017/11/21 15:18:23 fhajny Exp $

Make it possible to register more than one reader/writer.
Upstream request: https://github.com/collectd/collectd/pull/2379

--- src/lua.c.orig	2017-11-18 09:03:27.358750191 +0000
+++ src/lua.c
@@ -281,9 +281,6 @@ static int lua_cb_register_read(lua_Stat
 
   luaL_checktype(L, 1, LUA_TFUNCTION);
 
-  char function_name[DATA_MAX_NAME_LEN];
-  snprintf(function_name, sizeof(function_name), "lua/%s", lua_tostring(L, 1));
-
   int callback_id = clua_store_callback(L, 1);
   if (callback_id < 0)
     return luaL_error(L, "%s", "Storing callback function failed");
@@ -298,6 +295,9 @@ static int lua_cb_register_read(lua_Stat
   if (cb == NULL)
     return luaL_error(L, "%s", "calloc failed");
 
+  char function_name[DATA_MAX_NAME_LEN];
+  snprintf(function_name, sizeof(function_name), "lua/%p", thread);
+
   cb->lua_state = thread;
   cb->callback_id = callback_id;
   cb->lua_function_name = strdup(function_name);
@@ -325,9 +325,6 @@ static int lua_cb_register_write(lua_Sta
 
   luaL_checktype(L, 1, LUA_TFUNCTION);
 
-  char function_name[DATA_MAX_NAME_LEN] = "";
-  snprintf(function_name, sizeof(function_name), "lua/%s", lua_tostring(L, 1));
-
   int callback_id = clua_store_callback(L, 1);
   if (callback_id < 0)
     return luaL_error(L, "%s", "Storing callback function failed");
@@ -342,6 +339,9 @@ static int lua_cb_register_write(lua_Sta
   if (cb == NULL)
     return luaL_error(L, "%s", "calloc failed");
 
+  char function_name[DATA_MAX_NAME_LEN];
+  snprintf(function_name, sizeof(function_name), "lua/%p", thread);
+
   cb->lua_state = thread;
   cb->callback_id = callback_id;
   cb->lua_function_name = strdup(function_name);
