//
//  ShowZipContentViewController.h
//  Desea
//
//  Created by  STH on 2017/9/29.
//  Copyright © 2017年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowZipContentViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) UIActivityIndicatorView *progressInd;

- (id) initWithPath:(NSString *) path;

@end
