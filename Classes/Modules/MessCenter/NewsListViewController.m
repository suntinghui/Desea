//
//  NewsListViewController.m
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsListCell.h"
#import "NewsDetailViewController.h"
#import "PublicCell.h"

@interface NewsListViewController ()
{
}
@end

@implementation NewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.depId = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.titleStr;
    [StaticTools setTableViewAddMoreFootView:self.listTableView withAction:@selector(buttonClickHandle:)];
    self.listTableView.tableFooterView.hidden = YES;
    
    NSArray *titles;
    if (self.pageType == 0)
    {
        titles = @[@"最新新闻",@"更多新闻"];
    }
    else if (self.pageType == 1)
    {
        titles = @[@"最新公告",@"更多公告"];
    }
    else if (self.pageType == 2)
    {
        titles = @[@"最新通知",@"更多通知"];
    }
    ScrollSelectView *scrollSelectView  = [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) titles:titles];
    scrollSelectView.delegate = self;
    [self.view addSubview:scrollSelectView];
    
    self.pageView = [[NSBundle mainBundle]loadNibNamed:@"PageView" owner:nil options:nil][0];
    self.pageView.delegate = self;
    //*********************************
//    [self.view addSubview:self.pageView];
    
    [self getNewsList];
    
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
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_AddMore:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--SrollSelectViewDelegate
- (void)ScrollSelectDidCickWith:(int)num
{
    if (self.listType==num)
    {
        return;
    }
    
    if(num==0) //最新消息
    {
        self.listType = 0;
    }
    else //更多消息
    {
        self.listType = 2;
    }
    
    [self.resultArr removeAllObjects];
    [self.listTableView reloadData];
    
    [self getNewsList];
}

#pragma mark-
#pragma mark--HTTP请求
- (void)getNewsList
{
    NSString *methodName;
    if (self.pageType == 2) //通知信息
    {
        methodName = @"GetTZList";
    }
    else if(self.pageType == 0||self.pageType==1) //集团新闻||集团公告
    {
         methodName = @"GetXXList";
    }
    NSDictionary *dict = @{kMethodName:methodName,
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"State":[NSString stringWithFormat:@"%d",self.listType],
                                        @"sId":self.depId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                 {
                     if ([obj isKindOfClass:[NSArray class]])
                     {
                         NSArray *listArr = (NSArray*)obj;
                         self.pageView.allPageDatas = [NSMutableArray arrayWithArray:listArr];
                         //*************************
                         self.resultArr = self.pageView.allPageDatas;
                         
                         [self.listTableView reloadData];
                         
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.resultArr[indexPath.row];
    
    if (self.pageType==2||self.pageType==1||self.pageType==3) //通知信息||集团公告||部门之窗
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        PublicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PublicCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = dict[@"title"];
        cell.timeLabel.text = dict[@"time"];
        cell.detailLabel.text = dict[@"content"];
        NSString *state = dict[@"state"];
        if ([state isEqualToString:@"0"]) //未读
        {
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else //已读
        {
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = dict[@"title"];
        cell.timeLabel.text = dict[@"time"];
        cell.detalLabel.text = dict[@"content"];
        [cell.headImgView setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"loading"]];
        
         NSString *state = dict[@"state"];
        if ([state isEqualToString:@"0"]) //未读
        {
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else //已读
        {
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        return cell;
    }
    
    return nil;

}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        cell.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    }
    else
    {
        cell.backgroundColor = RGBACOLOR(217, 227, 241, 1);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = self.resultArr[indexPath.row];
    NewsDetailViewController *newsDetailController = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
    
    [dict setObject:@"1" forKey:@"state"];
    [self.listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    newsDetailController.InfoId = dict[@"Id"];
    if (self.pageType == 2) //通知信息
    {
        newsDetailController.pageType = 0;
    }
    else if(self.pageType==0) //集团新闻
    {
        newsDetailController.pageType = 1;
    }
    else if(self.pageType == 1) //集团公告
    {
        newsDetailController.pageType = 2;
    }
    [self.navigationController pushViewController:newsDetailController animated:YES];
}
@end
