//
//  main.m
//  EmbeddingJanet
//
//  Created by Jon on 5/1/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "janet.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"janet"];
    const char *cpath = [path cStringUsingEncoding:NSUTF8StringEncoding];

    NSString *eval_command = [NSString stringWithFormat:@"(dofile \"%s\")", cpath];
    const char *ceval_command = [eval_command cStringUsingEncoding:NSUTF8StringEncoding];

    janet_init();

    // Get the core janet environment. This contains all of the C functions in the
    // core as well as the code in src/boot/boot.janet.
    JanetTable *env = janet_core_env(NULL);

    janet_dostring(env, ceval_command, "main", NULL);

    // Use this to free all resources allocated by Janet.
    janet_deinit();

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
