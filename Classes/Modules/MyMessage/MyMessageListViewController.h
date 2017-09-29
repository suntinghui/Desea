//
//  MyMessageListViewController.h
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：发件箱||收件箱
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MyMessageListViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    PageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (assign, nonatomic) int pageType; //0:收件箱 1：发件箱
@property (strong, nonatomic) PageView *pageView;
@end
