//
//  AppDelegate.h
//  Desea
//
//  Created by wenbin on 14-1-7.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,
    WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;



@end
