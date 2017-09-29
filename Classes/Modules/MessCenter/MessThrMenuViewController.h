//
//  MessThrMenuViewController.h
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：(改页面暂时未用到)
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MessThrMenuViewController : BaseViewController<UITableViewDelegate,
    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *titleStr; //导航条标题
@property (strong, nonatomic) NSArray *titleArr; //标题
@property (strong, nonatomic) NSArray *headImgArr; //左侧图标

@end
