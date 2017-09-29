//
//  PersonalManageViewController.h
//  Desea
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
//----------------------------------------------------------------
// Copyright (C) 菊花小分队
// 版权所有。
//
// 文件功能描述：人事管理

// 创建标识：
// 修改标识：
// 修改日期：
// 修改描述：
//
//----------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface PersonalManageViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;
@property (strong, nonatomic) ContactsModel *selectContact;
@property (strong, nonatomic) NSArray *infoList;
@property (strong, nonatomic) NSString *personType;  //@"0":普通人员  @“1”：管理员

- (IBAction)buttonClickHandle:(id)sender;

@end
