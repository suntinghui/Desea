//
//  LoginViewController.m
//  Desea
//
//  Created by wenbin on 14-1-8.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "Transfer.h"


#define Action_Tag_GotoSetting   100  //跳转到设置
#define Action_Tag_RememberPsw   101  //记住密码
#define Action_Tag_AutoLogin     102  //自动登录
#define Action_Tag_Login         103  //登录
#define Action_Tag_SetOk         104  //设置--确定
#define Action_Tag_SetCancel     105  //设置--取消



@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.navigationController.navigationBarHidden = YES;
    
    NSString *lastLoginName = [UserDefaults objectForKey:KUSERNAME];
    NSString *isRememberPsw = [UserDefaults objectForKey:kREMEBERPWD];
    NSString *isAutoLogin = [UserDefaults objectForKey:kAUTOLOGIN];
    
    if (![StaticTools isEmptyString:lastLoginName])
    {
        self.nameTxtField.text = lastLoginName;
    }
    
    
    if ([isRememberPsw isEqualToString:@"1"]) //记住了密码
    {
        self.pswTxtField.text = [UserDefaults objectForKey:kPASSWORD];
        UIButton *rememerPswBtn = (UIButton*)[self.view viewWithTag:Action_Tag_RememberPsw];
        rememerPswBtn.selected = YES;
    }
    
    if ([isAutoLogin isEqualToString:@"1"]&&![StaticTools isEmptyString:lastLoginName]) //自动登录
    {
        self.nameTxtField.text = lastLoginName;
        self.pswTxtField.text = [UserDefaults objectForKey:kPASSWORD];
        [self loginAction];
    }
    
    //点击设置按钮时addsubview不起作用  原因暂时未知 所以先添加且隐藏起来
    [self.view addSubview:self.setingView];
    self.setingView.hidden = YES;
    if (![StaticTools isEmptyString:[UserDefaults objectForKey:kHostAddress]])
    {
        self.hostTxtField.text = [UserDefaults objectForKey:kHostAddress];
    }
    else
    {
        self.hostTxtField.text = DEFAULTHOST;
    }
    
       
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-
#pragma mark--功能函数
/**
 *  检查页面输入合法性
 *
 *  @return
 */
- (BOOL)checkInputValue
{
    NSString *errStr = nil;
    
    if ([StaticTools isEmptyString:self.nameTxtField.text])
    {
        errStr = @"请输入用户名";
    }
    else if([StaticTools isEmptyString:self.pswTxtField.text])
    {
         errStr = @"请输入密码";
    }
    
    if (errStr!=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return NO;
    }
    return YES;
}

#pragma mark-
#pragma mark--HTTP请求
- (void)loginAction
{
    //测试账号：  test 68528888qg
    NSDictionary *dict = @{kMethodName:@"Login",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"LoginName ":self.nameTxtField.text,
                                        @"Pwd":self.pswTxtField.text}};
  
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
            {
                if ([obj isKindOfClass:[NSArray class]])
                {
                    NSArray *array = (NSArray*)obj;
                    NSString *state = array[0];
                    if ([state isEqualToString:@"0"])
                    {
                        [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                        
                        [UserDefaults setObject:array[1] forKey:kUSERID];
                        [UserDefaults setObject:self.nameTxtField.text forKey:KUSERNAME];
                        
                        NSString *isRememberPsw = [UserDefaults objectForKey:kREMEBERPWD];
                        NSString *isAutoLogin = [UserDefaults objectForKey:kAUTOLOGIN];
                        
                        if ([isRememberPsw isEqualToString:@"1"]||[isAutoLogin isEqualToString:@"1"])
                        {
                             [UserDefaults setObject:self.pswTxtField.text forKey:kPASSWORD];
                        }
                        
                       
                        
                        [UserDefaults synchronize];
                        
                        ShareManager.userId = array[1];
                        ShareManager.userName = array[2];
                        
                        //每次重新登录后 清空缓存的通讯录数据
                        ShareManager.addressArr = [NSMutableArray arrayWithCapacity:0];
                        
                        HomeViewController *homeController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        [self.navigationController pushViewController:homeController animated:YES];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:array[1]];
               
                    }
                }
         
            }
          failure:^(NSString *errMsg)
          {
               [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后再试!"];
              
          }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在登录..." completeBlock:^(NSArray *operations) {
    }];
    
}


#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_GotoSetting: //设置
        {
            self.setingView.frame = CGRectMake(0, -self.setingView.frame.size.height, self.setingView.frame.size.width, self.setingView.frame.size.height);
            self.setingView.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.setingView.frame = CGRectMake(0, IOS7_OR_LATER?20:0, self.setingView.frame.size.width, self.setingView.frame.size.height);
            }];
        }
            break;
        case Action_Tag_SetOk: //设置--确定
        {
            [self.view endEditing:YES];
            [UIView animateWithDuration:0.3 animations:^{
              
               self.setingView.frame = CGRectMake(0, -self.setingView.frame.size.height, self.setingView.frame.size.width, self.setingView.frame.size.height);
              
            } completion:^(BOOL finished) {
                self.setingView.hidden = YES;
            }];
            
            NSMutableString *url = [NSMutableString stringWithString:self.hostTxtField.text];
            if (![[url substringFromIndex:url.length-1] isEqualToString:@"/"])
            {
                [url appendString:@"/"];
            }
            [UserDefaults setObject:url forKey:kHostAddress];
            [UserDefaults synchronize];
            self.hostTxtField.text = url;
            
             NSURL *hosturl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", [Transfer getHost]]];
        
            [Transfer sharedClient].baseURL = hosturl;
        }
            break;
        case Action_Tag_SetCancel://设置--取消
        {
            [self.view endEditing:YES];
            [UIView animateWithDuration:0.3 animations:^{
                
              self.setingView.frame = CGRectMake(0, -self.setingView.frame.size.height, self.setingView.frame.size.width, self.setingView.frame.size.height);
                
            } completion:^(BOOL finished) {
                self.setingView.hidden = YES;
            }];

        }
            break;
        case Action_Tag_RememberPsw: //记住密码
        {
            
            button.selected = !button.selected;
            if (button.selected)
            {
                [UserDefaults setObject:@"1" forKey:kREMEBERPWD];
               
            }
            else
            {
                [UserDefaults setObject:@"0" forKey:kREMEBERPWD];
            }
            
            [UserDefaults synchronize];
        }
            break;
        case Action_Tag_AutoLogin:  //自动登录
        {
            button.selected = !button.selected;
            
            if (button.selected)
            {
                [UserDefaults setObject:@"1" forKey:kAUTOLOGIN];
            }
            else
            {
                [UserDefaults setObject:@"0" forKey:kAUTOLOGIN];
            }
            
            [UserDefaults synchronize];
            
        }
            break;
        case Action_Tag_Login: //登录
        {
//            HomeViewController *homeController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//            [self.navigationController pushViewController:homeController animated:YES];
//            return;
            
            
           if (![self checkInputValue])
           {
               return;  
           }
            
            [self loginAction];
        }
            break;
            
        default:
            break;
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
