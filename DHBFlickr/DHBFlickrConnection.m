//
//  DHBFlickrConnection.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

NSString* const flickrAPIKey = @"f4b89e8c2ad607d51323cdc6d18d11b5";
NSString* const flickrServer = @"https://api.flickr.com";


#import "DHBFlickrConnection.h"
#import "DHBFlickrImage.h"
#import "DHBFlickrComment.h"

@implementation DHBFlickrConnection

+(void)requestPublicPhotosWithPage:(NSUInteger)pageNumber completionHandler:(void (^)(NSArray *images, NSError* error))handler
{
    NSString *URLString = [NSString stringWithFormat:@"%@/services/rest/?method=flickr.photos.getRecent&page=%ld&per_page=20&api_key=%@&extras=owner_name%%2C+url_q&format=json&nojsoncallback=1", flickrServer, (unsigned long)pageNumber, flickrAPIKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *parseError = nil;
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (!parsedData)
            {
                if ([parseError code] == 3840) {    // server sent back an invalid escape sequence, automatically try again.
                                                    // If I had access to the server code, I'd just fix this.
                    [DHBFlickrConnection requestPublicPhotosWithPage:pageNumber completionHandler:handler];
                }
                else if (handler) {
                    handler(nil, parseError);
                }
                return;
            }
            
            NSArray *items = [[parsedData valueForKey:@"photos"] valueForKey:@"photo"];
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[items count]];
            
            for (NSDictionary *image in items) {
                DHBFlickrImage *imageModel = [DHBFlickrImage imageWithDictionary:image];
                
                [images addObject:imageModel];
            }
            
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler([NSArray arrayWithArray:images], nil);
                });
                
            }
        }
        else {
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, error);
                });
            }
        }

    }] resume];
}

+(void)requestCommentsForImageWithID:(long long)imageID completionHandler:(void (^)(NSArray *comments, NSError* error))handler
{
//    imageID = 14905480873;    // photo with comments to test with
    NSString *requestURLString = [NSString stringWithFormat:@"%@/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%lld&format=json&nojsoncallback=1", flickrServer, flickrAPIKey, imageID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               
                               if (data) {
                                   NSError *parseError = nil;
                                   NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                   
                                   if (!parsedData)
                                   {
                                       if (handler) {
                                           handler(nil, parseError);
                                       }
                                       NSLog(@"Error: %@", parseError);
                                       return;
                                   }
                                   
                                   NSMutableArray *comments = [NSMutableArray array];
                                   
                                   for (NSDictionary *comment in parsedData[@"comments"][@"comment"])
                                   {
                                       DHBFlickrComment *commentModel = [DHBFlickrComment comment:comment[@"_content"] withAuthor:comment[@"authorname"]];
                                       [comments addObject:commentModel];
                                   }
                                   
                                   if (handler) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           handler(comments, nil);
                                       });
                                   }
                               }
                               else {
                                   if (handler) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           handler(nil, error);
                                       });
                                   }
                               }
                           }] resume];

}

@end
