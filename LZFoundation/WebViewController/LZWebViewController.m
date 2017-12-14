//
//  LZWebViewController.m
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import "LZWebViewController.h"

#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>

@interface LZWebViewController ()<WKNavigationDelegate>
{
    
}
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LZWebViewController

- (void)loadView {
    
    if (@available(iOS 11.0, *)) {
        self.webView = [[WKWebView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame];
    } else {
        self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.webView.navigationDelegate = self;
    
    self.view = self.webView;
    
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.webView = [[WKWebView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWebContentWithURLString:self.urlString];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//
}

- (void)loadWebContentWithURLString:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        return;
    }
    if (self.webView.isLoading) {
        return;
    }
    [SVProgressHUD show];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [SVProgressHUD showWithStatus:error.localizedDescription];
}

//- (void)setUrlString:(NSString *)urlString {
//    _urlString = urlString;
//    [self loadWebContentWithURLString:urlString];
//}
- (void)didReceiveMemoryWarning {
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
