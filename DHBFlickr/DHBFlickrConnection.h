//
//  DHBFlickrConnection.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHBFlickrConnection : NSObject

+(void)requestPublicPhotosWithCompletionHandler:(void (^)(NSArray *images, NSError* error))handler;

@end
