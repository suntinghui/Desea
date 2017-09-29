//
//  ContactsModel.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel


- (id)copyWithZone:(NSZone *)zone
{
    ContactsModel *copy = [[self class] allocWithZone: zone];
    copy.name = [NSString stringWithFormat:@"%@",self.name];
    copy.usrId = [NSString stringWithFormat:@"%@",self.usrId];
    copy.chinseStrOfName = [NSString stringWithFormat:@"%@",self.chinseStrOfName];
     copy.departMent = [NSString stringWithFormat:@"%@",self.departMent];
     copy.departMentId = [NSString stringWithFormat:@"%@",self.departMentId];
     copy.phoneNum = [NSString stringWithFormat:@"%@",self.phoneNum];
     copy.telNum = [NSString stringWithFormat:@"%@",self.telNum];
     copy.emailOne = [NSString stringWithFormat:@"%@",self.emailOne];
     copy.emailTwo = [NSString stringWithFormat:@"%@",self.emailTwo];
    return copy;
}
@end
