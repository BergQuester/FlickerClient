//
//  DHBFlickrImageTests.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/12/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DHBFlickrImage.h"

@interface DHBFlickrImageTests : XCTestCase

@property (readwrite,assign) DHBFlickrImage *image;

@end

@implementation DHBFlickrImageTests

- (void)setUp
{
    [super setUp];

    self.image = [DHBFlickrImage imageWithMediaURL:[NSURL URLWithString:@"http://farm4.staticflickr.com/3845/14714869119_d7bd225c2f_m.jpg"]
                                           linkURL:[NSURL URLWithString:@"http://www.flickr.com/photos/29661720@N04/14714869119/"]
                                            author:@"nobody@flickr.com (photosmirror)"];
}

- (void)testMediaURLIsSetWithCorrectPath
{
    XCTAssertEqualObjects(self.image.mediaURL, [NSURL URLWithString:@"http://farm4.staticflickr.com/3845/14714869119_d7bd225c2f_m.jpg"], @"mediaURL path should be the one that was passed in.");
}

- (void)testLinkURLIsSetWithCorrectPath
{
    XCTAssertEqualObjects(self.image.linkURL, [NSURL URLWithString:@"http://www.flickr.com/photos/29661720@N04/14714869119/"], @"linkURL path should be the one that was passed in.");
}

- (void)testAuthorIsSet
{
    XCTAssertEqualObjects(self.image.author, @"nobody@flickr.com (photosmirror)", @"author should be the one that was passed in.");
}

- (void)testImageIDIsSet
{
    XCTAssertEqual(self.image.photoID, 14714869119, @"photoID should match the id in the linkURL path.");
}

@end
