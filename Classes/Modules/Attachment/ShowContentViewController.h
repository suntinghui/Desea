//
//  ShowFileContentViewController.h
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ShowContentViewController : BaseViewController <UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *progressInd;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *htmlStr;
@property (nonatomic, strong) NSString *attachmentId;
@property (nonatomic, strong) NSMutableArray *zipFileArray;

-(id) initWithFileName:(NSString *) fileName;
-(id) initWithUrl:(NSString *) url;
-(id) initWithHtmlString:(NSString *) htmlStr;

-(id) initWithFileName:(NSString *)fileName AttachId:(NSString*)attachId;
@end
