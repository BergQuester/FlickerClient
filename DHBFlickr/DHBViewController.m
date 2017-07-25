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
#import "DHBCommentViewController.h"

NSInteger const DHBImageViewTag = 1;

@interface DHBViewController ()

// The images currently displayed
@property (readwrite,retain)NSArray *images;

@end

@implementation DHBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self load:nil];
}

// Loads several random public images from Flickr
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
                        // reload only that collection view cell
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error loading images"
                                                                           message:error.debugDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DHBFlickrImage *selectedImage = sender;
    [(DHBCommentViewController *)[[[segue destinationViewController] viewControllers] firstObject] setPhotoAuthorName:selectedImage.author];
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
    UIImage *thumbnail = [self.images[indexPath.item] thumbnail];
    [imageView setImage:thumbnail];
    
    return newCell;
}

#pragma makr Collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine the selected image, display comment view and fetch comments
    DHBFlickrImage *selectedImage = self.images[indexPath.item];
    [self performSegueWithIdentifier:@"comment" sender:selectedImage];
    
    DHBCommentViewController *commentViewController = (DHBCommentViewController *)[[(UINavigationController*)self.presentedViewController viewControllers] firstObject];

    [DHBFlickrConnection requestCommentsForImageWithID:selectedImage.photoID completionHandler:^(NSArray *comments, NSError *error) {
        commentViewController.comments = comments;
    }];
}


@end
