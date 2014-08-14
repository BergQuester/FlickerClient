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

+(void)requestPublicPhotosWithCompletionHandler:(void (^)(NSArray *images, NSError* error))handler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[flickrServer stringByAppendingString:@"/services/feeds/photos_public.gne?lang=en-us&format=json&nojsoncallback=1"]]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError = nil;
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (!parsedData)
            {
                if ([parseError code] == 3840) {    // server sent back an invalid escape sequence, automatically try again.
                                                    // If I had access to the server code, I'd just fix this.
                    [DHBFlickrConnection requestPublicPhotosWithCompletionHandler:handler];
                }
                else if (handler) {
                    handler(nil, parseError);
                }
                return;
            }
            
            NSArray *items = [parsedData valueForKey:@"items"];
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[items count]];
            
            for (NSDictionary *image in items) {
                DHBFlickrImage *imageModel = [DHBFlickrImage imageWithMediaURL:[NSURL URLWithString:[[image valueForKey:@"media"] valueForKey:@"m"]]
                                                                       linkURL:[NSURL URLWithString:[image valueForKey:@"link"]]
                                                                        author:[image valueForKey:@"author"]];
                
                [images addObject:imageModel];
            }
            
            if (handler)
                handler([NSArray arrayWithArray:images], nil);
        }
        else {
            if (handler)
                handler(nil, connectionError);
        }

    }];
}

+(void)requestCommentsForImageWithID:(long long)imageID completionHandler:(void (^)(NSArray *comments, NSError* error))handler
{
//    imageID = 14905480873;    // photo with comments to test with
    NSString *requestURLString = [NSString stringWithFormat:@"%@/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%lld&format=json&nojsoncallback=1", flickrServer, flickrAPIKey, imageID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
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
                                   
                                   if (handler)
                                       handler(comments, nil);
                               }
                               else {
                                   if (handler)
                                       handler(nil, connectionError);
                               }
                           }];

}

@end
