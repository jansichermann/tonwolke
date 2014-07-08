#import <Foundation/Foundation.h>



/**
 Created by jan on 7/8/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */



@interface AuthTokenParser : NSObject
+ (NSString *)codeFromUrlString:(NSString *)urlString;
+ (NSString *)accessTokenFromUrlString:(NSString *)urlString;
@end
