#import "AppDelegate.h"

#import "AuthTokenParser.h"
#import "JSAlertView.h"
#import "KeychainManager+TW.h"
#import "StreamTableViewController.h"
#import "TWConstants.h"
#import "UIColor+TWSC.h"
#import "WaveformDownloadManager.h"
#import "WelcomeViewController.h"



@interface AppDelegate ()
@property (nonatomic) WaveformDownloadManager *waveformDownloadManager;
@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self.class setAppearance];
    [KeychainManager token].length > 0 ? [self showMain] : [self showWelcome];
    
    self.waveformDownloadManager = [WaveformDownloadManager withSession:nil];
    
    return YES;
}

+ (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor TWSCBackgroundColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    [KeychainManager setToken:nil];
    
    if (message.length > 0) {
        [[JSAlertView withTitle:message
                        message:nil
         jsAlertViewButtonItems:
          @[
            [JSAlertViewButtonItem withTitle:@"Ok"
                                onClickBlock:nil]
            ]
          ] show];
    }
    
    [self showWelcome];
}

- (void)showMain {
    self.window.rootViewController =
    [[UINavigationController alloc] initWithRootViewController:[[StreamTableViewController alloc] init]];
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
