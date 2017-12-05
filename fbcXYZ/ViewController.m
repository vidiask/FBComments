//
//  ViewController.m
//  fbcXYZ
//
//  Created by Vikas Pandey on 09/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController ()
@property NSString *postUrlStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _postUrlStr = @"";
    [self loadComments];


}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



- (void)loadComments {
    NSString *html = @"<!doctype html> <html lang=\"en\"> <head></head> <body> "
    "<div id=\"fb-root\"></div> <script>(function(d, s, id) { var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = \"//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.6\"; fjs.parentNode.insertBefore(js, fjs); }(document, 'script', 'facebook-jssdk'));</script> "
    "<div class=\"fb-comments\" data-href=\""  "\(postUrlStr)"  "\" "
    "data-numposts=\""  "10"  "\" data-order-by=\"reverse_time\">"
    "</div> </body> </html>";
    [_webView loadHTMLString:(html) baseURL:[[NSURL alloc] initWithString:(@"http://www.nothing.com")]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //Maybe there is a better way to check auth redirect?
    if ([[request.URL absoluteString] containsString:(@"/login")]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[(@"publish_actions")] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {

            } else if (result.isCancelled) {

            } else {
                //Here I need to set cookies, or something like that
                [self loadComments];
            }
        }];

        return NO;
    }else if ([[request.URL absoluteString] containsString:(@"/plugins/close_popup.php?reload")]){
        [self loadComments];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
