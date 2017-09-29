//
//  Constant.h
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//



#import "AppDelegate.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define DEFAULTHOST                     @"http://oa.desea.cn:8080/LKOA6/"


#define kHostAddress                    @"HOSTADDRESS"
#define kWebServiceName                 @"webServiceName"
#define kMethodName                     @"methodName"
#define kParamName                      @"paramName"

#define kPAGESIZE                       @"5"

#define kLevelOneFont [UIFont systemFontOfSize:14]
#define kLevelTwoFont [UIFont systemFontOfSize:15]
#define kLevelThreeFont [UIFont systemFontOfSize:16]
#define kLevelFourFont [UIFont systemFontOfSize:18]

//登录相关
#define kUSERID                         @"userId"         //用户id
#define KUSERNAME                       @"userName"       //用户名
#define kPASSWORD                       @"password"       //用户密码
#define kLastLoginTime                  @"LastLoginTime"  //上次登录时间
#define kREMEBERPWD                     @"remeberPWD"     //是否记住密码 @"1"：记住  @"0":不急着
#define kAUTOLOGIN                      @"autoLogin"      //是否自动登录 @"1"：自动登录  @"0":不自动登录

//日程管理







