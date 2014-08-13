//
//  DHBFlickrConnection.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import "DHBFlickrConnection.h"
#import "DHBFlickrImage.h"

@implementation DHBFlickrConnection

+(void)requestPublicPhotosWithCompletionHandler:(void (^)(NSArray *images, NSError* error))handler;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/feeds/photos_public.gne?lang=en-us&format=json&nojsoncallback=1"]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError = nil;
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (!parsedData)
            {
                if (handler)
                    handler(nil, parseError);
                return;
            }
            
            NSArray *items = [parsedData valueForKey:@"items"];
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[items count]];
            
            for (NSDictionary *image in items) {
                DHBFlickrImage *imageModel = [DHBFlickrImage imageWithMediaURL:[[image valueForKey:@"media"] valueForKey:@"m"]
                                                                       linkURL:[image valueForKey:@"link"]
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

@end
