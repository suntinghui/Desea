//
//  WriteMessageViewController.m
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "WriteMessageViewController.h"
#import "AddressListViewController.h"
#import "ContactsModel.h"

@interface WriteMessageViewController ()

@end

@implementation WriteMessageViewController

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
    
    self.navigationItem.title = @"短信编写";
    
    YFInputBar *inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds)-44-44-20, 320, 44)];
    
    inputBar.backgroundColor = [UIColor colorWithRed:38/255.0 green:92/255.0 blue:201/255.0 alpha:1];
    
    
    inputBar.delegate = self;
//    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = NO;
    [inputBar.textView becomeFirstResponder];
    [self.view addSubview:inputBar];
    
    if (self.recever!=nil)
    {
        self.reciverTxtView.text = self.recever.name;
        self.addBtn.hidden = YES;
        
         [inputBar.textView becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.reciverTxtView.frame = CGRectMake(self.reciverTxtView.frame.origin.x, self.reciverTxtView.frame.origin.y, self.reciverTxtView.frame.size.width, self.view.frame.size.height-100);
//    self.inputBackImgView.frame = self.reciverTxtView.frame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark HTTP请求
/**
 * 发送短信
 */
- (void)sendMessageWithContent:(NSString*)content
{
    NSDictionary *dict = @{kMethodName:@"WriteSMS",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId,
                                        @"sSJH":self.reciverPhone,
                                        @"sJSR":self.reciverName,
                                        @"SMSContent":content}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                 NSString *result = (NSString*)obj;
                                                 if ([result isEqualToString:@"1"])
                                                 {
                                                     [SVProgressHUD showSuccessWithStatus:@"短信发送成功!"];
                                                 }
                                                 else
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:@"短信发送失败，请稍后再试!"];
                                                 }
                                                 
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"短信发送失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在发送..." completeBlock:^(NSArray *operations) {
    }];
}
#pragma mark
#pragma mark 功能函数
- (void)back
{
    [super back];
    
    [ShareManager.selectPeople removeAllObjects];
}

/**
 *  刷新收件人
 */
- (void)freshRecevePeople
{
    
    NSMutableString *receve = [[NSMutableString alloc]init];
    for (ContactsModel *contact in ShareManager.selectPeople)
    {
        if(![StaticTools isEmptyString:contact.name])
        {
            [receve appendFormat:@"%@;",contact.name];
        }
    }
    
    for (NSArray *arr in ShareManager.selectDepartment)
    {
        ContactsModel *contact = arr[0];
        if(![StaticTools isEmptyString:contact.departMent])
        {
            [receve appendFormat:@"%@;",contact.departMent];
        }
        
    }
    
    self.reciverTxtView.text = receve;
    
}

#pragma mark
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{

    
   
}
- (void)textViewDidEndEditing:(UITextView *)textView
{

}

#pragma mark
#pragma mark YFInputBarDelegate
-(void)inputBarBenginEditing
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (IsIPhone5)
        {
            self.reciverTxtView.frame = CGRectMake(self.reciverTxtView.frame.origin.x, self.reciverTxtView.frame.origin.y, self.reciverTxtView.frame.size.width, 190);
        }
        else
        {
            self.reciverTxtView.frame = CGRectMake(self.reciverTxtView.frame.origin.x, self.reciverTxtView.frame.origin.y, self.reciverTxtView.frame.size.width, 90);
        }
        
        self.inputBackImgView.frame = self.reciverTxtView.frame;

    }];
}
-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    
    if ([StaticTools isEmptyString:self.reciverTxtView.text])
    {
        [StaticTools showAlertWithTag:0
                                title:nil
                              message:@"请选择收件人！"
                            AlertType:CAlertTypeDefault
                            SuperView:nil];
        
        return;
    }
    else if([StaticTools isEmptyString:str])
    {
        [StaticTools showAlertWithTag:0
                                title:nil
                              message:@"请填写内容！!!"
                            AlertType:CAlertTypeDefault
                            SuperView:nil];
        
        return;
    }
    
    self.reciverName = [[NSMutableString alloc]init];
    self.reciverPhone = [[NSMutableString alloc]init];


    for (ContactsModel *contact in ShareManager.selectPeople)
    {
        if (![StaticTools isEmptyString:contact.phoneNum])
        {
            [self.reciverPhone appendFormat:@"%@,",contact.phoneNum];
        }
        
        if (![StaticTools isEmptyString:contact.name])
        {
            [self.reciverName appendFormat:@"%@,",contact.name];
        }
    }

    for (NSArray *arr in ShareManager.selectDepartment)
    {
        for (ContactsModel *contact in arr)
        {
            if(![StaticTools isEmptyString:contact.phoneNum])
            {
                [self.reciverPhone appendFormat:@"%@,",contact.phoneNum];
            }
            
            if (![StaticTools isEmptyString:contact.name])
            {
                [self.reciverName appendFormat:@"%@,",contact.name];
            }
        }
       
    }
    
    
    [self sendMessageWithContent:str];
}

#pragma mark
#pragma mark 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    AddressListViewController *addressListController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
    addressListController.isSelectContace = YES;
    addressListController.fatherController = self;
    [self.navigationController pushViewController:addressListController animated:YES];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [((UIView*)obj) resignFirstResponder];
//    }];
    
    
    
//    [self.view endEditing:YES];
//    
//    self.reciverTxtView.frame = CGRectMake(self.reciverTxtView.frame.origin.x, self.reciverTxtView.frame.origin.y, self.reciverTxtView.frame.size.width, self.view.frame.size.height-100);
//    self.inputBackImgView.frame = self.reciverTxtView.frame;
}
@end
