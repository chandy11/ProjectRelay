//
//  SearchWebViewController.m
//  ProjectRelay
//
//  Created by Irwin Gonzales on 12/19/15.
//  Copyright © 2015 Irwin Gonzales. All rights reserved.
//

#import "SearchWebViewController.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"

@interface SearchWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SearchWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.passedArticle);
    _webView.delegate = self;
    [self loadWebsite];
}

- (void)loadWebsite
{
    NSString *webPageURLString = _passedArticle.url;
    NSURL *webPageURL = [NSURL URLWithString:webPageURLString];
    NSURLRequest *webPageURLRequest = [NSURLRequest requestWithURL:webPageURL];
    [self.webView loadRequest:webPageURLRequest];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [RKDropdownAlert title:@"Something Went Wrong!"
                   message:error.localizedDescription
           backgroundColor:[UIColor redColor]
                 textColor:[UIColor whiteColor]
                      time:1.0];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view
                             animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
