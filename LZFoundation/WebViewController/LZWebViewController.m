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
//#import "StatusBarView.h"
#import "LZConfig.h"

@interface LZWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIToolbar *toolBar;
//@property (nonatomic, strong) StatusBarView *statusBarView;

@end

@implementation LZWebViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.delegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    
//    self.statusBarView = [StatusBarView initView];
    
    UIView *mainButton = [self barButtonWithImage:[UIImage imageNamed:@"home_off_btn"] hightlightImage:[UIImage imageNamed:@"home_on_btn"] action:@selector(mainAction)];
    UIView *backButton = [self barButtonWithImage:[UIImage imageNamed:@"left_off_btn"] hightlightImage:[UIImage imageNamed:@"left_on_btn"] action:@selector(backAction)];
    UIView *forwardButton = [self barButtonWithImage:[UIImage imageNamed:@"right_off_btn"] hightlightImage:[UIImage imageNamed:@"right_on_btn"] action:@selector(forwardAction)];
    UIView *refreshButton = [self barButtonWithImage:[UIImage imageNamed:@"refresh_off_btn"] hightlightImage:[UIImage imageNamed:@"refresh_on_btn"] action:@selector(refreshAction)];
    UIView *shareButton = [self barButtonWithImage:[UIImage imageNamed:@"menu_off_btn"] hightlightImage:[UIImage imageNamed:@"menu_on_btn"] action:@selector(shareAction)];
//    [self.statusBarView.mainBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.statusBarView.backBtn addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.statusBarView.reloadBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.statusBarView.exitBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.statusBarView.goBtn addTarget:self action:@selector(mainAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    UIBarButtonItem *main = [[UIBarButtonItem alloc] initWithCustomView:mainButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolBar setItems:@[back,item0,forward,item1,main,item2,refresh,item3,share]];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBar];
    
    [self layout];
}
- (UIView *)barButtonWithImage:(UIImage *)image hightlightImage:(UIImage *)hightlightImage action:(SEL)action {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 25);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hightlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
//    button.center = view.center
    return view;
}
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWebContentWithURLString:self.urlString];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self layout];
}

#pragma mark - setFrames

- (void)layout {
    CGRect safeAreaRect, webViewRect, toolBarRect;
    if (@available(iOS 11.0, *)) {
        safeAreaRect = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame;
    } else {
        safeAreaRect = [UIScreen mainScreen].bounds;
    }
    webViewRect.origin = safeAreaRect.origin;

    webViewRect.size = CGSizeMake(safeAreaRect.size.width, safeAreaRect.size.height);
    if (safeAreaRect.size.width > safeAreaRect.size.height) {
        self.toolBar.hidden = YES;
    } else {
//        webViewRect.size = CGSizeMake(safeAreaRect.size.width, safeAreaRect.size.height - 49);
        self.toolBar.hidden = NO;
    }
    
    toolBarRect.origin = CGPointMake(0, CGRectGetMaxY(webViewRect) - 49);
    toolBarRect.size = CGSizeMake(safeAreaRect.size.width, 49);
    
    self.webView.frame = webViewRect;
    self.toolBar.frame = toolBarRect;
}

#pragma mark - Actions

- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (void)forwardAction {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
- (void)mainAction {
     [self loadWebContentWithURLString:self.urlString];
}
- (void)refreshAction {
    [SVProgressHUD show];
    [self.webView reload];
}
- (void)shareAction {
#warning 分享文字
    NSString *textToShare = @"北京赛车—时时彩精准PK10资讯";
    //分享的url
    NSString *urlString = [LZConfig shared].artistViewUrl;
    NSURL *urlToShare = [NSURL URLWithString:urlString];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare ?: @"", urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - private

- (void)loadWebContentWithURLString:(NSString *)urlString {
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        self.toolBar.hidden = NO;
    } else {
        self.toolBar.hidden = YES;
    }
//    [UIDevice currentDevice].userInterfaceIdiom
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        CGRect safeAreaRect, webViewRect;
        if (@available(iOS 11.0, *)) {
            safeAreaRect = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame;
        } else {
            safeAreaRect = [UIScreen mainScreen].bounds;
        }
        webViewRect.origin = safeAreaRect.origin;
        
//        if (safeAreaRect.size.width > safeAreaRect.size.height) {
            webViewRect.size = CGSizeMake(safeAreaRect.size.width, safeAreaRect.size.height);
//            self.toolBar.hidden = YES;
//        } else {
//            webViewRect.size = CGSizeMake(safeAreaRect.size.width, safeAreaRect.size.height - 49);
//            self.toolBar.hidden = NO;
//        }
        
//        toolBarRect.origin = CGPointMake(0, CGRectGetMaxY(webViewRect));
//        toolBarRect.size = CGSizeMake(safeAreaRect.size.width, 49);
        
        self.webView.frame = webViewRect;
//        self.toolBar.frame = toolBarRect;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.toolBar.hidden = NO;
    [self layout];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.toolBar.hidden = NO;
    [self layout];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.toolBar.hidden = NO;
    [self layout];
}

#pragma mark - WKNavigationDelegate

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"alksjdklasjdaskldsaldsa = %@",webView.URL.absoluteString);
    
    if ([webView.URL.absoluteString hasPrefix:@"itms-appss://"]) {
        [[UIApplication sharedApplication] openURL:webView.URL];
        
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            // 一定要加上这句,否则会打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    // 打开appstore
    if ([URL.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [SVProgressHUD dismiss];
    if (error.code != NSURLErrorCancelled) {
        [SVProgressHUD showWithStatus:error.localizedDescription];
    }
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
