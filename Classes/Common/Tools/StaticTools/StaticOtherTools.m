//
//  StaticOtherTools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticOtherTools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticOtherTools.h"
#import "Reachability.h"


@implementation StaticTools(StaticOtherTools)

#pragma mark 设备环境
/*
 @abstract 获取当前语言环境
 */
+ (NSString *)deviceLanguages
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}




/**
 *	@brief	获取当前设备的系统版本
 *
 *	@return
 */
+ (NSString*)deviceVersion

{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 *	@brief	获取设备的系统名称
 *
 *	@return
 */
+ (NSString*)deviceSyName

{
   return  [[UIDevice currentDevice] systemName];
}
/*
 @abstract获取当前版本号
 */
+ (NSString *)projectVerson
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

/*
 @abstract获取软件名称
 */
+ (NSString*)projectName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
}

/*
 @abstract 获取当前设备类型值 (0- iPod touch  1- iPhone 3GS以前版本  2- iPhone 4  9 - iPad)
 */
+ (int)deviceType
{
    NSString *machineType = [[UIDevice currentDevice] model];
	
	if ([machineType compare:@"iPod touch"] == NSOrderedSame)
    {
        return 0;
    }
	else if ([machineType compare:@"iPhone"] == NSOrderedSame)
    {
        return 1;
    }
	else if ([machineType compare:@"iPad"] == NSOrderedSame)
    {
        return 2;
    }
	else if ([machineType compare:@"iPhone Simulator"] == NSOrderedSame)
    {//模拟器
        return 3;
    }
	else if ([machineType compare:@"iPad Simulator"] == NSOrderedSame)
    {
       return 4; 
    }
	
	return -1;
}

/*
 @abstract 检查网络状态
 */
+ (int)checkNetWork
{
    NetworkStatus internetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return internetStatus;
}

/*
 @abstract 获取程序代理
 */
+ (AppDelegate*)getAppDelegate
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate;
}

@end
