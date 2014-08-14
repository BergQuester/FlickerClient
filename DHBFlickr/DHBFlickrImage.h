//
//  DHBFlickrImage.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <Foundation/Foundation.h>

// DHBFlickrImage is a model object that represents a Flickr photo

@interface DHBFlickrImage : NSObject

// The Flickr photo ID
@property (readonly) long long photoID;

// The URL to the image thumbnail
@property (readonly,retain) NSURL *mediaURL;

// The URL to the image page
@property (readonly,retain) NSURL *linkURL;

// The user that posted the photo
@property (readonly,retain) NSString *author;

// The photo thumbnail
@property (readonly,retain) UIImage *thumbnail;

// Construct an photo with the given data
+(instancetype)imageWithMediaURL:(NSURL*)mediaURL linkURL:(NSURL*)linkURL author:(NSString*)author;

// Load the photo's thumbnail from the server
-(void)loadThumbnailWithCompletionHandler:(void (^)(DHBFlickrImage *flickrImage, NSError* error))handler;

@end
