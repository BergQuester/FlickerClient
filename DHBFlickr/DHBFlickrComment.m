//
//  DHBFlickrComment.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/13/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import "DHBFlickrComment.h"

@interface DHBFlickrComment ()

@property (readwrite,retain) NSString *authorName;
@property (readwrite,retain) NSString *content;

@end

@implementation DHBFlickrComment

+ (instancetype)comment:(NSString*)content withAuthor:(NSString*)authorName
{
    DHBFlickrComment *commentModel = [[[self class] alloc] init];
    
    [commentModel setAuthorName:authorName];
    [commentModel setContent:content];
    
    return commentModel;
}


@end
