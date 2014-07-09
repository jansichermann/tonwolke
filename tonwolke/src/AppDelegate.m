#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "TWConstants.h"
#import "AuthTokenParser.h"
#import "KeychainManager+TW.h"
#import "JSAlertView.h"
#import "StreamTableViewController.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self showWelcome];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString *urlAbsString = url.absoluteString;
    
    
    if ([urlAbsString rangeOfString:[self.class authCallbackUrlString]].location != NSNotFound) {
        
        NSString *accessToken = [AuthTokenParser accessTokenFromUrlString:urlAbsString];
        if (accessToken) {
            
            [KeychainManager setToken:accessToken];
            [self showMain];
        }
        else {
            [self logoutWithMessage:@"An error occured!"];
        }
    }
    return NO;
}

- (void)logoutWithMessage:(NSString *)message {
    [[JSAlertView withTitle:message
                    message:nil
     jsAlertViewButtonItems:@[
                              [JSAlertViewButtonItem withTitle:@"Ok"
                                                  onClickBlock:nil]
                              ]
      ] show];
    
    [self showWelcome];
}

- (void)showMain {
    self.window.rootViewController = [[StreamTableViewController alloc] init];
}

- (void)showWelcome {
    self.window.rootViewController = [[WelcomeViewController alloc] init];
}

+ (NSString *)authCallbackUrlString {
    NSString *scheme = [self appUriScheme];
    return scheme ? [scheme stringByAppendingFormat:@"://%@", kCallBackPath] : nil;
}

+ (NSString *)appUriScheme {
    NSArray *a = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if (!a || ![a isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSDictionary *urlDict = a.firstObject;
    if (!urlDict || ![urlDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSArray *schemes = [urlDict objectForKey:@"CFBundleURLSchemes"];
    if (!schemes || ![schemes isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return schemes.firstObject;
}

@end
