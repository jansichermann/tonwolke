#import "JJSObject.h"



/**
 Created by jan on 7/12/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 
 A Model representing a Track.
 */



@interface Track : JJSObject
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *waveformUrl;
@property (nonatomic, readonly) NSString *permalinkUrl;
@property (nonatomic, readonly) NSString *objectId;
@end
