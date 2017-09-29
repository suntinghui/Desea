//
//  NewsDetailViewController.h
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：新闻详情页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIWebViewDelegate,
    UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSDictionary *resultDict;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachBtn;

@property (strong, nonatomic) UIImage *detailImg; //详情里的图片  只有一张
@property (assign, nonatomic) int pageType; //0：通知信息 1:集团新闻 2:集团公告
@property (assign, nonatomic) NSString *InfoId; //前一个页面传过来的新闻的id

- (IBAction)buttonClickHandle:(id)sender;

@end
