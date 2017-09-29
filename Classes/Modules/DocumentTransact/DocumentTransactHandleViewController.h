//
//  DocumentTransactHandleViewController.h
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：公文管理操作页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "ScrollSelectView.h"

@interface DocumentTransactHandleViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    ScrollSelectDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
