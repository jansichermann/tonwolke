#import "KeychainManager.h"



/**
 Created by jan on 7/8/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */



@interface KeychainManager (TW)
+ (NSString *)token;
+ (void)setToken:(NSString *)token;
@end
