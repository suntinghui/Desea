//
//  AddressListViewController.h
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：通讯录
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "ScrollSelectView.h"

@interface AddressListViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    ScrollSelectDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int pageType; //0:通讯录首页 1：子部门联系人页面
@property (strong, nonatomic) NSMutableArray *contactsArr;   //按姓名排序后的数据
@property (strong, nonatomic) NSMutableArray *departmentArr; //按部门排序后的数据
@property (assign, nonatomic) BOOL isSelectContace;          //yes:短信或邮件选择联系人  no：通讯录
@property (strong, nonatomic) NSMutableArray *addressArr;    //保存未排序的原始通讯录数据
@property (strong, nonatomic) NSMutableArray *selectContactArr;//选择联系人时 进入页面时已选择的联系人
@property (strong, nonatomic) NSMutableArray *selectDepArr; ////选择联系人时 进入页面时已选择的部门
@property (assign, nonatomic) UIViewController *fatherController;
@property (strong, nonatomic) NSString *department;
@end
