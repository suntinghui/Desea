//
//  CalendarMainViewController.h
//  Desea
//
//  Created by wenbin on 14-1-16.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：日程管理首页
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface CalendarMainViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *unreadNumStr;

@end
