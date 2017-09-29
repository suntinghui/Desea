//
//  ShowZipContentViewController.m
//  Desea
//
//  Created by  STH on 2017/9/29.
//  Copyright © 2017年 wenbin. All rights reserved.
//

#import "ShowZipContentViewController.h"


@interface ShowZipContentViewController ()

@end

@implementation ShowZipContentViewController

@synthesize webView = _webView;
@synthesize path = _path;
@synthesize progressInd = _progressInd;

- (id) initWithPath:(NSString *) filePath {
    if (self = [super init]) {
        self.path = filePath;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float height = 416.0f;
    if (IsIPhone5) {
        height = 504.0f;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [self.webView setUserInteractionEnabled:YES];
    // YES, 初始太小，但是可以放大；NO，初始可以，但是不再支持手势。 FUCK！！！
    self.webView.scalesPageToFit = YES; // 设置网页和屏幕一样大小，使支持缩放操作
    [self.webView setDelegate:self];
    
    NSURL *url = [NSURL fileURLWithPath:self.path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // 测试发现，当为EXCEL文件时（即扩展名为xls或xlsx),则一直在屏幕上显示加载不消失，故采用如下特殊处理之。
    if (self.path && [[self.path pathExtension] rangeOfString:@"xls"].location != NSNotFound) {
        return ;
    }
    
    [self showWaiting];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /***
     
     // http://blog.csdn.net/kmyhy/article/details/7198920
     // http://www.icab.de/blog/2010/12/27/changing-the-range-of-the-zoom-factor-for-uiwebview-objects/
     
     NSString *path = [[NSBundle mainBundle] pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
     NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
     [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
     [self.webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
     ***/
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//显示进度滚轮指示器
-(void)showWaiting {
    _progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    //    _progressInd.center=CGPointMake(self.view.center.x,240);
    _progressInd.center = self.view.center;
    [_progressInd setColor:[UIColor blackColor]];
    [self.view addSubview:_progressInd];
    [_progressInd startAnimating];
}

//消除滚动轮指示器
-(void)hideWaiting
{
    [_progressInd stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
