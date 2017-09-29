//
//  DepartmentSelectorViewController.h
//  Desea
//
//  Created by wenbin on 14-2-28.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：部门选择页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface DepartmentSelectorViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *departments;
@property (strong, nonatomic) NSMutableDictionary *resultDict;
@property (assign, nonatomic) int pageType; //0:一级部门 1：一级之后部门
@property (assign, nonatomic) BOOL isMutSelect; //是否为多选
@property (assign, nonatomic) NSMutableDictionary *opetationData;
@property (assign, nonatomic) UIViewController *fatherController;
@end
