#import "TWSCApi.h"
#import "KeychainManager+TW.h"
#import "Track.h"
#import "NSDictionary+JS.h"



static NSString * const meActivitiesEndpoint = @"https://api.soundcloud.com/me/activities.json";


@implementation TWSCApi



+ (void)meActivitiesWithCursor:(NSString *)cursor
             completionHandler:(SCApiCompletionHandler)handler {
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLRequest *r =
    [self.class authorizedGetRequestWithUrlString:cursor ? cursor : meActivitiesEndpoint];
    
    NSURLSessionTask *t =
    [session dataTaskWithRequest:r.copy
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
             NSArray *collection = responseDict[@"collection"];
             NSArray *tracks = [self.class _parsedTracksFromCollection:collection];

             
             dispatch_async(dispatch_get_main_queue(), ^{
                 handler(tracks, err);
             });
         });
     }];
    
    [t resume];
}

+ (NSArray *)_parsedTracksFromCollection:(NSArray *)collection {
    if (!collection
        || ![collection isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:collection.count];
    
    for (NSDictionary *trackDict in collection) {
        
        if (trackDict
            && [trackDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *originDict = trackDict[@"origin"];
            if (originDict) {
                Track *t = [Track withDictionary:originDict];
                [tracks addObject:t];
            }
        }
        
    }
    
    return tracks.copy;
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
