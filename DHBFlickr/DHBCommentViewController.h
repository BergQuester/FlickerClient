//
//  DHBCommentViewController.h
//  DHBFlickr
//
//  Created by danielbergquist on 8/13/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHBCommentViewController : UIViewController

// An array of DHBFlickrComment objects to display
@property (readwrite,nonatomic,retain) NSArray *comments;

// The photo author's name
@property (readwrite,nonatomic,retain) NSString *photoAuthorName;

@end
