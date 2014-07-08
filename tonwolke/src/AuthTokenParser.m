#import "AuthTokenParser.h"

@implementation AuthTokenParser

+ (NSString *)_parseUrlString:(NSString *)urlString
              forValueFromKey:(NSString *)key {
    
    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {
        return nil;
    }
    
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return nil;
    }
    
    NSString *value = nil;
    
    NSMutableCharacterSet *cs = [[NSMutableCharacterSet alloc] init];
    [cs addCharactersInString:@"?#&"];
    NSArray *comps = [urlString componentsSeparatedByCharactersInSet:cs.copy];
    
    for (NSString *comp in comps) {
        NSString *searchString = [NSString stringWithFormat:@"%@=", key];
        NSRange searchRange = [comp rangeOfString:searchString];
        
        if (searchRange.location != NSNotFound) {
            value = [comp substringFromIndex:searchRange.location + searchString.length];
        }
    }
    
    return value.length > 0 ? value : nil;
}

+ (NSString *)codeFromUrlString:(NSString *)urlString {
    return [self _parseUrlString:urlString
                 forValueFromKey:@"code"];
}

+ (NSString *)accessTokenFromUrlString:(NSString *)urlString {
    return [self _parseUrlString:urlString
                 forValueFromKey:@"access_token"];
}

@end
