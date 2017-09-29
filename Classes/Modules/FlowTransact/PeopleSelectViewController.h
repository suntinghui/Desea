//
//  PeopleSelectViewController.h
//  Desea
//
//  Created by wenbin on 14-2-28.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：人员选择选择页面 --通讯录页面逻辑已经很复杂 所以不再复用 另外写一个
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PeopleSelectViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *contactsArr;   //按姓名排序后的数据
@property (strong, nonatomic) NSMutableArray *addressArr;    //保存未排序的原始通讯录数据
@property (strong, nonatomic) NSMutableArray *selectContactArr;//选择联系人时 进入页面时已选择的联系人
@property (assign, nonatomic) UIViewController *fatherController;
@property (strong, nonatomic) NSMutableArray *selectId; //已经选择的人的id
@property (assign, nonatomic) BOOL isMutSelect;  //是否为多选
@property (assign, nonatomic) NSDictionary *operationData;
@property (strong, nonatomic) NSMutableArray *selectPeople; //已选择的人员 单独一组

@end
