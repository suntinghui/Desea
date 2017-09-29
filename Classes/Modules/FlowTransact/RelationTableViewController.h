//
//  RelationTableViewController.h
//  Desea
//
//  Created by 文彬 on 14-4-2.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：关联流程页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface RelationTableViewController : UIViewController<UITableViewDataSource,
    UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) NSString *infoId;
@property (assign, nonatomic) UIViewController *fatherController;

@end
