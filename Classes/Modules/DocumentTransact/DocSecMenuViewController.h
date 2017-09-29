//
//  DocSecMenuViewController.h
//  Desea
//
//  Created by wenbin on 14-2-25.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：公文二级caida
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface DocSecMenuViewController : BaseViewController<UITableViewDataSource,
    UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int pageType; //1:收文管理 2：发文管理

@end
