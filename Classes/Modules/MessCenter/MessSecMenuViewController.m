//
//  MessSecMenuViewController.m
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "MessSecMenuViewController.h"
#import "MessThrMenuViewController.h"
#import "NewsListViewController.h"

@interface MessSecMenuViewController ()

@end

@implementation MessSecMenuViewController

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

    
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.separatorColor = [UIColor clearColor];
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    if ([StaticTools isEmptyString:self.title])
    {
        if (self.pageType==1)
        {
             self.navigationItem.title = @"文档中心";
        }
        else
        {
             self.navigationItem.title = @"部门之窗";
        }
       
      
        
        [self getTitleAndUnreadNum];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark HTTP请求
/**
 *  获取子项标题和未读条数
 */
- (void)getTitleAndUnreadNum
{
    NSDictionary *dict = @{kMethodName:self.pageType==0?@"GetBMZC":@"GetWDZX",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
//                                                 self.resultDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                                                 self.resultArr = [NSMutableArray arrayWithArray:obj];
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

- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSDictionary *dict = self.resultArr[button.tag-100];
    
    NewsListViewController *newsListController = [[NewsListViewController alloc]initWithNibName:@"NewsListViewController" bundle:nil];
    newsListController.titleStr = dict[@"name"];
    newsListController.depId = dict[@"id"];
    [self.navigationController pushViewController:newsListController animated:YES];

    
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
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
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict = self.resultArr[indexPath.section];
    
    //左侧图标
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    titleImgView.backgroundColor = [UIColor clearColor];
    titleImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bmzc%d",indexPath.section%7+1]];
    [cell.contentView addSubview:titleImgView];
    
    //右侧箭头
    UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou"]];
    arrowImg.frame = CGRectMake(290, 20, 5, 10);
    [cell.contentView addSubview:arrowImg];
    
    
    if (![StaticTools isEmptyString:dict[@"count"]]&&![dict[@"count"]isEqualToString:@"0"])
    {
        //未办理数
//        UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuzibeijing"]];
//        numImg.frame = CGRectMake(250, 15, 18, 18);
//        [cell.contentView addSubview:numImg];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame  =CGRectMake(250, 15, 18, 18);
        [button setBackgroundImage:[UIImage imageNamed:@"shuzibeijing"] forState:UIControlStateNormal];
        button.tag = indexPath.section+100;
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 13, 18, 18)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont boldSystemFontOfSize:12];
        numLabel.textColor = [UIColor redColor];
        numLabel.textAlignment = UITextAlignmentCenter;
        [numLabel setAdjustsFontSizeToFitWidth:YES];
        [cell.contentView addSubview:numLabel];
        numLabel.text = dict[@"count"];
    }
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 280, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    titleLabel.text = dict[@"name"];
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.frame];
    cell.backgroundView = imgView;
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.section%5==0)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diyitiao"];
    }
    else if(indexPath.section%5==1)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diertiao"];
        
    }
    else if(indexPath.section%5==2)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_disantiao"];
        
    }
    else if(indexPath.section%5==3)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_disitiao"];
        
    }
    else if(indexPath.section%5==4)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diwutiao"];
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = self.resultArr[indexPath.section];
    NSArray *infors = dict[@"Infors"];
    if (infors.count>0)
    {
        MessSecMenuViewController *messSecMenuController = [[MessSecMenuViewController alloc]initWithNibName:@"MessSecMenuViewController" bundle:nil];
        messSecMenuController.title = dict[@"name"];
        messSecMenuController.resultArr = dict[@"Infors"];
        [self.navigationController pushViewController:messSecMenuController animated:YES];
    }
    else
    {
        NewsListViewController *newsListController = [[NewsListViewController alloc]initWithNibName:@"NewsListViewController" bundle:nil];
        newsListController.titleStr = dict[@"name"];
        newsListController.pageType=1;
        newsListController.depId = dict[@"id"];
        [self.navigationController pushViewController:newsListController animated:YES];
    }
}
@end
