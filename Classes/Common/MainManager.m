//
//  MainManager.m
//  FormPreview
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
//

#import "MainManager.h"

static MainManager *shareRootMainManager = nil;

@implementation MainManager
- (id)init
{
    self = [super init];
    if (self)
    {
        self.selectPeople = [NSMutableArray arrayWithCapacity:1];
        self.selectDepartment = [NSMutableArray arrayWithCapacity:1];
        self.userId = @"";
    }
    return self;
}

+(MainManager *)sharedMainManager
{
    @synchronized(self)
    {
        if(shareRootMainManager == nil)
        {
            shareRootMainManager = [[self alloc] init];
        }
    }
    return shareRootMainManager;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shareRootMainManager == nil)
        {
            shareRootMainManager = [super allocWithZone:zone];
            return  shareRootMainManager;
        }
    }
    return nil;
}

#pragma mark-
#pragma mark--功能函数



@end
