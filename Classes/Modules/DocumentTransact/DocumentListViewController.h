//
//  DocumentListViewController.h
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：公文管理--列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface DocumentListViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    PageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int pageType;
@property (strong, nonatomic) NSString *cellColor;
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) PageView *pageView;

@end