//
//  NewsListViewController.h
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：新闻列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "ScrollSelectView.h"

@interface NewsListViewController : BaseViewController<UITableViewDelegate,
    UITableViewDataSource,
    ScrollSelectDelegate,
    PageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int listType; //0:未读 2：所有
@property (weak, nonatomic) NSString *titleStr; //导航栏标题
@property (assign, nonatomic) int pageType; //0:集团新闻 1：集团公告 2:通知信息 3:部门之窗
@property (strong, nonatomic) NSString *depId;  //前一个页面传过来的栏目id  集团新闻和集团公告要用
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) PageView *pageView;

@end
