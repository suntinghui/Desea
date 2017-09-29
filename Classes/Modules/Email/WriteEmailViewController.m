//
//  WriteEmailViewController.m
//  Desea
//
//  Created by wenbin on 14-2-19.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "WriteEmailViewController.h"
#import "AddressListViewController.h"
#import "ContactsModel.h"

#define Action_Tag_SendEmail 100
#define Action_Tag_SelectPeople 101

@interface WriteEmailViewController ()
{
}
@end

@implementation WriteEmailViewController

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
    self.navigationItem.title = @"写邮件";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    [self.mainScrView addGestureRecognizer:tapGesture];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    button.tag = Action_Tag_SendEmail;
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    
}
- (void)viewWillAppear:(BOOL)animated
{
//    self.mainScrView.contentSize = CGSizeMake(320, self.view.frame.size.height+10);
    
    if (self.reciver==nil)
    {
        
    }
    else
    {
        self.receveTxtView.text = self.reciver;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark 功能函数
- (void)back
{

    if (![StaticTools isEmptyString:self.receveTxtView.text]&&![StaticTools isEmptyString:self.themeTxtView.text])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"删除草稿", @"存储草稿",nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [super back];

      
    }
}

- (void)dealloc
{
    [ShareManager.selectPeople removeAllObjects];
    [ShareManager.selectDepartment removeAllObjects];
}

/**
 *  刷新收件人数据
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
    
    
    self.receveTxtView.text = receve;
    [self textViewDidEndEditing:self.receveTxtView];
    //[self adjuctControlFrame];
}

/**
 *  获取发件人的id
 */
- (void)getUserId
{
    
    self.reciverId = [[NSMutableString alloc]init];
    
    for (ContactsModel *contact in ShareManager.selectPeople)
    {
      
        [self.reciverId appendFormat:@"%@,",contact.usrId];
    }
    
    for (NSArray *arr in ShareManager.selectDepartment)
    {
        for (ContactsModel *contact in arr)
        {
           
            [self.reciverId appendFormat:@"%@,",contact.usrId];
        }
        
    }
    self.reciverId = [self.reciverId substringToIndex:self.reciverId.length-1];
}
/**
 *  输入文字时  调整控件的位置
 */
- (void) adjuctControlFrame
{
    
    self.lineOne.frame = CGRectMake(self.lineOne.frame.origin.x, self.receveTxtView.frame.origin.y+self.receveTxtView.frame.size.height+2, self.lineOne.frame.size.width, self.lineOne.frame.size.height);

    self.themeLabel.frame = CGRectMake(self.themeLabel.frame.origin.x, self.receveTxtView.frame.origin.y+self.receveTxtView.frame.size.height+13, self.themeLabel.frame.size.width, self.themeLabel.frame.size.height);
 
     self.themeTxtView.frame = CGRectMake(self.themeTxtView.frame.origin.x, self.themeLabel.frame.origin.y, self.themeTxtView.frame.size.width, self.themeTxtView.frame.size.height);
    
    
       self.lineTwo.frame = CGRectMake(self.lineTwo.frame.origin.x, self.themeTxtView.frame.origin.y+self.themeTxtView.frame.size.height+3, self.lineTwo.frame.size.width, self.lineTwo.frame.size.height);
    
    self.contentTxtView.frame = CGRectMake(self.contentTxtView.frame.origin.x, self.themeTxtView.frame.origin.y+self.themeTxtView.frame.size.height+5, self.contentTxtView.frame.size.width, self.contentTxtView.frame.size.height);
    
    float height =self.contentTxtView.frame.origin.y+self.contentTxtView.frame.size.height+10;
    height = height<self.view.frame.size.height+10?self.view.frame.size.height+10:height;
    self.mainScrView.contentSize = CGSizeMake(320, height);
}

#pragma mark
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [super back];
        
        [ShareManager.selectPeople removeAllObjects];
        [ShareManager.selectDepartment removeAllObjects];
    }
    else if (buttonIndex == 1)
    {
        [self getUserId];
        [self sendEmailWithType:0];
    }
    else if(buttonIndex == 2)
    {
        
    }
}
#pragma mark
#pragma mark HTTP请求
/**
 *  发送邮件
 *
 *  @param type 操作类型 0：存草稿 1：新邮件
 */
- (void)sendEmailWithType:(int)type
{
    NSDictionary *dict = @{kMethodName:@"WriteMail",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sSendUserId ":ShareManager.userId,
                           @"sUserIds":self.reciverId,
//                           @"MailId":type==0?self.mailId:@"", //为空是为新邮件 否则是从草稿箱发送
                           @"MailId":@"", //为空是为新邮件 否则是从草稿箱发送
                           @"MailTitle":self.themeTxtView.text,
                           @"MailContent":self.contentTxtView.text,
                           @"State":[NSString stringWithFormat:@"%d",type]}}; //0：草稿 1：新邮件
    
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                 NSString *result = (NSString*)obj;
                                                 if (![result isEqualToString:@"1"]) //失败返回1 成功返回邮件序号
                                                 {
                                                     if (type==0)
                                                     {
                                                         [SVProgressHUD showSuccessWithStatus:@"邮件已保存至草稿箱!"];
                                                     }
                                                     else
                                                     {
                                                         [SVProgressHUD showSuccessWithStatus:@"邮件发送成功!"];
                                                     }
                                                     
                                                     [ShareManager.selectPeople removeAllObjects];
                                                     [ShareManager.selectDepartment removeAllObjects];
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 }
                                                 else
                                                 {
                                                     if (type==0)
                                                     {
                                                         [SVProgressHUD showErrorWithStatus:@"保存草稿失败，请稍后再试!"];
                                                     }
                                                     else
                                                     {
                                                         [SVProgressHUD showErrorWithStatus:@"邮件发送失败，请稍后再试!"];
                                                     }
                                                     
                                                 }
                                                 
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"邮件发送失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在发送..." completeBlock:^(NSArray *operations) {
    }];
    
    
    
}



#pragma mark
#pragma mark 按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_SendEmail:
        {
            if ([StaticTools isEmptyString:self.receveTxtView.text])
            {
                [StaticTools showAlertWithTag:0
                                        title:nil
                                      message:@"请选择收件人！"
                                    AlertType:CAlertTypeDefault
                                    SuperView:nil];
                
                return;
            }
            
          
            [self getUserId];
            [self sendEmailWithType:1];
        }
            break;
        case Action_Tag_SelectPeople:
        {
            AddressListViewController *addressListController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
            addressListController.isSelectContace = YES;
            addressListController.fatherController = self;
            [self.navigationController pushViewController:addressListController animated:YES];
        }
            break;
            
        default:
            break;
    }
   
}

#pragma mark
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mainScrView])
    {
        if ([self.receveTxtView isFirstResponder]||[self.themeTxtView isFirstResponder]||[self.contentTxtView isFirstResponder])
        {
            [self.view endEditing:YES];
            [self.mainScrView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.mainScrView setContentOffset:CGPointMake(0, textView.frame.origin.y-5) animated:YES];
    
    textView.scrollEnabled = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    float minHeight = (textView.tag == 102?150:40);
    float txtViewWith = (textView.tag == 102?300:240);
    
    float height = [StaticTools getLabelHeight:textView.text defautWidth:txtViewWith defautHeight:4800 fontSize:15];
    
    if (height<minHeight)
    {
        height=minHeight;
    }
    else if(height>150)
    {
        height=150;
    }
    
    textView.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, height);
    
    [self adjuctControlFrame];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    float minHeight = (textView.tag == 102?150:40);
    float txtViewWith = (textView.tag == 102?300:240);
    
    float height = [StaticTools getLabelHeight:textView.text defautWidth:txtViewWith defautHeight:4800 fontSize:15];
    
    if (height<minHeight)
    {
        height=minHeight;
    }
    
    textView.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, height);

    [self adjuctControlFrame];
    
    textView.scrollEnabled = NO;
}

@end
