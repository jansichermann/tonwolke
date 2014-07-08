#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "TWConstants.h"



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
    
    
    if ([urlAbsString rangeOfString:[self.class _authCallbackUrlString]].location != NSNotFound) {
        
        NSString *code = [self.class _codeFromUrlString:urlAbsString];
        NSString *accessToken = [self.class _accessTokenFromUrlString:urlAbsString];
        
    }
    return NO;
}

- (void)showWelcome {
    self.window.rootViewController = [[WelcomeViewController alloc] init];
}

+ (NSString *)_authCallbackUrlString {
    NSString *scheme = [self _appUriScheme];
    return scheme ? [scheme stringByAppendingFormat:@"://%@", kCallBackPath] : nil;
}

+ (NSString *)_appUriScheme {
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
    
    return schemes.firstObject; //returns nil if schemes.count == 0
}

+ (NSString *)_codeFromUrlString:(NSString *)urlString {
    NSString *code = nil;
    
    NSMutableCharacterSet *cs = [[NSMutableCharacterSet alloc] init];
    [cs addCharactersInString:@"?#&"];
    NSArray *comps = [urlString componentsSeparatedByCharactersInSet:cs.copy];
    
    for (NSString *comp in comps) {
        NSString *codeSearchString = @"code=";
        NSRange codeRange = [comp rangeOfString:codeSearchString];
        
        if (codeRange.location != NSNotFound) {
            code = [comp substringFromIndex:codeRange.location + codeSearchString.length];
        }
    }
    
    return code;
}

+ (NSString *)_accessTokenFromUrlString:(NSString *)urlString {
    NSString *accessToken = nil;
    
    NSMutableCharacterSet *cs = [[NSMutableCharacterSet alloc] init];
    [cs addCharactersInString:@"?#&"];
    NSArray *comps = [urlString componentsSeparatedByCharactersInSet:cs.copy];
    
    NSString *accessTokenSearchString = @"access_token=";
    for (NSString *comp in comps) {
        
        NSRange accessTokenRange = [comp rangeOfString:accessTokenSearchString];
        if (accessTokenRange.location != NSNotFound) {
            accessToken = [comp substringFromIndex:accessTokenRange.location + accessTokenRange.length];
        }
    }
    
    return accessToken;
}

@end
