//
//  EmailDetailViewController.m
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "EmailDetailViewController.h"
#import "ShowContentViewController.h"
#import "WriteEmailViewController.h"
#import "ContactsModel.h"

#define Action_Tag_HuiFu   100
#define Action_Tag_ZhuanFa 101
#define Action_Tag_ShanChu 102

@interface EmailDetailViewController ()
{
    UIWebView *mainWebView;
    float webHeight;
}
@end

@implementation EmailDetailViewController

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
    self.navigationItem.title = @"邮件详情";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(5, 45, 310, 100)];
    mainWebView.delegate = self;
    mainWebView.backgroundColor = [UIColor clearColor];
    mainWebView.opaque = NO;
    mainWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    mainWebView.userInteractionEnabled = NO;
    
    if (self.type == 3)
    {
        self.toolBar.hidden = YES;
        self.listTableView.frame = CGRectMake(self.listTableView.frame.origin.x, self.listTableView.frame.origin.y, self.listTableView.frame.size.width, self.listTableView.frame.size.height+40);
    }
    
    [self getEmialDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_HuiFu: //回复
        {
            WriteEmailViewController *wirteEmailController = [[WriteEmailViewController alloc]initWithNibName:@"WriteEmailViewController" bundle:nil];
            
//            wirteEmailController.reciver = self.resultDict[@"people"];
//            wirteEmailController.reciverId = self.resultDict[@"peopleId"];
            
            ContactsModel *contact = [[ContactsModel alloc]init];
            contact.name = self.resultDict[@"people"];
            contact.usrId = self.resultDict[@"peopleId"];
            ShareManager.selectPeople = [NSMutableArray arrayWithObject:contact];
            
            [self.navigationController pushViewController:wirteEmailController animated:YES];
            wirteEmailController.themeTxtView.text = [NSString stringWithFormat:@"回复：%@",self.resultDict[@"theme"]];
        
            [wirteEmailController performSelector:@selector(freshRecevePeople) withObject:nil afterDelay:0.5];
        }
            
            break;
        case Action_Tag_ZhuanFa: //转发
        {
            WriteEmailViewController *wirteEmailController = [[WriteEmailViewController alloc]initWithNibName:@"WriteEmailViewController" bundle:nil];
            [self.navigationController pushViewController:wirteEmailController animated:YES];
            wirteEmailController.contentTxtView.text = self.resultDict[@"content"];
            wirteEmailController.themeTxtView.text = self.resultDict[@"theme"];
        }
            break;
        case Action_Tag_ShanChu: //删除
        {
            [StaticTools showAlertWithTag:0
                                    title:nil
                                  message:@"您确定要删除此条邮件？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        [self deleteEmail];
    }
}
#pragma mark-
#pragma mark--HTTP请求
- (void)getEmialDetail
{
    
    NSDictionary *dict = @{kMethodName:@"GetMail",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"MailId":self.emailId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 self.resultDict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)obj];
                                                 
                                                  [mainWebView loadHTMLString:self.resultDict[@"content"] baseURL:nil];
                                                 
                                                  [self.listTableView reloadData];
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
    }];
}

/**
   删除邮件
 */
-(void)deleteEmail
{
   
    
    NSDictionary *dict = @{kMethodName:@"DelMail",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sType":self.type == 0?@"1": @"0",
                                        @"sUserId":ShareManager.userId,
                                        @"Ids":self.type==0?self.emailId:self.emailInId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isEqualToString:@"1"])
                                             {
                                                 
                                                 [SVProgressHUD showErrorWithStatus:@"邮件删除成功!"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 if ([self.fatherController respondsToSelector:@selector(getList)])
                                                 {
                                                     [self.fatherController performSelector:@selector(getList) withObject:nil];
                                                 }
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在删除..." completeBlock:^(NSArray *operations) {
    }];
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *attachArr = self.resultDict[@"attachments"];
    return attachArr.count+4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSString *str;
    if (indexPath.row==0)
    {
        str  = self.resultDict[@"people"];
    }
    else if(indexPath.row == 1)
    {
        str  = self.resultDict[@"reciver"];
    }
    else if(indexPath.row == 2)
    {
        str  = self.resultDict[@"theme"];
    }
    else if(indexPath.row == 3)
    {
        str  = self.resultDict[@"content"];
    }
    else if(indexPath.row>3)
    {
        NSArray *arr = self.resultDict[@"attachments"];
        str = arr[indexPath.row-4][@"title"];
    }
    
    if (indexPath.row==3)
    {
        return webHeight+25;
    }
    else
    {
        float height  = [StaticTools getLabelHeight:str defautWidth:300 defautHeight:480 fontSize:15];
        height = height<35?35:height;
        return height+20;
    }
    
    return 35;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if (indexPath.row!=3)
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
   
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = kLevelOneFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 30)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = kLevelOneFont;
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    detailLabel.numberOfLines = 0;
    [cell.contentView addSubview:detailLabel];
    
    if (indexPath.row==0)
    {
        titleLabel.text = @"发件人";
        detailLabel.text = self.resultDict[@"people"];
    }
    else if (indexPath.row==1)
    {
        titleLabel.text = @"收件人";
        detailLabel.text = self.resultDict[@"reciver"];
    }
    else if (indexPath.row==2)
    {
        titleLabel.text = @"主题";
        detailLabel.text = self.resultDict[@"theme"];
    }
    else if (indexPath.row==3)
    {
        
        titleLabel.text = @"内容";
        detailLabel.text = self.resultDict[@"content"];
        detailLabel.hidden = YES;
        
        if (![cell.contentView.subviews containsObject:mainWebView])
        {
            [mainWebView loadHTMLString:self.resultDict[@"content"]  baseURL:Nil];
            [cell.contentView addSubview:mainWebView];
        }

    }

    else
    {
        if (indexPath.row!=4)
        {
            titleLabel.hidden = YES;
        }
        NSDictionary *attachmentDict = self.resultDict[@"attachments"][indexPath.row-4];
        titleLabel.text = @"附件";
        detailLabel.text = attachmentDict[@"title"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        detailLabel.textColor = [UIColor blueColor];
    }
    
    
    float height = [StaticTools getLabelHeight:detailLabel.text defautWidth:300 defautHeight:4800 fontSize:15];
    height = height<30?30:height;
    detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width,height );
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>3)
    {
        NSArray *attachments  = self.resultDict[@"attachments"];
        NSDictionary *attachment = attachments[indexPath.row-4];
        
        ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:attachment[@"title"] AttachId:attachment[@"Id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark
#pragma mark webView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    webHeight= [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight"]] floatValue];
    
//    webHeight=webHeight>HEIGHTLIMIT?HEIGHTLIMIT:webHeight;
    NSLog(@"height %f\n",webHeight);
    [webView setFrame:CGRectMake(5, 25, mainWebView.frame.size.width,webHeight-3)];
    
    [self.listTableView reloadData];
}
@end
