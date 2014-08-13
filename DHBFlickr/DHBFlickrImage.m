//
//  DHBFlickrImage.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import "DHBFlickrImage.h"

@interface DHBFlickrImage ()

@property (readwrite) long long photoID;
@property (readwrite,retain) NSURL *mediaURL;
@property (readwrite,retain) NSURL *linkURL;
@property (readwrite,retain) NSString *author;
@property (readwrite,retain) UIImage *thumbnail;

@end

@implementation DHBFlickrImage

+(instancetype)imageWithMediaURL:(NSURL*)mediaURL linkURL:(NSURL*)linkURL author:(NSString*)author
{
    DHBFlickrImage *image = [[DHBFlickrImage alloc] init];
    image.mediaURL = mediaURL;
    image.linkURL = linkURL;
    image.author = author;
    
    // Not finding an entry for photo id, parse from the link URL
    NSArray *pathComponents = [linkURL pathComponents];
    long long photoID = [[pathComponents lastObject] longLongValue];
    
    if (photoID == 0)   // sometimes it's not the very last component
        photoID = [[pathComponents objectAtIndex:[pathComponents count] - 2] longLongValue];
    
    image.photoID = photoID;
    
    return image;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"imageID: %lld, author: %@ mediaURL: %@ linkURL: %@ thumbnail: %@", self.photoID, self.author, self.mediaURL, self.linkURL, self.thumbnail];
}

-(void)loadThumbnailWithCompletionHandler:(void (^)(DHBFlickrImage *flickrImage, NSError* error))handler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.mediaURL];
    
    __weak DHBFlickrImage *weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (data)
                               {
                                   weakSelf.thumbnail = [UIImage imageWithData:data];
                                   if (handler)
                                       handler(weakSelf, nil);
                               }
                               else
                               {
                                   if (handler)
                                       handler(weakSelf, connectionError);
                               }
                           }];
}

@end
