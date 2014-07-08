#import "AppDelegate.h"
#import "AuthViewController.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self showAuth];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    return NO;
    
}

- (void)showAuth {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://soundcloud.com/connect?client_id=8b067895a0bda9b1fcdeaed3b8cedb32&redirect_uri=tonwolke%3A%2F%2Fsoundcloud%2Fcallback&response_type=code_and_token&scope=non-expiring"]];
}

@end
