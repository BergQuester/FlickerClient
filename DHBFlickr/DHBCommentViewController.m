//
//  DHBCommentViewController.m
//  DHBFlickr
//
//  Created by danielbergquist on 8/13/14.
//  Copyright (c) 2014 Daniel Bergquist. All rights reserved.
//

#import "DHBCommentViewController.h"
#import "DHBFlickrComment.h"

@interface DHBCommentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *commentView;

@end

@implementation DHBCommentViewController

- (void)renderComments
{
    NSMutableString *html = [NSMutableString stringWithFormat:@"<html lang=en>\n"
                             "<head>\n"
                             "<title></title>\n"
                             "<style type=\"text/css\">\n"
                             "	body {\n"
                             "  		font-family: Sans-Serif;\n"
                             "	}\n"
                             "h3,h4 {\n"
                             "    color: #0099CC;\n"
                             "}\n"
                             "</style>\n"
                             "</head>\n"
                             "<body>\n"
                             "<div><h3>Photo by: %@</h3></div>\n", self.photoAuthorName];
    
    for (DHBFlickrComment *comment in self.comments) {
        [html appendFormat:@"<div>\n"
         "	<h4>%@</h4>\n"
         "	<p>%@</p>\n"
         "</div>\n", comment.authorName, comment.content];
    }
    
    [html appendString:@"</body>\n"
     "</html>\n"];
    
    [self.commentView loadHTMLString:html baseURL:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self renderComments];
}

-(void)setPhotoAuthorName:(NSString *)authorName
{
    _photoAuthorName = authorName;
    
    [self renderComments];
}

- (void)setComments:(NSArray *)comments
{
    if (comments.count > 0) {
        _comments = comments;
    }
    else {
        _comments = @[[DHBFlickrComment comment:@"" withAuthor:@"No Comments"]];
    }
    
    [self renderComments];
}


- (IBAction)done:(id)sender {
    // TODO: cancel network connection
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
