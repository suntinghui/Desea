//
//  AttachmentListViewController.h
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：附件列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface AttachmentListViewController : UIViewController<UITableViewDelegate,
    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UILabel *attchmentNumLabel;
@property (assign, nonatomic) UIViewController *fatherController;
@property (strong, nonatomic) NSMutableArray *attchArr; //附件列表数据
@property (strong, nonatomic) NSString *infoId;

@end
