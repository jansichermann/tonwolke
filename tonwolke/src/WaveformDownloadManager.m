#import "WaveformDownloadManager.h"

#import "NSObject+JS.h"
#import "NSSet+JS.h"
#import "UIImage+JS.h"



NSString *downloadWaveFormNotificationKey = @"downloadWaveFormNotificationKey";



@interface WaveformDownloadManager ()

@property NSSet *inProgressDownloads;
@property NSCache *imageCache;

@end



@implementation WaveformDownloadManager

+ (instancetype)withSession:(NSURLSession *)session {
    WaveformDownloadManager *d = [[WaveformDownloadManager alloc] init];
    
    if (!session) {
        session =
        [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                      delegate:nil
                                 delegateQueue:[[NSOperationQueue alloc] init]];
    }
    
    d.imageCache = [[NSCache alloc] init];
    d.imageCache.totalCostLimit = 1024 * 1000;
    
    __weak WaveformDownloadManager *weakD = d;
    [self observeNotificationCenter:[NSNotificationCenter defaultCenter]
                                key:downloadWaveFormNotificationKey
                      withFireBlock:^(NSString *urlString) {
                          if (!urlString) {
                              return;
                          }
                          WaveformDownloadManager *strongD = weakD;
                          [strongD _requestWaveFormWithUrlString:urlString
                                                       inSession:session];
                      }];
    
    return d;
}


- (void)_requestWaveFormWithUrlString:(NSString *)urlString
                            inSession:(NSURLSession *)session {
    NSParameterAssert([NSThread currentThread].isMainThread);
    
    if (!urlString) {
        return;
    }
    if ([self.inProgressDownloads containsObject:urlString]) {
        return;
    }
    
    NSString *notificationKey = [self.class notificationKeyForUrlString:urlString];
    UIImage *cachedImage = [self.imageCache objectForKey:urlString];
    
    if (cachedImage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationKey
                                                            object:cachedImage];
        return;
    }
    
    self.inProgressDownloads =
    [self.inProgressDownloads setByAddingObject:urlString];
    
    __weak WaveformDownloadManager *weakSelf = self;
    
    NSURLSessionTask *t =
    [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
               completionHandler:^(NSData *data,
                                   __unused NSURLResponse *response,
                                   NSError *error) {
                   WaveformDownloadManager *strongSelf = weakSelf;
                   strongSelf.inProgressDownloads = [strongSelf.inProgressDownloads setByRemovingObject:urlString];
                   if (data && !error) {
                       [strongSelf _addWaveformData:data
                                       forUrlString:urlString];
                   }
               }];
    [t resume];
}

- (void)_addWaveformData:(NSData *)data
            forUrlString:(NSString *)urlString {
    NSParameterAssert(![NSThread currentThread].isMainThread);
    
    if (!data || !urlString) {
        return;
    }
    
    NSCache *cache = self.imageCache;
    NSString *notificationKey = [self.class notificationKeyForUrlString:urlString];
    
    UIImage *i = [UIImage imageWithData:data];
    UIImage *scaled = [i scaledToMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    NSUInteger byteSize = data.length; // approximation, as that is unscaled.
    [cache setObject:scaled
              forKey:urlString
                cost:byteSize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationKey
                                                            object:scaled];
    });
}

+ (NSString *)notificationKeyForUrlString:(NSString *)urlString {
    return [NSString stringWithFormat:@"WaveformDownloadFinishedKey__%@", urlString];
}


@end
