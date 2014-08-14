//
//  DHBFlickrComment.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/13/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <Foundation/Foundation.h>

// DHBFlickrComment is a model object that represents a Flickr comment

@interface DHBFlickrComment : NSObject

// The comment's author
@property (readonly,retain) NSString *authorName;

// Comment's content
@property (readonly,retain) NSString *content;

// Creates a comment object with the given comment and author
+ (instancetype)comment:(NSString*)content withAuthor:(NSString*)authorName;

@end
