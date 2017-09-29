//
//  FlowHandleListViewController.m
//  Desea
//
//  Created by wenbin on 14-2-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "FlowHandleListViewController.h"
#import "DocumentCell.h"
#import "FlowHandleViewController.h"

@interface FlowHandleListViewController ()

@end

@implementation FlowHandleListViewController

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
    
    if (self.pageType == 0)
    {
        self.navigationItem.title = @"我的待办";
        self.cellColor = @"#B7DCEC";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 30);
        [button setTitle:@"一键接收" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    else  if (self.pageType == 1)
    {
        self.navigationItem.title = @"正在办理";
        self.cellColor = @"#ACE5DF";
    }
    else  if (self.pageType == 2)
    {
        self.navigationItem.title = @"历史记录"; // 历史记录列表页×
        self.cellColor = @"#B3E4CE";
    }
    else  if (self.pageType == 3)
    {
        self.navigationItem.title = @"待批文件";
        self.cellColor = @"#DDCDF1";
    }
    else  if (self.pageType == 4)
    {
        self.navigationItem.title = @"撤销箱";
        self.cellColor = @"#E6C8E4";
    
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDaa) name:@"SAVEORCOMMITSUCESS" object:nil];
    
    self.pageView = [[NSBundle mainBundle] loadNibNamed:@"PageView" owner:nil options:nil][0];
    self.pageView.delegate = self;
    
    // ************************************
    //[self.view addSubview:self.pageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageView.frame = CGRectMake(0, self.listTableView.frame.origin.y+self.listTableView.frame.size.height, 320, self.pageView.frame.size.height);
    
    [self getListWithType:@"0"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ARC环境下，也没有把dealloc函数禁掉，还是可以使用的。只不过不需要调用[supper dealloc]了。
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshDaa
{
    [self getListWithType:@"1"];
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

#pragma mark -按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    [self getAllUndo];
    
}

#pragma mark-
#pragma mark--HTTP请求

/**
 *  获取流程管理列表
 *
 *  @param type 0:正常请求 有加载提示 1：刷新数据 没有加载提示
 */
- (void)getListWithType:(NSString*)type
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
                                                 if (listArr.count==0)
                                                 {
                                                     self.navigationItem.rightBarButtonItem.enabled = NO;
                                                 }
                                                 else
                                                 {
                                                     self.navigationItem.rightBarButtonItem.enabled = YES;
                                                 }
                                                 
                                                 // ************************************
                                                 //self.resultArr = self.pageView.currentPageDatas;
                                                 self.resultArr = self.pageView.allPageDatas;
                                                 
                                                 [self.listTableView reloadData];
                                                 
                                                 NSString *title = self.navigationItem.title;
                                                 if ([title rangeOfString:@"("].location!=NSNotFound)
                                                 {
                                                     title = [title substringToIndex:[title rangeOfString:@"("].location];
                                                 }
                                                 
                                                 if (self.resultArr.count==0&&[type isEqualToString:@"0"])
                                                 {
                                                     [StaticTools showAlertWithTag:0
                                                                             title:nil
                                                                           message:@"暂无相关信息"
                                                                         AlertType:CAlertTypeDefault
                                                                         SuperView:nil];
                                                     
                                                     self.navigationItem.title = title;
                                                     
                                                     
                                                 }
                                                 else if(self.resultArr.count!=0)
                                                 {
                                                     
                                                    
                                                     self.navigationItem.title = [NSString stringWithFormat:@"%@(%d)",title,self.pageView.allPageDatas.count];
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
 *  一键接收所有待办
 */
- (void)getAllUndo
{
    NSDictionary *dict = @{kMethodName:@"AllReceive",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                if ([obj isEqualToString:@"1"])
                                                {
                                                    
                                                    [self getListWithType:@"0"];
                                                }
                                                else
                                                {
                                                     [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
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
        
         cell.titleLabel.frame = CGRectMake(20, cell.titleLabel.frame.origin.y, 300, cell.titleLabel.frame.size.height);
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 2, 17, 30)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:numLabel];
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
     NSDictionary *dict = self.resultArr[indexPath.row];
    
    FlowHandleViewController *flowHandleController = [[FlowHandleViewController alloc]initWithNibName:@"FlowHandleViewController" bundle:nil];
    flowHandleController.sType = self.pageType;
    flowHandleController.infoId = dict[@"Id"];
    [self.navigationController pushViewController:flowHandleController animated:YES];
}

@end
