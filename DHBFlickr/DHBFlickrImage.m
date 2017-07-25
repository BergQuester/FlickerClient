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
@property (readwrite,retain) NSString *author;
@property (readwrite,retain) UIImage *thumbnail;

@end

@implementation DHBFlickrImage

+(instancetype)imageWithMediaURL:(NSURL*)mediaURL id:(long long)id author:(NSString*)author
{
    DHBFlickrImage *image = [[[self class] alloc] init];
    image.mediaURL = mediaURL;
    image.photoID = id;
    image.author = author;
    
    
    return image;
}

+(instancetype)imageWithDictionary:(NSDictionary*)imageDictionary
{
    DHBFlickrImage *image = [DHBFlickrImage imageWithMediaURL:[NSURL URLWithString:[imageDictionary valueForKey:@"url_q"]]
                                                           id:[[imageDictionary valueForKey:@"id"] longLongValue]
                                                       author:[imageDictionary valueForKey:@"ownername"]];
    
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
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               
                               if (data)
                               {
                                   weakSelf.thumbnail = [UIImage imageWithData:data];
                                   if (handler) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           handler(weakSelf, nil);
                                       });
                                   }
                               }
                               else
                               {
                                   if (handler) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           handler(weakSelf, error);
                                       });
                                   }
                               }
                           }] resume];
}

@end
