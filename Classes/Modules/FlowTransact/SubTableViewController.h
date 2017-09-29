//
//  SubTableViewController.h
//  Desea
//
//  Created by wenbin on 14-3-12.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：从表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface SubTableViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) NSMutableArray *resultArr; //从表数据
@property (strong, nonatomic) NSMutableArray *flowArr;  //关联列表数据
@property (strong, nonatomic) NSString *infoId;
@property (assign, nonatomic) int sType;

@end
