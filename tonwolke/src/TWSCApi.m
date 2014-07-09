#import "TWSCApi.h"
#import "KeychainManager+TW.h"



static NSString * const meActivitiesEndpoint = @"https://api.soundcloud.com/me/activities.json";


@implementation TWSCApi

+ (void)meActivitiesWithCursor:(NSString *)cursor
             completionHandler:(SCApiCompletionHandler)handler {
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLRequest *r =
    [self.class authorizedGetRequestWithUrlString:cursor ? cursor : meActivitiesEndpoint];
    
    NSURLSessionTask *t = [session dataTaskWithRequest:r.copy
                                     completionHandler:
                           ^(NSData *data,
                             __unused NSURLResponse *response,
                            NSError *error) {
                               
                               if (error) {
                                   handler(nil, error);
                                   return;
                               }
                               
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                   NSError *err = nil;
                                   NSDictionary *responseDict =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&err];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       handler(responseDict[@"collection"], err);
                                   });
                               });
                           }];
    [t resume];
}

+ (NSURLRequest *)authorizedGetRequestWithUrlString:(NSString *)urlString {
    NSString *token = [KeychainManager token];
    
    NSMutableURLRequest *r =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:urlString]];
    
    [r setValue:[NSString stringWithFormat:@"OAuth %@", token]
forHTTPHeaderField:@"Authorization"];

    [r setValue:@"gzip"
         forHTTPHeaderField:@"Accept-Encoding"];
    
    [r setHTTPMethod:@"GET"];

    // given that method != POST, we can pipeline multiple connections
    [r setHTTPShouldUsePipelining:YES];
    
    return r.copy;
}

@end
