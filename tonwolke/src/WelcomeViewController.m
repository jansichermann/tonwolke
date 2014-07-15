#import "WelcomeViewController.h"

#import "AppDelegate.h"
#import "JSButton.h"
#import "NSString+JS.h"
#import "TWConstants.h"
#import "UIView+JS.h"
#import "UIColor+TWSC.h"


@interface WelcomeViewController ()

@end



@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSButton *b = [JSButton buttonWithType:UIButtonTypeCustom];
    b.backgroundColor = [UIColor TWSCBackgroundColor];
    [b setTitle:@"Login via Soundcloud"
       forState:UIControlStateNormal];
    
    b.frame = CGRectMake(10.f,
                         self.view.height - 66.f,
                         self.view.width - 20.f,
                         44.f);
    [self.view addSubview:b];
    [b centerVerticallyInSuperview];
    
    NSString *callbackUrlEncoded = [[AppDelegate authCallbackUrlString] urlEncoded];
    
    b.touchUpInsideBlock = ^(__unused JSButton *bb) {
        NSURL *authUrl =
        [NSURL URLWithString:
         [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code_and_token&scope=non-expiring",
          kConnectUrl,
          kAppId,
          callbackUrlEncoded
          ]
         ];
        [[UIApplication sharedApplication] openURL:authUrl];
    };
}

@end