//
//  HomeViewController.m
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "HomeViewController.h"
#import "MessCenterMainViewController.h"
#import "FlowManageMainViewController.h"
#import "EmailMainViewController.h"
#import "DocumentTransactViewController.h"
#import "CalendarMainViewController.h"
#import "AddressListViewController.h"
#import "MyMessageListViewController.h"
#import "MyMessageMainViewController.h"
#import "PersonalManageViewController.h"
#import "TBXML.h"

#define Action_Tag_MessCenter       100 //信息中心
#define Action_Tag_FlowTransact     101 //流程管理
#define Action_Tag_DocumentTransact 102 //公文办理
#define Action_Tag_Calendar         103 //日程管理
#define Action_Tag_AddressList      104 //通讯录
#define Action_Tag_MyEmail          105 //我的邮件
#define Action_Tag_Message          106 //我的短信
#define Action_Tag_PersonelManage   107 //人事管理
#define Action_Tag_LoginOut         108 //退出登录

#define Alert_Tag_LoginOut          200 //退出登录alert
#define Alert_Tag_Verson            201 //版本更新


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.helloLabel setAdjustsFontSizeToFitWidth:YES];
    NSString *lastTime = [UserDefaults objectForKey:kLastLoginTime];
    if ([StaticTools isEmptyString:lastTime])
    {
         self.helloLabel.text = [NSString stringWithFormat:@"%@,您好，欢迎登录。",ShareManager.userName];
    }
    else
    {
       self.helloLabel.text = [NSString stringWithFormat:@"%@,您好，上次登录%@",ShareManager.userName,lastTime];
    }
    [self.helloLabel setAdjustsFontSizeToFitWidth:YES];
     [UserDefaults setObject:[StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:YES] forKey:kLastLoginTime];
    [UserDefaults synchronize];
    
    [self getUnreadNum];
    
    [NSThread detachNewThreadSelector:@selector(getVersion) toTarget:self withObject:nil];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取当前软件版本
 *
 *  @return
 */
- (NSString*)getCurrentVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return localVersion;
}
#pragma mark
#pragma mark HTTP请求
/**
 *  获取未读条数
 */
- (void)getUnreadNum
{
    NSDictionary *dict = @{kMethodName:@"GetGLZXCount",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                 NSString *result = (NSString*)obj;
                                                 NSArray *numArr = [result componentsSeparatedByString:@";"];
                                                 self.myUndo.text = [NSString stringWithFormat:@"(%@)",numArr[0]];
                                                 self.todayDocument.text = [NSString stringWithFormat:@"(%@)",numArr[1]];
                                                 self.messageCenter.text = [NSString stringWithFormat:@"(%@)",numArr[2]];
                                                 self.calendar.text = [NSString stringWithFormat:@"(%@)",numArr[3]];
                                                 self.myEmail.text = [NSString stringWithFormat:@"(%@)",numArr[4]];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"待办项目查询失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    

    
}


/**
 *  获取版本更新
 */
- (void)getVersion
{
    
    NSString *host = [UserDefaults objectForKey:kHostAddress];
    NSString *urlString= [NSString stringWithFormat:@"%@iPhoneUpdate.xml",host];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 60];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    
    // Response对象，用来得到返回后的数据，比如，用statusCode==200 来判断返回正常
    NSHTTPURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:nil];
    
    // 处理返回的数据
    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strReturn);
    
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLString:strReturn error:&error];
    if (error)
    {
        return;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement)
    {
        NSString *version = [TBXML textForElement:[TBXML childElementNamed:@"version" parentElement:rootElement]];
        version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        self.versionUrl = [TBXML textForElement:[TBXML childElementNamed:@"url" parentElement:rootElement]];
        
        NSString *localVersion = [self getCurrentVersion];
        localVersion = [localVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if ([version integerValue]>[localVersion integerValue])
        {
            [StaticTools showAlertWithTag:Alert_Tag_Verson
                                    title:nil
                                  message:@"检测到新版本，是否安装更新？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
        }
    }
}

#pragma mark- UIAletViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Alert_Tag_LoginOut)
    {
        if (buttonIndex!=alertView.cancelButtonIndex)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }
    else  if(alertView.tag == Alert_Tag_Verson)
    {
        if (buttonIndex!=alertView.cancelButtonIndex)
        {
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.versionUrl]];
            
        }
    }
}

#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_MessCenter: //信息中心
        {
            MessCenterMainViewController *messCenterMainController = [[MessCenterMainViewController alloc]initWithNibName:@"MessCenterMainViewController" bundle:nil];
            [self.navigationController pushViewController:messCenterMainController animated:YES];
        }
            break;
        case Action_Tag_FlowTransact: //流程管理
        {
            FlowManageMainViewController *flowManageMainController = [[FlowManageMainViewController alloc]initWithNibName:@"FlowManageMainViewController" bundle:nil];
            [self.navigationController pushViewController:flowManageMainController animated:YES];
        }
         
            break;
        case Action_Tag_DocumentTransact: //公文管理
        {
            DocumentTransactViewController *documentTransactController = [[DocumentTransactViewController alloc]initWithNibName:@"DocumentTransactViewController" bundle:nil];
            [self.navigationController pushViewController:documentTransactController animated:YES];
        }
            break;
        case Action_Tag_Calendar: //日程安排
        {
            CalendarMainViewController *calendarMainController = [[CalendarMainViewController alloc]initWithNibName:@"CalendarMainViewController" bundle:nil];
            [self.navigationController pushViewController:calendarMainController animated:YES];
        }
            break;
        case Action_Tag_AddressList: //通讯录
        {
            AddressListViewController *addressListController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
            [self.navigationController pushViewController:addressListController animated:YES];
        }
            break;
        case Action_Tag_MyEmail: //我的邮件
        {
            EmailMainViewController *emailMainController = [[EmailMainViewController alloc]initWithNibName:@"EmailMainViewController" bundle:nil];
            [self.navigationController pushViewController:emailMainController animated:YES];
        }
            break;
        case Action_Tag_Message: //我的短信
        {
            MyMessageMainViewController *myMessageMainController = [[MyMessageMainViewController alloc]initWithNibName:@"MyMessageMainViewController" bundle:nil];
            [self.navigationController pushViewController:myMessageMainController animated:YES];
            
        }
            break;
        case Action_Tag_PersonelManage: //人事管理
        {
            PersonalManageViewController *personManageController = [[PersonalManageViewController alloc]init];
            [self.navigationController pushViewController:personManageController animated:YES];
        }
            break;
            
        case Action_Tag_LoginOut: //退出登录
        {
            [StaticTools showAlertWithTag:Alert_Tag_LoginOut
                                    title:nil
                                  message:@"您确认要退出吗？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
        }
        default:
            break;
    }
}

@end
