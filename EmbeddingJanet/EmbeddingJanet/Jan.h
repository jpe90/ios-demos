#include "janet.h"

void
janny() {
    janet_init();

    // Get the core janet environment. This contains all of the C functions in the
    // core as well as the code in src/boot/boot.janet.
    JanetTable *env = janet_core_env(NULL);

    janet_dostring(env, "(print \"Hello from Janet!\")", "main", NULL);
    // load file test.janet
    janet_dostring(env, "(dofile \"server.janet\")", "main", NULL);

    // Use this to free all resources allocated by Janet.
    janet_deinit();
}
