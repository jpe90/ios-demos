//
//  main.m
//  EmbeddingLua
//
//  Created by Jon on 5/1/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "lprefix.h"
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static void
l_message (const char *pname, const char *msg) {
    if (pname) lua_writestringerror("%s: ", pname);
    lua_writestringerror("%s\n", msg);
}

void
check_result(lua_State *L, int result)
{
    if (result != LUA_OK) {
        const char* errorMsg = lua_tostring(L, -1);
        NSLog(@"Error loading Lua file: %s", errorMsg);
        lua_pop(L, 1);
        lua_close(L);
        exit(EXIT_FAILURE);
    }
}


bool
lua_path_add(lua_State *L, const char *path)
{
    if (!L || !path)
        return false;
    lua_getglobal(L, "package");
    lua_pushstring(L, path);
    lua_pushstring(L, "/?.lua;");
    lua_getfield(L, -3, "path");
    lua_concat(L, 3);
    lua_setfield(L, -2, "path");
    lua_pop(L, 1); /* package */
    return true;
}



int
main (int argc, char **argv) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }

    int status, result;
    lua_State *L = luaL_newstate();
    if (L == NULL) {
        l_message(argv[0], "cannot create state: not enough memory");
        return EXIT_FAILURE;
    }
    luaL_openlibs(L); // Enable standard Lua libraries

    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];

    // get resourcePath as a cstring
    const char* cResourcePath = [resourcePath UTF8String];

    lua_path_add(L, cResourcePath);

    lua_getglobal(L, "require");
    lua_pushstring(L, "myscript");

    result = lua_pcall(L, 1, 1, 0);
    check_result(L, result);

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);

}
