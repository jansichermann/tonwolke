#import "KeychainManager.h"

static NSString * const keychainIdentifier = @"com.jansichermann.tonwolke";

@implementation KeychainManager

+ (NSMutableDictionary *)_searchDirectoryForIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary =
    [NSMutableDictionary dictionary];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword
                         forKey:(__bridge id)kSecClass];
    
    [searchDictionary setObject:keychainIdentifier
                         forKey:(__bridge id)kSecAttrService];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    [searchDictionary setObject:encodedIdentifier
                         forKey:(__bridge id)kSecAttrGeneric];
    
    [searchDictionary setObject:encodedIdentifier
                         forKey:(__bridge id)kSecAttrAccount];
    
    return searchDictionary;
}

+ (NSData *)_dataForKey:(NSString *)identifier {
    NSMutableDictionary *searchDictionary =
    [self _searchDirectoryForIdentifier:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne
                         forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue
                         forKey:(__bridge id)kSecReturnData];
    NSData *result = nil;
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary,
                                          &foundDict);
    
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    }
    else {
        result = nil;
    }
    
    return result;
}

+ (NSString *)stringForKey:(NSString *)identifier {
    NSData *valueData = [self _dataForKey:identifier];
    
    return valueData ?
    [[NSString alloc] initWithData:valueData
                          encoding:NSUTF8StringEncoding] :
    nil;
}

+ (BOOL)updateString:(NSString *)string
              forKey:(NSString *)key {
    
    NSMutableDictionary *searchDictionary =
    [self _searchDirectoryForIdentifier:key];
    
    NSMutableDictionary *updateDictionary =
    [NSMutableDictionary dictionary];
    
    NSData *valueData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
    
    if (status == errSecSuccess) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)setString:(NSString *)string
           forKey:(NSString *)key {
    
    NSMutableDictionary *dictionary =
    [self _searchDirectoryForIdentifier:key];
    
    NSData *valueData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    [dictionary setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                   forKey:(__bridge id)kSecAttrAccessible];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    else if (status == errSecDuplicateItem){
        return [self updateString:string
                           forKey:key];
    }
    else {
        return NO;
    }
}

+ (void)deleteItemForKey:(NSString *)identifier {
    NSMutableDictionary *searchDictionary =
    [self _searchDirectoryForIdentifier:identifier];
    
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)searchDictionary;
    SecItemDelete(dictionary);
}

@end
