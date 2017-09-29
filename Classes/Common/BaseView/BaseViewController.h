//
//  BaseViewController.h
//  Desea
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：页面基类  ios7适配、定制导航栏返回按钮 原则上所有页面都得继承自此类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//导航栏返回按钮点击
- (void)back;

- (void)setBackButtonWithTitle:(NSString*)title;

@end
