#import "KeychainManager+TW.h"
#import "KeychainManager.h"



@implementation KeychainManager (TW)

static NSString const *tokenKey = @"accessTokenKey";

+ (NSString *)token {
    return [KeychainManager stringForKey:(NSString *)tokenKey];
}

+ (void)setToken:(NSString *)token {
    if (!token) {
        [KeychainManager deleteItemForKey:(NSString *)tokenKey];
    }
    else {
        [KeychainManager setString:token
                            forKey:(NSString *)tokenKey];
    }
}

@end
