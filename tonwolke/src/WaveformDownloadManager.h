#import <Foundation/Foundation.h>



/**
 Created by jan on 7/14/14.Copyright (c) 2014 Jan Sichermann. All rights reserved.
 
 The mandate of this class is to download, scale, and cache waveforms.
 In its current implementation it scales images to a max width of the main screen in width.

 There's an implicit and non-binding usage recommendation that there only be one instance of this. Technically speaking, one could allocate multiple instances, however, each would make its own request for each image, and maintain its own cache.
 It is, however, deliberately not a singleton.
 */


extern NSString *downloadWaveFormNotificationKey;

@interface WaveformDownloadManager : NSObject

/**
 Designated Initializer
 */
+ (instancetype)withSession:(NSURLSession *)session;

/**
 The notification key to which to subscribe in order to receive an update on the completion of the image download. This will fire on the defaultCenter instance of NSNotificationCenter.
 */
+ (NSString *)notificationKeyForUrlString:(NSString *)urlString;
@end
