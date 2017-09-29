//
//  CalendarListViewController.m
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "CalendarListViewController.h"
#import "CalendarCell.h"
#import "CalendarDetailViewController.h"
#import "GroupActivityDetailViewController.h"

@interface CalendarListViewController ()

@end

@implementation CalendarListViewController

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
    
    if (self.pageType == 1)
    {
        self.navigationItem.title = @"我的日程";
        self.cellColor = @"#B7DCEC";
    }
    else  if (self.pageType == 2)
    {
        self.navigationItem.title = @"部门日程";
        self.cellColor = @"#ACE5DF";
    }
    else  if (self.pageType == 3)
    {
        self.navigationItem.title = @"领导日程";
        self.cellColor = @"#B3E4CE";
    }
    else  if (self.pageType == 4)
    {
        self.navigationItem.title = @"集团活动";
        self.cellColor = @"#DDCDF1";
    }
    
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.separatorColor = [UIColor clearColor];
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    self.resultArr = [NSMutableArray arrayWithCapacity:0];
    
    self.pageView = [[NSBundle mainBundle]loadNibNamed:@"PageView" owner:nil options:nil][0];
    self.pageView.delegate = self;
//    [self.view addSubview:self.pageView];
    
    [self getCalendarList];
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
- (void)getCalendarList
{
    NSDictionary *dict ;
    
    if (self.pageType==4) //集团活动
    {
        dict = @{kMethodName:@"GetJTHDList",
                 kWebServiceName:@"WebService.asmx",
                 kParamName:@{@"sUserId":ShareManager.userId}};

    }
    else
    {
        dict = @{kMethodName: @"GetRCList",
                 kWebServiceName:@"WebService.asmx",
                 kParamName:@{@"sType":[NSString stringWithFormat:@"%d",self.pageType],
                              @"sUserId":ShareManager.userId}};

    }

    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                         {
                             if ([obj isKindOfClass:[NSArray class]])
                             {
                                 NSArray *array = (NSArray*)obj;
                                 self.pageView.allPageDatas = [NSMutableArray arrayWithArray:array];
                                 self.resultArr = self.pageView.allPageDatas;                                 [self.listTableView reloadData];
                                 
                                 if (self.resultArr.count==0)
                                 {
                                     [StaticTools showAlertWithTag:0
                                                             title:Nil
                                                           message:@"暂无相关信息！"
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
    return 50;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CalendarCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict  = self.resultArr[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    cell.timeLabel.text = dict[@"time"];
    cell.stateLabel.text = dict[@"state"];
    if (self.pageType==4) //集团活动
    {
        cell.arearLabel.hidden = YES;
        cell.arearTitleLabel.hidden = YES;
        cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, 320-cell.titleLabel.frame.origin.x-5, cell.titleLabel.frame.size.height);
    }
    else
    {
         cell.arearLabel.text = dict[@"arear"];
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict  = self.resultArr[indexPath.row];
    if (self.pageType==4)
    {
        GroupActivityDetailViewController *groupActDetailController = [[GroupActivityDetailViewController alloc]initWithNibName:@"GroupActivityDetailViewController" bundle:Nil];
        groupActDetailController.infoId = dict[@"Id"];
        [self.navigationController pushViewController:groupActDetailController animated:YES];
    }
    else
    {
        CalendarDetailViewController *calendarDetailController = [[CalendarDetailViewController alloc]initWithNibName:@"CalendarDetailViewController" bundle:nil];
        calendarDetailController.infoId = dict[@"Id"];
        [self.navigationController pushViewController:calendarDetailController animated:YES];
    }
    
}
@end
