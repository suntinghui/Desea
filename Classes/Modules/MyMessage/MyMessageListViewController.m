//
//  MyMessageListViewController.m
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "MyMessageListViewController.h"
#import "MyMessageCell.h"
#import "WriteMessageViewController.h"
#import "MyMessageDetailViewController.h"

@interface MyMessageListViewController ()

@end

@implementation MyMessageListViewController

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
    self.navigationItem.title = self.pageType == 0? @"收件箱":@"发件箱";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"writeMessage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.pageView = [[NSBundle mainBundle]loadNibNamed:@"PageView" owner:nil options:nil][0];
    self.pageView.delegate = self;
    
    //*****************************
//    [self.view addSubview:self.pageView];
    
    [self getMessageList];
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


#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取短信列表
 */
- (void)getMessageList
{
    
    NSDictionary *dict = @{kMethodName:@"GetSMSList",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId,
                                        @"sType":[NSString stringWithFormat:@"%d",self.pageType]}};
    
    
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



#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    WriteMessageViewController *writeMessageController = [[WriteMessageViewController alloc]initWithNibName:@"WriteMessageViewController" bundle:nil];
    [self.navigationController pushViewController:writeMessageController animated:YES];
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
    NSDictionary *dict = self.resultArr[indexPath.row];
    float height = [StaticTools getLabelHeight:dict[@"content"] defautWidth:300 defautHeight:4800 fontSize:15];
    return height+30+30;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMessageCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    NSDictionary *dict = self.resultArr[indexPath.row];
    
    if (![StaticTools isEmptyString:dict[@"reciver"]]&&![StaticTools isEmptyString:dict[@"phone"]])
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",dict[@"reciver"],dict[@"phone"]];
    }
    else if (![StaticTools isEmptyString:dict[@"reciver"]]&&[StaticTools isEmptyString:dict[@"phone"]])
    {
        cell.titleLabel.text = dict[@"reciver"];
    }
    else if ([StaticTools isEmptyString:dict[@"reciver"]]&&![StaticTools isEmptyString:dict[@"phone"]])
    {
        cell.titleLabel.text = dict[@"phone"];
    }
    cell.timeLabel.text = dict[@"time"];
    cell.detailLabel.text = dict[@"content"];
    
   
    float height = [StaticTools getLabelHeight:dict[@"content"] defautWidth:300 defautHeight:4800 fontSize:15];
    cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width,height+3);
   
    cell.timeLabel.frame = CGRectMake(cell.timeLabel.frame.origin.x, cell.detailLabel.frame.origin.y+ cell.detailLabel.frame.size.height, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
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
        cell.backgroundColor = [StaticTools colorWithHexString:@"#E1E9F4"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MyMessageDetailViewController *myMessageDetailController = [[MyMessageDetailViewController alloc]initWithNibName:@"MyMessageDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:myMessageDetailController animated:YES];
}

@end
