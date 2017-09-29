//
//  ContactsModel.h
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：联系人model
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface ContactsModel : NSObject

@property (strong, nonatomic) NSString *name;           //姓名
@property (strong, nonatomic) NSString *chinseStrOfName; //姓名的拼音
@property (strong, nonatomic) NSString *chinseStrOfDepartment; //部门的拼音
@property (strong, nonatomic) NSString *departMent;     //部门
@property (strong, nonatomic) NSString *departMentId;   //部门ID
@property (strong, nonatomic) NSString *usrId;          //用户ID
@property (strong, nonatomic) NSString *phoneNum; //手机号码
@property (strong, nonatomic) NSString *telNum; //办公电话
@property (strong, nonatomic) NSString *emailOne;
@property (strong, nonatomic) NSString *emailTwo;

@end
