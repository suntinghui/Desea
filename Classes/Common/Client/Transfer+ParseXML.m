//
//  Transfer+ParseXML.m
//  LKOA4iPhone
//
//  Created by  STH on 7/28/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "Transfer+ParseXML.h"
#import "TBXML.h"
#import "ContactsModel.h"
#import "pinyin.h"

@interface Transfer (private)

@end

@implementation Transfer (ParseXML)



- (id) ParseXMLWithReqName:(NSString *) reqName
                           xmlString:(NSString *) xml
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLString:xml error:&error];
    if (error) {
        NSLog(@"%@->ParseXML[%@]:%@", [self class] , reqName, [error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        TBXMLElement *bodyElement = [TBXML childElementNamed:@"soap:Body" parentElement:rootElement];
        while (bodyElement) {
            if ([reqName isEqualToString:@"Login"]) //登录
            {
                return [self login:bodyElement];
                
            }
            else if([reqName isEqualToString:@"GetGLZXCount"]) //首页未读条数
            {
                return [self getHomeUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetBMZC"]) //获取部门之窗子项标题和未读条数
            {
               return  [self GetBMZCUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetWDZX"]) //获取文档中心子项和未读
            {
                return [self GetWDZXCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetXXZXCount"]) //信息中心首页未读条数
            {
               return  [self getXXZXUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetLCGLCount"]) //流程管理首页未读条数
            {
               return [self GetLCListUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetLCList"]) //流程管理列表||公文管理列表
            {
                return [self GetLCList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetTZList"]) //通知信息列表
            {
                return [self getNoticeList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetXXList"]) //集团新闻列表
            {
                return  [self getNewsList:bodyElement withType:reqName];
            }
            else if([reqName isEqualToString:@"getNoticeDetail"]) //通知信息内容
            {
               return  [self getNoticeDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetXX"]) //集团新闻内容
            {
                return [self getNewsDetail:bodyElement withType:reqName];
            }
            else if([reqName isEqualToString:@"GetTZ"]) //通知信息内容
            {
                return [self getTZDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetGWGLCount"]) //公文管理首页未读条数
            {
                return [self GetGWGLCountUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetRCCount"]) //日程安排首页未读条数
            {
                return [self GetRCUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetRCList"]) //日程列表
            {
                return [self getCalendarList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetRC"]) //日程详情
            {
                return [self getCalendarDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetJTHDList"]) //集团活动列表
            {
                return [self GetJTHDList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetJTHD"]) //集团活动详情
            {
                return [self getActivityDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetSysAddress_Book"]) //通讯录
            {
                 return [self getAddressList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetMailCount"]) //邮件未读条数
            {
                return [self GetMailListUnreadCount:bodyElement];
            }
            else if([reqName isEqualToString:@"GetMailList"]) //内部邮件列表
            {
                return [self GetMailList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetMail"]) //内部邮件详情
            {
               return  [self getEmailDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"WriteMail"]) //发送邮件
            {
                return [self sendEmail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetAtt"]) //获取附件内容
            {
             
                return [self getAttachmentContent:bodyElement];
            }
            else if([reqName isEqualToString:@"WriteSMS"]) //发送短信
            {
                return [self sendMessage:bodyElement];
            }
            else if([reqName isEqualToString:@"GetSMSList"])//短信列表
            {
                return [self GetSMSList:bodyElement];
            }
            else if([reqName isEqualToString:@"GetLCBD"]) //表单内容请求
            {
                return [self getDetail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetLCZW"]) //获取表单正文url
            {
                return [self GetContentUrl:bodyElement];
            }
            else if([reqName isEqualToString:@"GetAttList"])//附件列表
            {
                return [self GetAttachmentList:bodyElement];
            }
            else if([reqName isEqualToString:@"SetGLBD"]) //表单提交或保存
            {
                return [self SetGLBD:bodyElement];
            }
            else if([reqName isEqualToString:@"GetDept"]) //获取部门信息
            {
                return [self GetDepartmentInfo:bodyElement];
            }
            else if([reqName isEqualToString:@"GetLCBDCB"]) //获取从表信息
            {
                return [self getSubTable:bodyElement];
            }
            else if([reqName isEqualToString:@"GetGLLCList"]) //获取关联流程列表
            {
                return [self GetGLLCList:bodyElement];
            }
            else if([reqName isEqualToString:@"DelMail"]) //删除邮件
            {
                return [self deleteEmail:bodyElement];
            }
            else if([reqName isEqualToString:@"GetKaoQin"]) //获取人员考勤数据
            {
             
                return [self GetKaoQinList:bodyElement];
            }
            else if([reqName isEqualToString:@"AllReceive"]) //一键接收所有待办
            {
                return [self getAllUndo:bodyElement];
            }

        }
        
    }
    
    return nil;
}

#pragma mark
#pragma mark 登录
/**
 *  登录
 *
 *  @param bodyElement
 *
 *  @return
 
 返回报文示例：
 登录成功：
 <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><LoginResponse xmlns="http://tempuri.org/"><LoginResult>0;1;test</LoginResult></LoginResponse></soap:Body></soap:Envelope>
 
 密码错误：
 <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><LoginResponse xmlns="http://tempuri.org/"><LoginResult>1;密码错误;</LoginResult></LoginResponse></soap:Body></soap:Envelope>
 
 */
- (id) login:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"LoginResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"LoginResult" parentElement:respElement];
    
    if (resultElement) {
        NSString *result = [TBXML textForElement:[TBXML childElementNamed:@"LoginResult" parentElement:respElement]];
   
        NSArray *array = [result componentsSeparatedByString:@";"];
  
        return array;
        
    } else {// 登录失败，返回错误码
        NSString *result = [TBXML textForElement:resultElement];
        return result;
    }
}

#pragma mark
#pragma mark 获取首页的模块未读调速
/**
 *  获取首页的模块未读调速
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) getHomeUnreadCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetGLZXCountResponse" parentElement:bodyElement];
     NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetGLZXCountResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
}

#pragma mark
#pragma mark 获取信息中心首页未读条数
/**
 *  获取信息中心首页未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) getXXZXUnreadCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetXXZXCountResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetXXZXCountResult" parentElement:respElement];
 
    if (resultElement)
    {
        
        TBXMLElement *infoElement = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        //集团新闻未读数
        TBXMLElement *JDXWElement = [TBXML childElementNamed:@"JDXW" parentElement:infoElement];
        NSString *JDXW = [TBXML textForElement:[TBXML childElementNamed:@"count" parentElement:JDXWElement]];
        NSString *JDXWID = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:JDXWElement]];

        //集团公告未读数
        TBXMLElement *JDGGElement = [TBXML childElementNamed:@"JDGG" parentElement:infoElement];
        NSString *JDGG = [TBXML textForElement:[TBXML childElementNamed:@"count" parentElement:JDGGElement]];
        NSString *JDGGID = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:JDGGElement]];


        //通知信息未读数
        TBXMLElement *TZXXElement = [TBXML childElementNamed:@"TZXX" parentElement:infoElement];
        NSString *TZXX = [TBXML textForElement:[TBXML childElementNamed:@"count" parentElement:TZXXElement]];
        NSString *TZXXID = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:TZXXElement]];
    
        return @{@"JDXW":JDXW,@"JDXWID":JDXWID,@"JDGG":JDGG,@"JDGGID":JDGGID,@"TZXX":TZXX,@"TZXXID":TZXXID};
        
    } else {
        return nil;
    }
}


#pragma mark
#pragma mark 获取流程管理首页未读条数
/**
 *  获取流程管理首页未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) GetLCListUnreadCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCGLCountResponse" parentElement:bodyElement];

    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetLCGLCountResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
}

#pragma mark
#pragma mark 获取公文管理首页未读条数
/**
 *  获取公文管理首页未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) GetGWGLCountUnreadCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetGWGLCountResponse" parentElement:bodyElement];
    
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetGWGLCountResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
}


#pragma mark
#pragma mark 获取流程管理列表数据
/**
 *  获取流程管理列表数据 ||公文管理列表数据
 *
 *  @param bodyElement
 */
- (id)GetLCList:(TBXMLElement*)bodyElement
{
  
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetLCListResult" parentElement:respElement];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_20" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_10" parentElement:TableElemnt]];
                NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"FRM_20_COL_20" parentElement:TableElemnt]];
                NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"FEG_15_COL_20" parentElement:TableElemnt]];
                NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"SYS_30_COL_30" parentElement:TableElemnt]];
                
                NSDictionary *dict = @{@"title":title,@"Id":Id,@"content":content,@"type":type,@"people":people};
                [arr addObject:dict];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
   
    return nil;
}

#pragma mark
#pragma mark 获取部门之窗子项标题和未读条数


/**
 *  递归获取xml数据  这个递归解析貌似有问题 
 *
 *  @param element
 *
 *  @return
 */
- (id) infoOfElement:(TBXMLElement*) element
{
    if (element->text)
        return [TBXML textForElement:element];
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    TBXMLAttribute *attribute = element->firstAttribute;
    if (attribute) {
        do {
            [info setValue:[TBXML attributeValue:attribute] forKey:[TBXML attributeName:attribute]];
            attribute = attribute -> next;
        } while (attribute);
    }
    TBXMLElement *child = element->firstChild;
    if (child){
        TBXMLElement *siblingOfChild = child->nextSibling;
        //If we have array of children with equal name -> create array of this elements
        if (siblingOfChild!=nil)
        {
            if ([[TBXML elementName:siblingOfChild] isEqualToString:[TBXML elementName:child]]){
                NSMutableArray *children = [NSMutableArray new];
                do {
                    [children addObject:[self infoOfElement:child]];
                    child = child -> nextSibling;
                } while (child);
                return [NSDictionary dictionaryWithObject:children forKey:[TBXML elementName:element]];
            }
            else{
                do {
                    [info setValue:[self infoOfElement:child] forKey:[TBXML elementName:child]];
                    child = child -> nextSibling;
                } while (child);
            }
        }
       
    }   
    return info;
}


- (id)getBUZCwithElement:(TBXMLElement*)infosElement
{
    TBXMLElement *infoElement = [TBXML childElementNamed:@"Infor" parentElement:infosElement];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    while (infoElement)
    {
        @autoreleasepool
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
             NSString *idStr = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:infoElement]];
               NSString *name = [TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:infoElement]];
              NSString *count = [TBXML textForElement:[TBXML childElementNamed:@"count" parentElement:infoElement]];
            TBXMLElement *infosElement = [TBXML childElementNamed:@"Infors" parentElement:infoElement];
            
            [dict setObject:idStr forKey:@"id"];
            [dict setObject:name forKey:@"name"];
            [dict setObject:count forKey:@"count"];
            if (infosElement!=nil)
            {
                 [dict setObject:[self getBUZCwithElement:infosElement] forKey:@"Infors"];
            }
            
            [arr addObject:dict];
            infoElement = [TBXML nextSiblingNamed:@"Infor" searchFromElement:infoElement];
        }
    }
    
    return arr;
}

/**
 *  获取部门之窗子项标题和未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) GetBMZCUnreadCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetBMZCResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetBMZCResult" parentElement:respElement];
    
    
    if (resultElement)
    {
        
        TBXMLElement *infosElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        
//        return [self infoOfElement:infosElement];
        
        
        return [self getBUZCwithElement:infosElement];
    }
   
        return nil;
    
}

/**
 *  获取部门之窗子项标题和未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id) GetWDZXCount:(TBXMLElement *) bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetWDZXResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetWDZXResult" parentElement:respElement];
    
    
    if (resultElement)
    {
        
        TBXMLElement *infosElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        
        //        return [self infoOfElement:infosElement];
        
        
        return [self getBUZCwithElement:infosElement];
    }
    
    return nil;
    
}
#pragma mark
#pragma mark 获取列表数据
/**
 *  获取列表数据
 *
 *  @param bodyElement
 */
- (id)getNewsList:(TBXMLElement*)bodyElement withType:(NSString*)type
{
    NSString *respont= [NSString stringWithFormat:@"%@Response",type];
    NSString *result =  [NSString stringWithFormat:@"%@Result",type];

    
    TBXMLElement *respElement = [TBXML childElementNamed:respont parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:result parentElement:respElement];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_20" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_10" parentElement:TableElemnt]];
                NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_90" parentElement:TableElemnt]];
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_160" parentElement:TableElemnt]];
                NSString *imgurl = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_30" parentElement:TableElemnt]];
                NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"state" parentElement:TableElemnt]];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[title,Id,content,[time substringToIndex:10],imgurl,state] forKeys:@[@"title",@"Id",@"content",@"time",@"imgurl",@"state"]];
              
                
                [arr addObject:dic];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
  
    return nil;
}

#pragma mark
#pragma mark 获取通知信息列表
/**
 *  获取通知信息列表
 *
 *  @param bodyElement
 */
- (id)getNoticeList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetTZListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetTZListResult" parentElement:respElement];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_20" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_10" parentElement:TableElemnt]];
                NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_40" parentElement:TableElemnt]];
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_150" parentElement:TableElemnt]];
                NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"state" parentElement:TableElemnt]];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[title,Id,content,[time substringToIndex:10],state] forKeys:@[@"title",@"Id",@"content",@"time",@"state"]];
               
                [arr addObject:dic];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
    
    return nil;
}

#pragma mark
#pragma mark 获取通知详情数据
/**
 *  获取通知详情数据
 *
 *  @param bodyElement
 */
- (id)getNoticeDetail:(TBXMLElement*)bodyElement
{
   
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetTZResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetTZResult" parentElement:respElement];
    if (resultElement!=nil)
    {
        TBXMLElement *infotElement = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_20" parentElement:infotElement]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_40" parentElement:infotElement]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_150" parentElement:infotElement]];
        
        TBXMLElement *fjsElemnt = [TBXML childElementNamed:@"FJs" parentElement:infotElement];
        TBXMLElement *fjElemnt = [TBXML childElementNamed:@"FJ" parentElement:fjsElemnt];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        while (fjElemnt)
        {
            NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:fjElemnt]];
            NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:fjElemnt]];
            NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:fjElemnt]];
            NSString *size = [TBXML textForElement:[TBXML childElementNamed:@"Size" parentElement:fjElemnt]];
            NSDictionary *dic = @{@"title":title,@"Id":Id,@"type":type,@"size":size};
            [arr addObject:dic];
            
            fjElemnt = [TBXML nextSiblingNamed:@"FJ" searchFromElement:fjElemnt];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[title,content,time,arr] forKeys:@[@"title",@"content",@"time",@"attachments"]];
        return dict;
    }
    
    return nil;
}

#pragma mark
#pragma mark 获取新闻详情数据
/**
 *  获取新闻详情数据
 *
 *  @param bodyElement
 */
- (id)getNewsDetail:(TBXMLElement*)bodyElement withType:(NSString*)type
{
    NSString *respont= [NSString stringWithFormat:@"%@Response",type];
    NSString *result =  [NSString stringWithFormat:@"%@Result",type];
    
    TBXMLElement *respElement = [TBXML childElementNamed:respont parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:result parentElement:respElement];
    if (resultElement!=nil)
    {
        TBXMLElement *infotElement = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_20" parentElement:infotElement]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_90" parentElement:infotElement]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_160" parentElement:infotElement]];
          NSString *imgurl = [TBXML textForElement:[TBXML childElementNamed:@"IFC_30_COL_30" parentElement:infotElement]];
        
        TBXMLElement *fjsElemnt = [TBXML childElementNamed:@"FJs" parentElement:infotElement];
        TBXMLElement *fjElemnt = [TBXML childElementNamed:@"FJ" parentElement:fjsElemnt];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        while (fjElemnt)
        {
            NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:fjElemnt]];
            NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:fjElemnt]];
            NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:fjElemnt]];
            NSString *size = [TBXML textForElement:[TBXML childElementNamed:@"Size" parentElement:fjElemnt]];
            NSDictionary *dic = @{@"title":title,@"Id":Id,@"type":type,@"size":size};
            [arr addObject:dic];
            
            fjElemnt = [TBXML nextSiblingNamed:@"FJ" searchFromElement:fjElemnt];
        }
        
            
        return @{@"title":title,@"content":content,@"time":time,@"imgurl":imgurl,@"attachments":arr};
    }
    
    return nil;
    
}


#pragma mark
#pragma mark 获取新闻详情数据
/**
 *  获取新闻详情数据
 *
 *  @param bodyElement
 */
- (id)getTZDetail:(TBXMLElement*)bodyElement
{
 
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetTZResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetTZResult" parentElement:respElement];
    if (resultElement!=nil)
    {
        TBXMLElement *infotElement = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_20" parentElement:infotElement]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_40" parentElement:infotElement]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"NTE_30_COL_150" parentElement:infotElement]];
        
        return @{@"title":title,@"content":content,@"time":time};
    }
    
    return nil;
    
}

#pragma mark
#pragma mark 获取通讯录
/**
 *  获取通讯录
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)getAddressList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetSysAddress_BookResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetSysAddress_BookResult" parentElement:respElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement) {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];

         while (TableElemnt)
         {
             @autoreleasepool
             {
                 ContactsModel *contact = [[ContactsModel alloc]init];
                 
                 NSString *name = [TBXML textForElement:[TBXML childElementNamed:@"XM" parentElement:TableElemnt]];
                 NSString *userId = [TBXML textForElement:[TBXML childElementNamed:@"USERID" parentElement:TableElemnt]];
                 NSString *departmentId = [TBXML textForElement:[TBXML childElementNamed:@"DEPTID" parentElement:TableElemnt]];
                 NSString *department = [TBXML textForElement:[TBXML childElementNamed:@"DEPT" parentElement:TableElemnt]];
                 NSString *phoneNum = [TBXML textForElement:[TBXML childElementNamed:@"YDDH" parentElement:TableElemnt]];
                  NSString *telNum = [TBXML textForElement:[TBXML childElementNamed:@"BGDH" parentElement:TableElemnt]];
                 NSString *email1 = [TBXML textForElement:[TBXML childElementNamed:@"EMAIL" parentElement:TableElemnt]];
                 NSString *email2 = [TBXML textForElement:[TBXML childElementNamed:@"EMAIL2" parentElement:TableElemnt]];
                 
                 contact.name = name==nil?@"":name;
                 contact.usrId = userId==nil?@"":userId;
                 contact.departMentId = departmentId==nil?@"":departmentId;
                 contact.departMent = department==nil?@"":department;
                 contact.phoneNum = phoneNum==nil?@"":phoneNum;
                 contact.telNum = telNum==nil?@"":telNum;
                 contact.emailOne = email1==nil?@"":email1;
                 contact.emailTwo = email2==nil?@"":email2;
                 
                 //取得姓名拼音
                 if( contact.name==nil){
                     contact.name=@"";
                 }
                 if(![ contact.name isEqualToString:@""]){
                     NSString *pinYinResult=[NSString string];
                     for(int j=0;j<contact.name.length;j++){
                         NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([contact.name characterAtIndex:j])]uppercaseString];
                         
                         pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                     }
                     //NSLog(@"pinyinresult %@",pinYinResult);
                     contact.chinseStrOfName=pinYinResult;
                 }else{
                     contact.chinseStrOfName=@"";
                 }
                 
                 //取得部门的拼音
                 if( contact.departMent==nil){
                     contact.departMent=@"";
                 }
                 
                 if(![ contact.departMent isEqualToString:@""]){
                     NSString *pinYinResult=[NSString string];
                     for(int j=0;j<contact.departMent.length;j++){
                         NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([contact.departMent characterAtIndex:j])]uppercaseString];
                         
                         pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                     }
                     //NSLog(@"pinyinresult %@",pinYinResult);
                     contact.chinseStrOfDepartment=pinYinResult;
                 }else{
                     contact.chinseStrOfDepartment=@"";
                 }
                 
                 
                 [arr addObject:contact];
                 
                 TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
             }
         }
    
        
        return arr;
        
    }
    return nil;

}

#pragma mark
#pragma mark 获取日程首页未读条数
/**
 *  获取日程首页未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)GetRCUnreadCount:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetRCCountResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetRCCountResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }

}

#pragma mark
#pragma mark 获取日程列表
/**
 *  获取日程列表
 *
 *  @param bodyElement
 */
- (id)getCalendarList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetRCListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetRCListResult" parentElement:respElement];

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:TableElemnt]];
                NSString *arear = [TBXML textForElement:[TBXML childElementNamed:@"FW" parentElement:TableElemnt]];
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"Date" parentElement:TableElemnt]];
                 NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"State" parentElement:TableElemnt]];
                
                NSDictionary *dict = @{@"title":title,@"Id":Id,@"arear":arear,@"time":[time substringToIndex:10],@"state":state};
                [arr addObject:dict];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
    
    return nil;
}

#pragma mark
#pragma mark 获取日程详情
/**
 *  获取日程详情
 *
 *  @param bodyElement
 */
- (id)getCalendarDetail:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetRCResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetRCResult" parentElement:respElement];
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (resultElement)
    {
        
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:resultElement];

        NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:TableElemnt]];
        NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:TableElemnt]];
        NSString *arear = [TBXML textForElement:[TBXML childElementNamed:@"FW" parentElement:TableElemnt]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"Date" parentElement:TableElemnt]];
        NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"State" parentElement:TableElemnt]];
        NSString *man = [TBXML textForElement:[TBXML childElementNamed:@"ZXR" parentElement:TableElemnt]];
        NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"CYR" parentElement:TableElemnt]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NR" parentElement:TableElemnt]];
        
        NSDictionary *dic = @{@"title":title,@"Id":Id,@"arear":arear,@"time":time ,@"state":state,@"man":man,@"people":people,@"content":content};
        [dict setValuesForKeysWithDictionary:dic];
        
        
        TBXMLElement *fjsElemnt = [TBXML childElementNamed:@"FJs" parentElement:TableElemnt];
         TBXMLElement *fjElemnt = [TBXML childElementNamed:@"FJ" parentElement:fjsElemnt];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        while (fjElemnt)
        {
            NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:fjElemnt]];
            NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:fjElemnt]];
            NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:fjElemnt]];
            NSString *size = [TBXML textForElement:[TBXML childElementNamed:@"Size" parentElement:fjElemnt]];
            NSDictionary *dic = @{@"title":title,@"Id":Id,@"type":type,@"size":size};
            [arr addObject:dic];
            
             fjElemnt = [TBXML nextSiblingNamed:@"FJ" searchFromElement:fjElemnt];
        }

        [dict setObject:arr forKey:@"attachments"];

        return dict;
    }
   
    return nil;
}



#pragma mark
#pragma mark 获取集团活动列表
/**
 *  获取集团活动列表
 *
 *  @param bodyElement
 */
- (id)GetJTHDList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetJTHDListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetJTHDListResult" parentElement:respElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:TableElemnt]];
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"Date" parentElement:TableElemnt]];
                NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"State" parentElement:TableElemnt]];
                
                NSDictionary *dict = @{@"title":title,@"Id":Id,@"time":[time substringToIndex:10],@"state":state};
                [arr addObject:dict];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
  
    return nil;
}

#pragma mark
#pragma mark 获取集团活动详情
/**
 *  获取集团活动详情
 *
 *  @param bodyElement
 */
- (id)getActivityDetail:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetJTHDResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetJTHDResult" parentElement:respElement];
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (resultElement)
    {
        
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:TableElemnt]];
        NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:TableElemnt]];
        NSString *place = [TBXML textForElement:[TBXML childElementNamed:@"HDDD" parentElement:TableElemnt]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"Date" parentElement:TableElemnt]];
        NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"State" parentElement:TableElemnt]];
        NSString *department = [TBXML textForElement:[TBXML childElementNamed:@"FQBM" parentElement:TableElemnt]];
        NSString *leader = [TBXML textForElement:[TBXML childElementNamed:@"CJLD " parentElement:TableElemnt]];
        NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"CYR" parentElement:TableElemnt]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NR" parentElement:TableElemnt]];
        
        NSDictionary *dic = @{@"title":title,@"Id":Id,@"place":place,@"time":time ,@"state":state,@"department":department,@"people":people,@"content":content,@"leader":leader};
        [dict setValuesForKeysWithDictionary:dic];
        
        
        return dict;
    }
  
    return nil;
}

#pragma mark
#pragma mark 获取邮件未读条数
/**
 *  获取邮件未读条数
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)GetMailListUnreadCount:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetMailCountResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetMailCountResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}

#pragma mark
#pragma mark 获取内部邮件列表
/**
 *  获取内部邮件列表
 *
 *  @param bodyElement
 */
- (id)GetMailList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetMailListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetMailListResult" parentElement:respElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *theme = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_20" parentElement:TableElemnt]];
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_10" parentElement:TableElemnt]];
                 NSString *inId = [TBXML textForElement:[TBXML childElementNamed:@"EML_30_COL_10" parentElement:TableElemnt]];
                NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"SYS_30_COL_30" parentElement:TableElemnt]];
                
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_100" parentElement:TableElemnt]];
                NSString *fjcounts = [TBXML textForElement:[TBXML childElementNamed:@"FJCounts" parentElement:TableElemnt]];
                NSString *state = [TBXML textForElement:[TBXML childElementNamed:@"state" parentElement:TableElemnt]];
                
                NSDictionary *dict = @{@"theme":theme,@"Id":Id,@"inId":inId,@"people":people,@"time":time,@"fjcounts":fjcounts,@"state":state};
                
                
                [arr addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
 
    return nil;
}


#pragma mark
#pragma mark 获取邮件详情
/**
 *  获取邮件详情
 *
 *  @param bodyElement
 */
- (id)getEmailDetail:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetMailResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetMailResult" parentElement:respElement];
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (resultElement)
    {
        
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        NSString *theme = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_20" parentElement:TableElemnt]];
        NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_10" parentElement:TableElemnt]];
        NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_30" parentElement:TableElemnt]];
        NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_100" parentElement:TableElemnt]];
        NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"SYS_30_COL_30" parentElement:TableElemnt]];
        NSString *peopleId = [TBXML textForElement:[TBXML childElementNamed:@"EML_20_COL_90" parentElement:TableElemnt]];
        NSString *reciver = [TBXML textForElement:[TBXML childElementNamed:@"SJR" parentElement:TableElemnt]];
        
        NSDictionary *dic = @{@"theme":theme,@"Id":Id,@"content":content,@"time":time ,@"people":people,@"reciver":reciver,@"people":people,@"peopleId":peopleId,@"content":content};
        [dict setValuesForKeysWithDictionary:dic];
        
        
        TBXMLElement *fjsElemnt = [TBXML childElementNamed:@"FJs" parentElement:TableElemnt];
        TBXMLElement *fjElemnt = [TBXML childElementNamed:@"FJ" parentElement:fjsElemnt];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        while (fjElemnt)
        {
            NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:fjElemnt]];
            NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:fjElemnt]];
            NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:fjElemnt]];
            NSString *size = [TBXML textForElement:[TBXML childElementNamed:@"Size" parentElement:fjElemnt]];
            NSDictionary *dic = @{@"title":title,@"Id":Id,@"type":type,@"size":size};
            [arr addObject:dic];
            
            fjElemnt = [TBXML nextSiblingNamed:@"FJ" searchFromElement:fjElemnt];
        }
        
        [dict setObject:arr forKey:@"attachments"];
        
        return dict;
    }
   
    return nil;
}

#pragma mark
#pragma mark 发送邮件
/**
 *  发送邮件
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)sendEmail:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"WriteMailResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"WriteMailResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}

#pragma mark
#pragma mark 获取附件内容
/**
 *  获取附件内容
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)getAttachmentContent:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetAttResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetAttResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}

#pragma mark
#pragma mark 发送短信
/**
 *  发送短信
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)sendMessage:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"WriteSMSResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"WriteSMSResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}


#pragma mark
#pragma mark 获取短信列表
/**
 *  获取短信列表
 *
 *  @param bodyElement
 */
- (id)GetSMSList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetSMSListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetSMSListResult" parentElement:respElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *reciver = [TBXML textForElement:[TBXML childElementNamed:@"JSR" parentElement:TableElemnt]];
                NSString *phone = [TBXML textForElement:[TBXML childElementNamed:@"JSRHM" parentElement:TableElemnt]];
                NSString *content = [TBXML textForElement:[TBXML childElementNamed:@"NR" parentElement:TableElemnt]];
                
                NSString *time = [TBXML textForElement:[TBXML childElementNamed:@"Date" parentElement:TableElemnt]];
               
                
                NSDictionary *dict = @{@"reciver":reciver,@"phone":phone,@"content":content,@"time":time};
                [arr addObject:dict];
                
                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
  
    return nil;
}
//#pragma mark
//#pragma mark 获取流程和公文关联详情数据
///**
// *  获取流程和公文管理详情数据   操作时需按照返回的节点样式  同样的传回服务器  所以字段名取的都和服务器返回的一样
// *
// *  @param bodyElement
// */
//- (id)getDetail:(TBXMLElement*)bodyElement
//{
//    
//    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCBDResponse" parentElement:bodyElement];
//    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetLCBDResult" parentElement:respElement];
//    
//    if (resultElement)
//    {
//        
//        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
//        
//        //流程序号
//        NSString *FEG_20_COL_10 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_10" parentElement:TableElemnt]];
//        //办理序号
//        NSString *FEG_30_COL_10 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_30_COL_10" parentElement:TableElemnt]];
//        //流程标题
//        NSString *FEG_20_COL_20 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_20" parentElement:TableElemnt]];
//        
//        
//        TBXMLElement *activitysElemnt = [TBXML childElementNamed:@"Activitys" parentElement:TableElemnt];
//        TBXMLElement *activityElemnt = [TBXML childElementNamed:@"Activity" parentElement:activitysElemnt];
//        
//        NSMutableArray *actArr = [[NSMutableArray alloc]init];
//        while (activityElemnt)
//        {
//            @autoreleasepool
//            {
//                
//                
//                //是否选择此节点，1=选择，0=未选，流转提交时必须只能选择一个
//                NSString *Select = [TBXML textForElement:[TBXML childElementNamed:@"Select" parentElement:activityElemnt]];
//                
//                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:activityElemnt]];
//                NSString *Name = [TBXML textForElement:[TBXML childElementNamed:@"Name" parentElement:activityElemnt]];
//                NSString *Type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:activityElemnt]];
//                NSString *Mode = [TBXML textForElement:[TBXML childElementNamed:@"Mode" parentElement:activityElemnt]];
//                NSString *DealTime = [TBXML textForElement:[TBXML childElementNamed:@"DealTime" parentElement:activityElemnt]];
//                
//                //是否重置参与人
//                NSString *ReSelect = [TBXML textForElement:[TBXML childElementNamed:@"ReSelect" parentElement:activityElemnt]];
//                //是否重置主办人
//                NSString *Interpose = [TBXML textForElement:[TBXML childElementNamed:@"Interpose" parentElement:activityElemnt]];
//                
//                //主办人节点
//                TBXMLElement *ZBRElemnt = [TBXML childElementNamed:@"ZBR" parentElement:activityElemnt];
//                NSString *UserId = [TBXML textForElement:[TBXML childElementNamed:@"UserId" parentElement:ZBRElemnt]];
//                NSString *UserName = [TBXML textForElement:[TBXML childElementNamed:@"UserName" parentElement:ZBRElemnt]];
//                
//                
//                NSMutableDictionary *zbrDict = [NSMutableDictionary dictionaryWithDictionary:@{@"UserId":UserId,@"UserName":UserName}];
//                
//                //参与人节点
//                TBXMLElement *CYRsElemnt = [TBXML childElementNamed:@"CYRs" parentElement:activityElemnt];
//                TBXMLElement *CYRElemnt = [TBXML childElementNamed:@"CYR" parentElement:CYRsElemnt];
//                
//                NSMutableArray *cyrArr = [[NSMutableArray alloc]init];
//                
//                while (CYRElemnt)
//                {
//                    @autoreleasepool
//                    {
//                        
//                        NSString *UserId = [TBXML textForElement:[TBXML childElementNamed:@"UserId" parentElement:CYRElemnt]];
//                        NSString *UserName = [TBXML textForElement:[TBXML childElementNamed:@"UserName" parentElement:CYRElemnt]];
//                        
//                        NSDictionary *cyrDict = [NSDictionary dictionaryWithObject:@{@"UserId":UserId,@"UserName":UserName} forKey:@"CYR"];
//                        [cyrArr addObject:cyrDict];
//                        
//                        CYRElemnt = [TBXML nextSiblingNamed:@"CYR" searchFromElement:CYRElemnt];
//                    }
//                }
//                
//                NSMutableDictionary *activityDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Select":Select,@"Id":Id,@"Name":Name, @"Type":Type,@"Mode":Mode,@"DealTime":DealTime,@"ReSelect":ReSelect,@"Interpose":Interpose,@"ZBR":zbrDict,@"CYRs":cyrArr}];
//                [actArr addObject:activityDict];
//                
//                activityElemnt = [TBXML nextSiblingNamed:@"Activity" searchFromElement:activityElemnt];
//            }
//        }
//        
//        
//        
//        TBXMLElement *fieldsElemnt = [TBXML childElementNamed:@"Fields" parentElement:TableElemnt];
//        TBXMLElement *fieldElemnt = [TBXML childElementNamed:@"Field" parentElement:fieldsElemnt];
//        
//        NSMutableArray *fieldsArr = [[NSMutableArray alloc] init];
//        
//        while (fieldElemnt)
//        {
//            @autoreleasepool
//            {
//                
//                //数据项名称
//                NSString *LK_FIELDEDIT_TIPNAME = [TBXML textForElement:[TBXML childElementNamed:@"LK_FIELDEDIT_TIPNAME" parentElement:fieldElemnt]];
//                //数据类型
//                NSString *LK_FLDDBTYPE = [TBXML textForElement:[TBXML childElementNamed:@"LK_FLDDBTYPE" parentElement:fieldElemnt]];
//                //处理模式
//                NSString *LK_FIELDEDITMODE = [TBXML textForElement:[TBXML childElementNamed:@"LK_FIELDEDITMODE" parentElement:fieldElemnt]];
//                //显示内容
//                NSString *SHOWCONTENT = [TBXML textForElement:[TBXML childElementNamed:@"SHOWCONTENT" parentElement:fieldElemnt]];
//                //value
//                NSString *Value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:fieldElemnt]];
//                
//                TBXMLElement *optionsElement = [TBXML childElementNamed:@"OPTIONS" parentElement:fieldElemnt];
//                NSMutableDictionary *dict;
//                
//                //已经选择的项 用于后续保存操作
//                NSMutableArray *mubArr = [[NSMutableArray alloc]init];
//                
//                if (optionsElement!=nil)
//                {
//                    TBXMLElement *optionElemnt = [TBXML childElementNamed:@"Item" parentElement:optionsElement];
//                    
//                    
//                    NSMutableArray *itemArr = [[NSMutableArray alloc]init];
//                    while (optionElemnt)
//                    {
//                        @autoreleasepool
//                        {
//                            
//                            //保存值
//                            NSString *Value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:optionElemnt]];
//                            //显示值
//                            NSString *Text = [TBXML textForElement:[TBXML childElementNamed:@"Text" parentElement:optionElemnt]];
//                            
//                            //是否默认选项，1=默认选中
//                            NSString *DefaultFlag = [TBXML textForElement:[TBXML childElementNamed:@"DefaultFlag" parentElement:optionElemnt]];
//                            
//                            optionElemnt = [TBXML nextSiblingNamed:@"Item" searchFromElement:optionElemnt];
//                            ;
//                          
//                            
//                            [itemArr addObject:[NSMutableDictionary dictionaryWithObjects:@[Value,Text,DefaultFlag] forKeys:@[@"Value",@"Text",@"DefaultFlag"]]];
//                        }
//                    }
//                    
//                    dict = [NSMutableDictionary dictionaryWithDictionary:@{@"LK_FIELDEDIT_TIPNAME":LK_FIELDEDIT_TIPNAME,@"LK_FLDDBTYPE":LK_FLDDBTYPE,@"SHOWCONTENT":SHOWCONTENT,@"LK_FIELDEDITMODE":LK_FIELDEDITMODE,@"Value":Value,@"OPTIONS":itemArr,@"selectedOptions":mubArr}];
//                }
//                else
//                {
//                    dict = [NSMutableDictionary dictionaryWithDictionary:@{@"LK_FIELDEDIT_TIPNAME":LK_FIELDEDIT_TIPNAME,@"LK_FLDDBTYPE":LK_FLDDBTYPE,@"SHOWCONTENT":SHOWCONTENT,@"LK_FIELDEDITMODE":LK_FIELDEDITMODE,@"Value":Value,@"selectedOptions":mubArr}];
//                }
//                
//                NSMutableDictionary *fieldDict = [[NSMutableDictionary alloc]init];
//                [fieldDict setObject:dict forKey:@"Field"];
//                [fieldsArr addObject:dict];
//                
//                fieldElemnt = [TBXML nextSiblingNamed:@"Field" searchFromElement:fieldElemnt];
//            }
//        }
//        
//        NSLog(@"ddddd:%@",[NSMutableDictionary dictionaryWithDictionary:@{@"FEG_20_COL_10":FEG_20_COL_10,@"FEG_20_COL_20":FEG_20_COL_20,@"FEG_30_COL_10":FEG_30_COL_10,@"Activitys":actArr,@"Fields":fieldsArr}]);
//        
//        return [NSMutableDictionary dictionaryWithDictionary:@{@"FEG_20_COL_10":FEG_20_COL_10,@"FEG_20_COL_20":FEG_20_COL_20,@"FEG_30_COL_10":FEG_30_COL_10,@"Activity":actArr,@"Field":fieldsArr}];
//    }
//    
//    return nil;
//}

#pragma mark
#pragma mark 获取流程和公文关联详情数据
/**
 *  获取流程和公文管理详情数据   操作时需按照返回的节点样式  同样的传回服务器  所以字段名取的都和服务器返回的一样
 *
 *  @param bodyElement
 */
- (id)getDetail:(TBXMLElement*)bodyElement
{
    
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCBDResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetLCBDResult" parentElement:respElement];
    
    if (resultElement)
    {
        
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:resultElement];
        
        //流程序号
        NSString *FEG_20_COL_10 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_10" parentElement:TableElemnt]];
        //办理序号
        NSString *FEG_30_COL_10 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_30_COL_10" parentElement:TableElemnt]];
        //流程标题
        NSString *FEG_20_COL_20 = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_20" parentElement:TableElemnt]];
        
        TBXMLElement *cyyjElemnt = [TBXML childElementNamed:@"CYYJ" parentElement:TableElemnt];
        TBXMLElement *itemElemnt = [TBXML childElementNamed:@"Item" parentElement:cyyjElemnt];
        
        NSMutableArray *cyyjArr = [NSMutableArray arrayWithArray:0];
        
        while (itemElemnt)
        {
            @autoreleasepool
            {
                NSString *item =  [TBXML textForElement:itemElemnt];
                [cyyjArr addObject:item];
                itemElemnt = [TBXML nextSiblingNamed:@"Item" searchFromElement:itemElemnt];
            }
        }
        
        TBXMLElement *ParttimesElemnt = [TBXML childElementNamed:@"Parttimes" parentElement:TableElemnt];
        TBXMLElement *ParttimeitemElemnt = [TBXML childElementNamed:@"Parttime" parentElement:ParttimesElemnt];
        
        NSMutableArray *ParttimesArr = [NSMutableArray arrayWithArray:0];
        
        while (ParttimeitemElemnt)
        {
            @autoreleasepool
            {
                NSMutableDictionary *temDict = [[NSMutableDictionary alloc]init];
                
                [temDict setObject:[TBXML textForElement:[TBXML childElementNamed:@"DeptId" parentElement:ParttimeitemElemnt]] forKey:@"DeptId"];
                 [temDict setObject:[TBXML textForElement:[TBXML childElementNamed:@"DeptName" parentElement:ParttimeitemElemnt]] forKey:@"DeptName"];
                 [temDict setObject:[TBXML textForElement:[TBXML childElementNamed:@"PostId" parentElement:ParttimeitemElemnt]] forKey:@"PostId"];
                [temDict setObject:[TBXML textForElement:[TBXML childElementNamed:@"PostName" parentElement:ParttimeitemElemnt]] forKey:@"PostName"];
                [ParttimesArr addObject:temDict];
                
                ParttimeitemElemnt = [TBXML nextSiblingNamed:@"Parttime" searchFromElement:ParttimeitemElemnt];
            }
        }
        
        
        TBXMLElement *activitysElemnt = [TBXML childElementNamed:@"Activitys" parentElement:TableElemnt];
        TBXMLElement *activityElemnt = [TBXML childElementNamed:@"Activity" parentElement:activitysElemnt];
        
        NSMutableArray *actArr = [[NSMutableArray alloc]init];
        while (activityElemnt)
        {
            @autoreleasepool
            {
               
                
                //是否选择此节点，1=选择，0=未选，流转提交时必须只能选择一个
                NSString *Select = [TBXML textForElement:[TBXML childElementNamed:@"Select" parentElement:activityElemnt]];
                
                 NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:activityElemnt]];
                NSString *Name = [TBXML textForElement:[TBXML childElementNamed:@"Name" parentElement:activityElemnt]];
                NSString *Type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:activityElemnt]];
                NSString *Mode = [TBXML textForElement:[TBXML childElementNamed:@"Mode" parentElement:activityElemnt]];
                NSString *DealTime = [TBXML textForElement:[TBXML childElementNamed:@"DealTime" parentElement:activityElemnt]];
                
                //是否重置参与人
                NSString *ReSelect = [TBXML textForElement:[TBXML childElementNamed:@"ReSelect" parentElement:activityElemnt]];
                //是否重置主办人
                NSString *Interpose = [TBXML textForElement:[TBXML childElementNamed:@"Interpose" parentElement:activityElemnt]];
                
                //主办人节点
                TBXMLElement *ZBRElemnt = [TBXML childElementNamed:@"ZBR" parentElement:activityElemnt];
                NSString *UserId = [TBXML textForElement:[TBXML childElementNamed:@"UserId" parentElement:ZBRElemnt]];
                  NSString *UserName = [TBXML textForElement:[TBXML childElementNamed:@"UserName" parentElement:ZBRElemnt]];
                
                
                NSMutableDictionary *zbrDict = [NSMutableDictionary dictionaryWithDictionary:@{@"UserId":UserId,@"UserName":UserName}];
                
                //参与人节点
                TBXMLElement *CYRsElemnt = [TBXML childElementNamed:@"CYRs" parentElement:activityElemnt];
                TBXMLElement *CYRElemnt = [TBXML childElementNamed:@"CYR" parentElement:CYRsElemnt];
                
                NSMutableArray *cyrArr = [[NSMutableArray alloc]init];
                
                while (CYRElemnt)
                {
                    @autoreleasepool
                    {
                
                        NSString *UserId = [TBXML textForElement:[TBXML childElementNamed:@"UserId" parentElement:CYRElemnt]];
                        NSString *UserName = [TBXML textForElement:[TBXML childElementNamed:@"UserName" parentElement:CYRElemnt]];
                        
                        NSDictionary *cyrDict = [NSDictionary dictionaryWithObject:@{@"UserId":UserId,@"UserName":UserName} forKey:@"CYR"];
                        [cyrArr addObject:cyrDict];
                        
                        CYRElemnt = [TBXML nextSiblingNamed:@"CYR" searchFromElement:CYRElemnt];
                    }
                }
                
                NSMutableDictionary *activityDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Select":Select,@"Id":Id,@"Name":Name, @"Type":Type,@"Mode":Mode,@"DealTime":DealTime,@"ReSelect":ReSelect,@"Interpose":Interpose,@"ZBR":zbrDict,@"CYRs":cyrArr}];
                
                [actArr addObject:[NSMutableDictionary dictionaryWithObject:activityDict forKey:@"Activity"]];
                
                 activityElemnt = [TBXML nextSiblingNamed:@"Activity" searchFromElement:activityElemnt];
            }
        }
        
        
        
        TBXMLElement *fieldsElemnt = [TBXML childElementNamed:@"Fields" parentElement:TableElemnt];
        TBXMLElement *fieldElemnt = [TBXML childElementNamed:@"Field" parentElement:fieldsElemnt];
        
        NSMutableArray *fieldsArr = [[NSMutableArray alloc] init];
        
        while (fieldElemnt)
        {
            @autoreleasepool
            {
                
                //数据项名称
                NSString *LK_FIELDEDIT_TIPNAME = [TBXML textForElement:[TBXML childElementNamed:@"LK_FIELDEDIT_TIPNAME" parentElement:fieldElemnt]];
                //数据类型
                NSString *LK_FLDDBTYPE = [TBXML textForElement:[TBXML childElementNamed:@"LK_FLDDBTYPE" parentElement:fieldElemnt]];
                //处理模式
                NSString *LK_FIELDEDITMODE = [TBXML textForElement:[TBXML childElementNamed:@"LK_FIELDEDITMODE" parentElement:fieldElemnt]];
                
                //数据模式
                 NSString *LK_COLFIELDID = [TBXML textForElement:[TBXML childElementNamed:@"LK_COLFIELDID" parentElement:fieldElemnt]];
                //显示内容
                NSString *SHOWCONTENT = [TBXML textForElement:[TBXML childElementNamed:@"SHOWCONTENT" parentElement:fieldElemnt]];
                //value
                NSString *Value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:fieldElemnt]];
                //ParttimeDept
                NSString *ParttimeDept = [TBXML textForElement:[TBXML childElementNamed:@"ParttimeDept" parentElement:fieldElemnt]];
                //ParttimePost
                NSString *ParttimePost = [TBXML textForElement:[TBXML childElementNamed:@"ParttimePost" parentElement:fieldElemnt]];
                

                TBXMLElement *optionsElement = [TBXML childElementNamed:@"OPTIONS" parentElement:fieldElemnt];
                  NSMutableDictionary *dict;
                
                //已经选择的项 用于后续保存操作
                NSMutableArray *mubArr = [[NSMutableArray alloc]init];
                
                if (optionsElement!=nil)
                {
                    TBXMLElement *optionElemnt = [TBXML childElementNamed:@"Item" parentElement:optionsElement];
                    
                    
                    NSMutableArray *itemArr = [[NSMutableArray alloc]init];
                    while (optionElemnt)
                    {
                        @autoreleasepool
                        {
                            
                            //保存值
                            NSString *Value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:optionElemnt]];
                            //显示值
                            NSString *Text = [TBXML textForElement:[TBXML childElementNamed:@"Text" parentElement:optionElemnt]];
                            
                            //是否默认选项，1=默认选中
                            NSString *DefaultFlag = [TBXML textForElement:[TBXML childElementNamed:@"DefaultFlag" parentElement:optionElemnt]];
                            
                            optionElemnt = [TBXML nextSiblingNamed:@"Item" searchFromElement:optionElemnt];
                            ;
                             NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjects:@[Value,Text,DefaultFlag] forKeys:@[@"Value",@"Text",@"DefaultFlag"]]forKey:@"Item"];

                            
                            [itemArr addObject:itemDict];
                        }
                    }
                    
//                     dict = [NSMutableDictionary dictionaryWithDictionary:@{@"LK_FIELDEDIT_TIPNAME":LK_FIELDEDIT_TIPNAME,@"LK_FLDDBTYPE":LK_FLDDBTYPE,@"SHOWCONTENT":SHOWCONTENT,@"LK_FIELDEDITMODE":LK_FIELDEDITMODE,@"Value":Value,@"OPTIONS":itemArr,@"selectedOptions":mubArr}];
                    
                    dict = [NSMutableDictionary dictionaryWithObjects:@[LK_COLFIELDID,LK_FIELDEDIT_TIPNAME,LK_FLDDBTYPE,SHOWCONTENT,LK_FIELDEDITMODE,Value,mubArr,itemArr,ParttimePost,ParttimeDept] forKeys:@[@"LK_COLFIELDID",@"LK_FIELDEDIT_TIPNAME",@"LK_FLDDBTYPE",@"SHOWCONTENT",@"LK_FIELDEDITMODE",@"Value",@"selectedOptions",@"OPTIONS",@"ParttimePost",@"ParttimeDept"]];
                }
                else
                {
//                     dict = [NSMutableDictionary dictionaryWithDictionary:@{@"LK_FIELDEDIT_TIPNAME":LK_FIELDEDIT_TIPNAME,@"LK_FLDDBTYPE":LK_FLDDBTYPE,@"SHOWCONTENT":SHOWCONTENT,@"LK_FIELDEDITMODE":LK_FIELDEDITMODE,@"Value":Value,@"selectedOptions":mubArr}];
                    dict = [NSMutableDictionary dictionaryWithObjects:@[LK_COLFIELDID,LK_FIELDEDIT_TIPNAME,LK_FLDDBTYPE,SHOWCONTENT,LK_FIELDEDITMODE,Value,mubArr] forKeys:@[@"LK_COLFIELDID",@"LK_FIELDEDIT_TIPNAME",@"LK_FLDDBTYPE",@"SHOWCONTENT",@"LK_FIELDEDITMODE",@"Value",@"selectedOptions"]];
                }
                
                NSMutableDictionary *fieldDict = [[NSMutableDictionary alloc]init];
                [fieldDict setObject:dict forKey:@"Field"];
                [fieldsArr addObject:fieldDict];
                
                fieldElemnt = [TBXML nextSiblingNamed:@"Field" searchFromElement:fieldElemnt];
            }
        }
        
     
        
//        return [NSMutableDictionary dictionaryWithDictionary:@{@"FEG_20_COL_10":FEG_20_COL_10,@"FEG_20_COL_20":FEG_20_COL_20,@"FEG_30_COL_10":FEG_30_COL_10,@"Activitys":actArr,@"Fields":fieldsArr}];
        
        return [NSMutableDictionary dictionaryWithObjects:@[FEG_20_COL_10,FEG_20_COL_20,FEG_30_COL_10,actArr,fieldsArr,cyyjArr,ParttimesArr] forKeys:@[@"FEG_20_COL_10",@"FEG_20_COL_20",@"FEG_30_COL_10",@"Activitys",@"Fields",@"CYYJ",@"Parttimes"]];
    }
   
    return nil;
}

#pragma mark
#pragma mark 获取表单正文url
/**
 *  获取表单正文url
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)GetContentUrl:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCZWResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"GetLCZWResult" parentElement:respElement]];
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}


#pragma mark
#pragma mark 获取附件列表
/**
 *  获取附件列表
 *
 *  @param bodyElement
 */
- (id)GetAttachmentList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetAttListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetAttListResult" parentElement:respElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        
        TBXMLElement *calendarElement = [TBXML childElementNamed:@"FJs" parentElement:resultElement];
        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"FJ" parentElement:calendarElement];
        while (TableElemnt)
        {
            @autoreleasepool
            {
                NSString *Id = [TBXML textForElement:[TBXML childElementNamed:@"Id" parentElement:TableElemnt]];
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:TableElemnt]];
                NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:TableElemnt]];
                
                NSString *size = [TBXML textForElement:[TBXML childElementNamed:@"Size" parentElement:TableElemnt]];
                
                NSDictionary *dict = @{@"Id":Id,@"title":title,@"type":type,@"size":size};
                [arr addObject:dict];
                
                TableElemnt = [TBXML nextSiblingNamed:@"FJ" searchFromElement:TableElemnt];
            }
        }
        
        return arr;
    }
  
    return nil;
}

#pragma mark
#pragma mark 表单提交或保存
/**
 *  表单提交或保存
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)SetGLBD:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"SetGLBDResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"SetGLBDResult" parentElement:respElement]];
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}


#pragma mark
#pragma mark 获取部门信息
/**
 *  获取部门信息
 *
 *  @param bodyElement
 */
- (id)GetDepartmentInfo:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetDeptResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetDeptResult" parentElement:respElement];
    
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultElement)
    {
        TBXMLElement *inforsElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
        NSLog(@"ddd %@", [self infoOfElement:inforsElement]);
        return [self infoOfElement:inforsElement];
        
//        TBXMLElement *calendarElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
//        TBXMLElement *TableElemnt = [TBXML childElementNamed:@"Infor" parentElement:calendarElement];
//        while (TableElemnt)
//        {
//            @autoreleasepool
//            {
//                NSString *DeptId = [TBXML textForElement:[TBXML childElementNamed:@"DeptId" parentElement:TableElemnt]];
//                NSString *DeptName = [TBXML textForElement:[TBXML childElementNamed:@"DeptName" parentElement:TableElemnt]];
//                
//                
//                TBXMLElement *ChildInforsElemnt = [TBXML childElementNamed:@"ChildInfors" parentElement:TableElemnt];
//                
//                NSMutableArray *childs = [[NSMutableArray alloc]init];
//                
//                if (ChildInforsElemnt)
//                {
//                    
//                TBXMLElement *ChildElemnt = [TBXML childElementNamed:@"Infor" parentElement:ChildInforsElemnt];
//                
//                    while (ChildElemnt)
//                    {
//                        @autoreleasepool
//                        {
//                            
//                            NSString *DeptId = [TBXML textForElement:[TBXML childElementNamed:@"DeptId" parentElement:ChildElemnt]];
//                            NSString *DeptName = [TBXML textForElement:[TBXML childElementNamed:@"DeptName" parentElement:ChildElemnt]];
//                            
//                            [childs addObject:@{@"DeptId":DeptId,@"DeptName":DeptName}];
//                            
//                            ChildElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:ChildElemnt];
//                        }
//                    }
//                    
//                }
//                
//                NSDictionary *dict = @{@"DeptId":DeptId,@"DeptName":DeptName,@"ChildInfors":childs};
//                [arr addObject:dict];
//                
//                TableElemnt = [TBXML nextSiblingNamed:@"Infor" searchFromElement:TableElemnt];
//            }
//        }
//        
//        return arr;
    }
    
    return nil;
}
#pragma mark
#pragma mark 获取从表信息
/**
 *  获取从表信息
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)getSubTable:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetLCBDCBResponse" parentElement:bodyElement];
     TBXMLElement *resultElement = [TBXML childElementNamed:@"GetLCBDCBResult" parentElement:respElement];
    if (resultElement==nil)
    {
        return nil;
    }
    
    TBXMLElement *infosElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (infosElement!=nil)
    {
        TBXMLElement *tableElemnt = [TBXML childElementNamed:@"Table" parentElement:infosElement];
        while (tableElemnt)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
            TBXMLElement *theadElemnt = [TBXML childElementNamed:@"Thead" parentElement:tableElemnt];
            
            
            TBXMLElement *trElemnt = [TBXML childElementNamed:@"Tr" parentElement:theadElemnt];
            TBXMLElement *thElemnt = [TBXML childElementNamed:@"Th" parentElement:trElemnt];
            NSMutableArray *thArr = [[NSMutableArray alloc]init];
            NSMutableArray *widthArr = [[NSMutableArray alloc]init];
        
            while (thElemnt)
            {
                @autoreleasepool
                {
                    NSString *thead = [TBXML textForElement:[TBXML childElementNamed:@"des" parentElement:thElemnt]];
                    [thArr addObject:thead];
                    
                    NSString *width = [TBXML textForElement:[TBXML childElementNamed:@"width" parentElement:thElemnt]];
                    [widthArr addObject:width];
                    
                    thElemnt = [TBXML nextSiblingNamed:@"Th" searchFromElement:thElemnt];
                }
            }
            [dict setObject:thArr forKey:@"head"];
            [dict setObject:widthArr forKey:@"width"];
            
            TBXMLElement *tbodyElemnt = [TBXML childElementNamed:@"Tbody" parentElement:tableElemnt];
            TBXMLElement *bodytrElemnt = [TBXML childElementNamed:@"Tr" parentElement:tbodyElemnt];
            
             NSMutableArray *tdArr = [[NSMutableArray alloc]init];
            while (bodytrElemnt)
            {
                TBXMLElement *bodythElemnt = [TBXML childElementNamed:@"Td" parentElement:bodytrElemnt];
                
                 NSMutableArray *Arrry = [[NSMutableArray alloc]init];
                while (bodythElemnt)
                {
                    @autoreleasepool
                    {
                        NSString *thody = [TBXML textForElement:[TBXML childElementNamed:@"des" parentElement:bodythElemnt]];
                        [Arrry addObject:thody];
                        
                        bodythElemnt = [TBXML nextSiblingNamed:@"Td" searchFromElement:bodythElemnt];
                    }
                }
                
                [tdArr addObject:Arrry];
                
                [dict setObject:tdArr forKey:@"body"];
                
                 bodytrElemnt = [TBXML nextSiblingNamed:@"Tr" searchFromElement:bodytrElemnt];
            }
            
            [arr addObject:dict];
            tableElemnt = [TBXML nextSiblingNamed:@"Table" searchFromElement:tableElemnt];

        }
        
        NSLog(@"arr is %@",arr);
         return arr;
    }
   
   
    return nil;
    
}

#pragma mark
#pragma mark 获取关联流程列表
/**
 *  获取关联流程列表
 *
 *  @param bodyElement
 */
- (id)GetGLLCList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetGLLCListResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetGLLCListResult" parentElement:respElement];
    TBXMLElement *inforsElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (inforsElement)
    {
        
        TBXMLElement *inforElement = [TBXML childElementNamed:@"Infor" parentElement:inforsElement];
        while (inforElement)
        {
            @autoreleasepool
            {
                NSString *people = [TBXML textForElement:[TBXML childElementNamed:@"SYS_30_COL_30" parentElement:inforElement]];
                NSString *title = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_20" parentElement:inforElement]];
                NSString *type = [TBXML textForElement:[TBXML childElementNamed:@"FEG_15_COL_20" parentElement:inforElement]];
                
                NSString *work = [TBXML textForElement:[TBXML childElementNamed:@"FRM_20_COL_20" parentElement:inforElement]];
                 NSString *idStr = [TBXML textForElement:[TBXML childElementNamed:@"FEG_20_COL_10" parentElement:inforElement]];
                
                NSDictionary *dict = @{@"people":people,@"title":title,@"type":type,@"work":work,@"id":idStr};
                [arr addObject:dict];
                
                inforElement = [TBXML nextSiblingNamed:@"Infor" searchFromElement:inforElement];
            }
        }
        
        return arr;
    }
    
    return nil;
}

#pragma mark
#pragma mark 删除邮件
/**
 *  删除邮件
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)deleteEmail:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"DelMailResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"DelMailResult" parentElement:respElement]];
    
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}


#pragma mark
#pragma mark 获取人员考勤列表
/**
 *  获取人员考勤列表
 *
 *  @param bodyElement
 */
- (id)GetKaoQinList:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"GetKaoQinResponse" parentElement:bodyElement];
    TBXMLElement *resultElement = [TBXML childElementNamed:@"GetKaoQinResult" parentElement:respElement];
    TBXMLElement *inforsElement = [TBXML childElementNamed:@"Infors" parentElement:resultElement];
    
    NSString *adminInfo = [TBXML textForElement:[TBXML childElementNamed:@"Admin" parentElement:inforsElement]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:adminInfo forKey:@"userType"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (inforsElement)
    {
        
        TBXMLElement *inforElement = [TBXML childElementNamed:@"Infor" parentElement:inforsElement];
        
        while (inforElement)
        {
            @autoreleasepool
            {
                NSString *DeptName = [TBXML textForElement:[TBXML childElementNamed:@"DeptName" parentElement:inforElement]];
                NSString *CHECKTIME = [TBXML textForElement:[TBXML childElementNamed:@"CHECKTIME" parentElement:inforElement]];
                NSString *CHECKTYPE = [TBXML textForElement:[TBXML childElementNamed:@"CHECKTYPE" parentElement:inforElement]];
                
            
                
                NSDictionary *dict = @{@"DeptName":DeptName,@"CHECKTIME":CHECKTIME,@"type":CHECKTIME,@"CHECKTYPE":CHECKTYPE};
                [arr addObject:dict];
                
                inforElement = [TBXML nextSiblingNamed:@"Infor" searchFromElement:inforElement];
            }
        }
        
         [dict setObject:arr forKey:@"list"];
        return dict;
    }
    
    return nil;
}

#pragma mark
/**
 *  表单提交或保存
 *
 *  @param bodyElement
 *
 *  @return
 */
- (id)getAllUndo:(TBXMLElement*)bodyElement
{
    TBXMLElement *respElement = [TBXML childElementNamed:@"AllReceiveResponse" parentElement:bodyElement];
    NSString *reuslt = [TBXML textForElement:[TBXML childElementNamed:@"AllReceiveResult" parentElement:respElement]];
    
    if (reuslt)
    {
        return reuslt;
        
    } else {
        return nil;
    }
    
}

@end
