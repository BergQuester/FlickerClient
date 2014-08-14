//
//  DHBFlickrCommentTests.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/13/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DHBFlickrComment.h"

@interface DHBFlickrCommentTests : XCTestCase

@property (readwrite,retain) DHBFlickrComment *comment;

@end

@implementation DHBFlickrCommentTests

- (void)setUp
{
    [super setUp];
    
    self.comment = [DHBFlickrComment comment:@"Rad app, dude!" withAuthor:@"BergQuester"];
}

- (void)testContentIsSetWithCorrectString
{
    XCTAssertEqualObjects(self.comment.content, @"Rad app, dude!", @"content should be the one that was passed in.");
}

- (void)testAuthorIsSetWithCorrectString
{
    XCTAssertEqualObjects(self.comment.authorName, @"BergQuester", @"author should be the one that was passed in.");
}


@end
