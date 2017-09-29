//
//  EmailListViewController.m
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "EmailListViewController.h"
#import "EmailCell.h"
#import "WriteEmailViewController.h"
#import "EmailDetailViewController.h"
#import "WriteEmailViewController.h"

@interface EmailListViewController ()

@end

@implementation EmailListViewController

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
    if (self.pageType==0)
    {
        self.navigationItem.title = @"草稿箱";
         self.cellColor = @"#B7DCEC";
    }
    else if (self.pageType==1)
    {
        self.navigationItem.title = @"收件箱";
        self.cellColor = @"#ACE5DF";
    }
    else if (self.pageType==2)
    {
        self.navigationItem.title = @"发件箱";
         self.cellColor = @"#B3E4CE";
    }
    else if (self.pageType==3)
    {
        self.navigationItem.title = @"已删除";
        self.cellColor = @"#DDCDF1";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 30);
        [button setTitle:@"清空" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    self.pageView = [[NSBundle mainBundle]loadNibNamed:@"PageView" owner:nil options:nil][0];
    self.pageView.delegate = self;
//    [self.view addSubview:self.pageView];
    
    [self getList];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageView.frame = CGRectMake(0, self.listTableView.frame.origin.y+self.listTableView.frame.size.height, 320, self.pageView.frame.size.height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    [StaticTools showAlertWithTag:0
                            title:nil
                          message:@"您确定要清空已删除吗？"
                        AlertType:CAlertTypeCacel
                        SuperView:self];
}

#pragma mark -PageViewDelegate
- (void)frontPageClickWihtCurrentPage:(NSMutableArray*)pageDatas
{
    self.resultArr = pageDatas;
    [self.listTableView reloadData];
}

- (void)nextPageClickWithCurrentPage:(NSMutableArray*)pageDatas
{
    self.resultArr = pageDatas;
    [self.listTableView reloadData];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
       
        [self ClearAllEmail];
    }
}

#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取邮件列表
 */
- (void)getList
{
    
    NSDictionary *dict = @{kMethodName:@"GetMailList",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sType":[NSString stringWithFormat:@"%d",self.pageType],
                                        @"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                 NSArray *listArr = (NSArray*)obj;
                                                 self.pageView.allPageDatas = [NSMutableArray arrayWithArray:listArr];
                                                 self.resultArr = self.pageView.allPageDatas;
                                                 
                                                 [self.listTableView reloadData];
                                                 
                                                 if (self.resultArr.count==0)
                                                 {
                                                     [StaticTools showAlertWithTag:0
                                                                             title:nil
                                                                           message:@"暂无相关信息"
                                                                         AlertType:CAlertTypeDefault
                                                                         SuperView:nil];
                                                     self.navigationItem.rightBarButtonItem = nil;
                                                     
                                                 }
                                                 
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
 *  清空已删除邮件列表
 */
-(void)ClearAllEmail
{
    NSMutableString *idStr = [[NSMutableString alloc]init];
    for (NSDictionary *dict in  self.pageView.allPageDatas)
    {
        [idStr appendString:[NSString stringWithFormat:@"%@,",dict[@"Id"]]];
    }
    idStr = [idStr substringToIndex:idStr.length-1];
    
    
    NSDictionary *dict = @{kMethodName:@"DelMail",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sType":@"1",
                                        @"sUserId":ShareManager.userId,
                                        @"Ids":idStr}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isEqualToString:@"1"])
                                             {
                                                 self.pageView.allPageDatas = [NSMutableArray arrayWithCapacity:0];
                                                 self.resultArr = [NSMutableArray arrayWithCapacity:0];
                                                 self.navigationItem.rightBarButtonItem = nil;
                                                 [self.listTableView reloadData];
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
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在清空..." completeBlock:^(NSArray *operations) {
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
    return self.resultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    EmailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EmailCell" owner:nil options:nil]objectAtIndex:0];
        
        cell.nameLabel.frame = CGRectMake(20, cell.nameLabel.frame.origin.y, 300, cell.nameLabel.frame.size.height);
        cell.titleLabel.frame = CGRectMake(20, cell.titleLabel.frame.origin.y, 300, cell.titleLabel.frame.size.height);

        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 2, 17, 30)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:numLabel];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.resultArr[indexPath.row];
    cell.nameLabel.text = dict[@"people"];
    cell.timeLabel.text = dict[@"time"];
    cell.titleLabel.text = dict[@"theme"];
    
    if ([dict[@"state"] isEqualToString:@"0"])
    {
     
        cell.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        cell.nameLabel.font = [UIFont systemFontOfSize:15];
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    

    //有附件 显示附件图标
    if (![StaticTools isEmptyString:dict[@"fjcounts"] ]&&![dict[@"fjcounts"] isEqualToString:@"0"])
    {
        cell.attachmentImg.hidden = NO;
    }
    
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        cell.backgroundColor = [StaticTools colorWithHexString:@"#F1F1F1"];
    }
    else
    {
        cell.backgroundColor = [StaticTools colorWithHexString:self.cellColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = self.resultArr[indexPath.row];
    
    [dict setObject:@"1" forKey:@"state"];
    [self.listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//    if (self.pageType==0) //点击草稿  进入邮件编写页面
//    {
//        WriteEmailViewController *writeEmailController = [[WriteEmailViewController alloc]initWithNibName:@"WriteEmailViewController" bundle:nil];
//        writeEmailController.isFromCaoGao = YES;
//        writeEmailController.mailId = dict[@"Id"];
//        [self.navigationController pushViewController:writeEmailController animated:YES];
//    }
//    else
//    {
    
        EmailDetailViewController *emailDetailController = [[EmailDetailViewController alloc]initWithNibName:@"EmailDetailViewController" bundle:nil];
        emailDetailController.fatherController = self;
        emailDetailController.emailId = dict[@"Id"];
        emailDetailController.emailInId = dict[@"inId"];
        emailDetailController.type = self.pageType;
        [self.navigationController pushViewController:emailDetailController animated:YES];
//    }
   
    
}


@end
