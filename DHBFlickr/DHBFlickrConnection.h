//
//  DHBFlickrConnection.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHBFlickrConnection : NSObject

// Request a list of public photos from Flickr
// Calls a block that takes an arry of DHBFlickrImage objects or an error
+(void)requestPublicPhotosWithCompletionHandler:(void (^)(NSArray *images, NSError* error))handler;

// Request the comments for a given photo
// Calls a block that takes an arry of DHBFlickrComment objects or an error
+(void)requestCommentsForImageWithID:(long long)imageID completionHandler:(void (^)(NSArray *comments, NSError* error))handler;

@end
