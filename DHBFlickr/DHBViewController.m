//
//  DHBViewController.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import "DHBViewController.h"
#import "DHBFlickrConnection.h"
#import "DHBFlickrImage.h"

NSInteger const DHBImageViewTag = 1;

@interface DHBViewController ()

@property (readwrite,retain)NSArray *images;

@end

@implementation DHBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self load:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)load:(id)sender {
    [DHBFlickrConnection requestPublicPhotosWithCompletionHandler:^(NSArray *images, NSError *error) {
        
        if (images)
        {
            // Instruct the images to start loading their thumbnails
            for (DHBFlickrImage *image in images)
            {
                __weak DHBViewController *weakSelf = self;
                [image loadThumbnailWithCompletionHandler:^(DHBFlickrImage *flickrImage, NSError *error) {
                    
                    if (flickrImage.thumbnail) {
                        
                        NSUInteger imageIndex = [weakSelf.images indexOfObject:flickrImage];
                        if (imageIndex != NSNotFound) {
                            [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:imageIndex inSection:0]]];
                        }
                            
                    } else {
                        NSLog(@"Error loading photo %lld: %@", flickrImage.photoID, error.debugDescription);
                    }
                    
                }];
            }
            self.images = images;
            
            [self.collectionView reloadData];
        }
        else
        {
            // TODO: Should have a more user-friendly error
            [[[UIAlertView alloc] initWithTitle:@"Error loading images"
                                        message:error.debugDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}


#pragma makr Collection view datasource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"flickr.photoThumbnail"
                                                                                   forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[newCell viewWithTag:DHBImageViewTag];
    UIImage *thumbnail = [(DHBFlickrImage*)[self.images objectAtIndex:indexPath.item] thumbnail];
    [imageView setImage:thumbnail];
    
    return newCell;
}


@end
