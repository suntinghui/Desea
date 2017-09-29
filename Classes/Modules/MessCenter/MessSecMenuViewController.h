//
//  MessSecMenuViewController.h
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：部门之窗||文档中心 菜单页面 级数未知
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MessSecMenuViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *headImgArr; //左侧图标
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (assign, nonatomic) int pageType; //0:部门之窗 1：文档中心
@end
