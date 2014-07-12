#import <UIKit/UIKit.h>



/**
 Created by jan on 7/8/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (NSString *)authCallbackUrlString;
+ (NSString *)appUriScheme;
- (void)logoutWithMessage:(NSString *)message;
@end
