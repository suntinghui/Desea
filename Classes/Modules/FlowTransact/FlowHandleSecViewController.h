//
//  FlowHandleSecViewController.h
//  Desea
//
//  Created by wenbin on 14-2-27.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：表单操作--提交流程页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface FlowHandleSecViewController : BaseViewController<UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate,
    UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

/* 0:主办人模式，主办人必须有，相关办理人可以没有。
 1:会签人模式，主办人的选择要隐去，相关办理人必须有，且可以多选
 2:单人签发模式，主办人的选择要隐去，相关办理人必须有，且可以多选
 */
@property (assign, nonatomic) int operationType;
@property (weak, nonatomic) NSMutableArray *activitys; //所有节点的数据
@property (weak, nonatomic) NSMutableDictionary *currentAct; //当前操作节点的数据
@property (assign, nonatomic) UIViewController *fatherController;


@end
