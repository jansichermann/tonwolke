#import <Foundation/Foundation.h>



/**
 Created by jan on 5/3/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */



@interface KeychainManager : NSObject

+ (BOOL)setString:(NSString *)string
           forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)identifier;
+ (void)deleteItemForKey:(NSString *)identifier;

@end
