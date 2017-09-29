//
//  LoginViewController.h
//  Desea
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：登录页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;
@property (weak, nonatomic) IBOutlet UIView *setingView;
@property (weak, nonatomic) IBOutlet UITextField *hostTxtField; //服务器地址输入框



- (IBAction)buttonClickHandle:(id)sender;

@end
