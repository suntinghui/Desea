//
//  MainManager.h
//  FormPreview
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 //
 // 文件功能描述：全局的单例类 存放公共的数据
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>

#define ShareManager [MainManager sharedMainManager]

@interface MainManager : NSObject

@property (strong, nonatomic) NSString *userName; //用户姓名
@property (strong, nonatomic) NSString *userId; //用户ID
@property (strong, nonatomic) NSMutableArray *selectPeople; //发短信或写邮件选择的收件人
@property (strong, nonatomic) NSMutableArray *addressArr; //通讯录数据 未排序
@property (strong, nonatomic) NSMutableArray *selectDepartment; //发短信或写邮件或表单选择的部门
@property (strong, nonatomic) NSMutableArray *departmentArr; //部门数据

+(MainManager *)sharedMainManager;

@end
