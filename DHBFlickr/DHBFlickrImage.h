//
//  DHBFlickrImage.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHBFlickrImage : NSObject

@property (readonly) long long photoID;
@property (readonly,retain) NSURL *mediaURL;
@property (readonly,retain) NSURL *linkURL;
@property (readonly,retain) NSString *author;
@property (readonly,retain) UIImage *thumbnail;

+(instancetype)imageWithMediaURL:(NSURL*)mediaURL linkURL:(NSURL*)linkURL author:(NSString*)author;

-(void)loadThumbnailWithCompletionHandler:(void (^)(DHBFlickrImage *flickrImage, NSError* error))handler;

@end
