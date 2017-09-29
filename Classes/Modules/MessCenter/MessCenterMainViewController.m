//
//  MessCenterMainViewController.m
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "MessCenterMainViewController.h"
#import "NewsListViewController.h"
#import "MessSecMenuViewController.h"

@interface MessCenterMainViewController ()

@end

@implementation MessCenterMainViewController

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

    self.navigationItem.title = @"信息中心";
    
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.separatorColor = [UIColor clearColor];
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUnreadNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark HTTP请求
/**
 *  获取未读条数
 */
- (void)getUnreadNum
{
    NSDictionary *dict = @{kMethodName:@"GetXXZXCount",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 NSDictionary *result = (NSDictionary*)obj;
                                                 self.resultDict = [NSDictionary dictionaryWithDictionary:result];
                                                 [self.listTableView reloadData];
                                           
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"待办条数查询失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
    
    //左侧图标
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    titleImgView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleImgView];
    
    //右侧箭头
    UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou"]];
    arrowImg.frame = CGRectMake(290, 20, 5, 10);
    [cell.contentView addSubview:arrowImg];
    
    //未办理数组
    UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuzibeijing"]];
    numImg.frame = CGRectMake(250, 15, 18, 18);
    [cell.contentView addSubview:numImg];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 13, 18, 18)];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont boldSystemFontOfSize:12];
    numLabel.textColor = [UIColor redColor];
    numLabel.textAlignment = UITextAlignmentCenter;
    [numLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.contentView addSubview:numLabel];
    numLabel.hidden = YES;
    numImg.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    if (indexPath.section==0)
    {
        titleImgView.image = [UIImage imageNamed:@"jtxw"];
        titleLabel.text = @"集团新闻";
        numLabel.text = self.resultDict[@"JDXW"];
        if (![StaticTools isEmptyString:self.resultDict[@"JDXW"]]&&![self.resultDict[@"JDXW"] isEqualToString:@"0"])
        {
            numLabel.hidden = NO;
            numImg.hidden = NO;
        }
    }
    else  if (indexPath.section==1)
    {
        titleImgView.image = [UIImage imageNamed:@"jtgg"];
        titleLabel.text = @"集团公告";
        numLabel.text = self.resultDict[@"JDGG"];
        if (![StaticTools isEmptyString:self.resultDict[@"JDGG"]]&&![self.resultDict[@"JDGG"] isEqualToString:@"0"])
        {
            numLabel.hidden = NO;
            numImg.hidden = NO;
        }
    }
    else  if (indexPath.section==2)
    {
        titleImgView.image = [UIImage imageNamed:@"tongzhixinxi"];
        titleLabel.text = @"通知信息";
        numLabel.text = self.resultDict[@"TZXX"];
        if (![StaticTools isEmptyString:self.resultDict[@"TZXX"]]&&![self.resultDict[@"TZXX"] isEqualToString:@"0"])
        {
            numLabel.hidden = NO;
            numImg.hidden = NO;
        }
    }
    else  if (indexPath.section==3)
    {
        titleImgView.image = [UIImage imageNamed:@"bmzc4"];
        titleLabel.text = @"文档中心";
        numLabel.hidden = YES;
        numImg.hidden = YES;
    }
    else if (indexPath.section==4)
    {
        titleImgView.image = [UIImage imageNamed:@"bmzc"];
        titleLabel.text = @"部门之窗";
        numLabel.hidden = YES;
        numImg.hidden = YES;
    }
    [cell.contentView addSubview:titleLabel];
    
    
    return cell;
}
//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.frame];
    cell.backgroundView = imgView;
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.section == 0)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diyitiao"];
    }
    else if(indexPath.section==1)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diertiao"];
        
    }
    else if(indexPath.section==2)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_disantiao"];
        
    }
    else if(indexPath.section==3)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_disitiao"];
        
    }
    else if(indexPath.section==4)
    {
        imgView.image = [UIImage imageNamed:@"liucheng_diwutiao"];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) //文档中心
    {
        MessSecMenuViewController *messSecMenuController = [[MessSecMenuViewController alloc]initWithNibName:@"MessSecMenuViewController" bundle:Nil];
        messSecMenuController.pageType=1;
        [self.navigationController pushViewController:messSecMenuController animated:YES];
    }
    else if (indexPath.section==4) //部门之窗
    {
        MessSecMenuViewController *messSecMenuController = [[MessSecMenuViewController alloc]initWithNibName:@"MessSecMenuViewController" bundle:Nil];
        [self.navigationController pushViewController:messSecMenuController animated:YES];
    }
    else if(indexPath.section==2||indexPath.section==0||indexPath.section==1)//通知信息 ||集团新闻||集团公告
    {
        NewsListViewController *newListController = [[NewsListViewController alloc]initWithNibName:@"NewsListViewController" bundle:nil];
        newListController.titleStr = self.navigationItem.title;
        if (indexPath.section==0) //集团新闻
        {
            newListController.pageType=0;
            newListController.depId = self.resultDict[@"JDXWID"];
            newListController.titleStr = @"集团新闻";
        }
        else if(indexPath.section==1) //集团公告
        {
            newListController.pageType=1;
            newListController.depId = self.resultDict[@"JDGGID"];
            newListController.titleStr = @"集团公告";
        }
        else if(indexPath.section==2) //通知信息
        {
            newListController.pageType = 2;
            newListController.titleStr = @"通知信息";
        }
      
        [self.navigationController pushViewController:newListController animated:YES];
    }
 
}
@end
