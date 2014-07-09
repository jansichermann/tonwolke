#import <Foundation/Foundation.h>



/**
 Created by jan on 7/9/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */


typedef void(^SCApiCompletionHandler)(NSArray *objects, NSError *error);


@interface TWSCApi : NSObject

+ (void)meActivitiesWithCursor:(NSString *)cursor
             completionHandler:(SCApiCompletionHandler)handler;

@end
