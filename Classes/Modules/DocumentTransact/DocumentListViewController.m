//
//  DocumentListViewController.m
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "DocumentListViewController.h"
#import "DocumentCell.h"
#import "DocumentTransactHandleViewController.h"
#import "FlowHandleViewController.h"

@interface DocumentListViewController ()
{
    int sType;
}
@end

@implementation DocumentListViewController

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
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    NSLog(@"ddd %d",self.pageType);
    
    if (self.pageType==6)
    {
        sType = 0;
    }
    else  if (self.pageType == 7||self.pageType==12)
    {
        self.navigationItem.title = @"我的待办";
        self.cellColor = @"#B7DCEC";
        sType = 0;
    }
    else  if (self.pageType == 8||self.pageType==13)
    {
        self.navigationItem.title = @"正在办理";
        self.cellColor = @"#ACE5DF";
        sType = 1;
    }
    else  if (self.pageType == 9||self.pageType==14)
    {
        self.navigationItem.title = @"历史记录";
        self.cellColor = @"#B3E4CE";
        sType = 2;
    }
    else  if (self.pageType == 10||self.pageType==15)
    {
        self.navigationItem.title = @"待批文件";
        self.cellColor = @"#DDCDF1";
        sType = 3;
    }
    else  if (self.pageType == 11||self.pageType==16)
    {
        self.navigationItem.title = @"撤销箱";
        self.cellColor = @"#E6C8E4";
        sType = 4;
        
    }
    
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
 *  获取公文管理列表
 */
- (void)getList
{
    
    NSDictionary *dict = @{kMethodName:@"GetLCList",
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DocumentCell" owner:nil options:nil] objectAtIndex:0];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSDictionary *dict = self.resultArr[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    cell.typeLabel.text = dict[@"type"];
    cell.contentLabel.text = dict[@"content"];
    cell.pepoleLabel.text = dict[@"people"];
    
    return cell;
}
//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row%2==0)
//    {
        cell.backgroundColor = [StaticTools colorWithHexString:@"#F1F1F1"];
//    }
//    else
//    {
//        cell.backgroundColor = [StaticTools colorWithHexString:self.cellColor];
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DocumentTransactHandleViewController *documentHandleController = [[DocumentTransactHandleViewController alloc]initWithNibName:@"DocumentTransactHandleViewController" bundle:nil];
//    [self.navigationController pushViewController:documentHandleController animated:YES];
    
    //和流程管理使用同一个详情页面
    FlowHandleViewController *documentHandleController = [[FlowHandleViewController alloc]initWithNibName:@"FlowHandleViewController" bundle:nil];
    documentHandleController.sType = sType;
    [self.navigationController pushViewController:documentHandleController animated:YES];
}


@end
