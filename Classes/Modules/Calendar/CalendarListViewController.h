//
//  CalendarListViewController.h
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：日程列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface CalendarListViewController : BaseViewController<PageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (assign, nonatomic) int pageType; //1:我的日程 2：部门日程 3：领导日程
@property (strong, nonatomic) NSString *cellColor;
@property (strong, nonatomic) PageView *pageView;

@end
