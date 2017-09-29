//
//  SelectorViewController.h
//  Desea
//
//  Created by wenbin on 14-2-27.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：提供单选和多选页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface SelectorViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int pageType; //0:枚举值单选 1:流程提交页面下级节点选择
@property (weak, nonatomic) NSMutableDictionary *fileldDict;
@property (assign, nonatomic) BOOL isMulSelect;  //是否为多选
@property (assign, nonatomic) UIViewController *fatherController;
@property (assign, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) int currentSelect; //当前选择的项 单选时用到

@end
