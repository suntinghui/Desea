//
//  EmailListViewController.h
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：邮件列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface EmailListViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    PageViewDelegate,
    UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *cellColor;
@property (assign, nonatomic) int pageType; //0:草稿箱 1：收件箱 2：发件箱 3：已删除
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) PageView *pageView;

- (void)getList;

@end
