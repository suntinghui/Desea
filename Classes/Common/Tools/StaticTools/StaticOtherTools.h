//
//  StaticOtherTools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import "StaticTools.h"
#import "AppDelegate.h"

@interface StaticTools(StaticOtherTools)

/*
 @abstract 获取当前语言环境
 */
+ (NSString *)deviceLanguages;

/*
 @abstract获取当前设备ID
 */
+ (NSString *)deviceID;

/**
 *	@brief	获取当前设备的系统版本
 */
+ (NSString*)deviceVersion;
/**
 *	@brief	获取设备的系统名称
 */
+ (NSString*)deviceSyName;

/*
 @abstract获取当前版本号
 */
+ (NSString *)projectVerson;

/*
 @abstract获取软件名称
 */
+ (NSString*)projectName;
/*
 @abstract 获取当前设备类型值 (0- iPod touch  1- iPhone 3GS以前版本  2- iPhone 4  9 - iPad)
 */
+ (int)deviceType;

/*
 @abstract 检查网络状态
 */
+ (int)checkNetWork;

/*
 @abstract 获取程序代理
 */
+ (AppDelegate*)getAppDelegate;

@end
