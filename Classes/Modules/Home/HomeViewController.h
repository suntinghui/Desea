//
//  HomeViewController.h
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：首页
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface HomeViewController : BaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *helloLabel; //上次登录时间
@property (weak, nonatomic) IBOutlet UILabel *myUndo;  //我的代办
@property (weak, nonatomic) IBOutlet UILabel *todayDocument; //今日收文
@property (weak, nonatomic) IBOutlet UILabel *messageCenter; //信息中心
@property (weak, nonatomic) IBOutlet UILabel *calendar; //日程安排
@property (weak, nonatomic) IBOutlet UILabel *myEmail; //我的邮件
@property (strong, nonatomic) NSString *versionUrl;

- (IBAction)buttonClickHandle:(id)sender;
@end
