//
//  DocumentTransactViewController.m
//  Desea
//
//  Created by wenbin on 14-1-16.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "DocumentTransactViewController.h"
#import "DocumentListViewController.h"
#import "DocSecMenuViewController.h"

@interface DocumentTransactViewController ()

@end

@implementation DocumentTransactViewController

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
    
    self.navigationItem.title = @"公文管理";
    
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
    NSDictionary *dict = @{kMethodName:@"GetGWGLCount",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                 NSString *result = (NSString*)obj;
                                                 self.unreadCount = [NSString stringWithString:result];
                                                 [self.listTableView reloadData];
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"待办项目查询失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    
    
    
}



#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    for ( UIView *view in cell.contentView.subviews)
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
    
 
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    
    if (![StaticTools isEmptyString:self.unreadCount])
    {
        NSArray *numArr = [self.unreadCount componentsSeparatedByString:@";"];
        
        
        if ([numArr[indexPath.section] isEqualToString:@"0"])
        {
            
        }
        else
        {
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
            
            numLabel.text = numArr[indexPath.section];
        }

    }
    
    if (indexPath.section==0)
    {
        titleLabel.text = @"今日收文";
        titleImgView.image = [UIImage imageNamed:@"wodeyoujian"];
    }
    else  if (indexPath.section==1)
    {
        titleLabel.text = @"收文管理";
        titleImgView.image = [UIImage imageNamed:@"neibuyoujian"];
    }
    else  if (indexPath.section==2)
    {
        titleLabel.text = @"发文管理";
        titleImgView.image = [UIImage imageNamed:@"neibuyoujian"];
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
    //今日收文直接进入列表页面  其他的进入二级菜单
    if (indexPath.section==0)
    {
        DocumentListViewController *documentListController = [[DocumentListViewController alloc]initWithNibName:@"DocumentListViewController" bundle:nil];
        documentListController.pageType = 6;
        [self.navigationController pushViewController:documentListController animated:YES];
       
    }
    else
    {
        DocSecMenuViewController *docSecController = [[DocSecMenuViewController alloc]initWithNibName:@"DocSecMenuViewController" bundle:nil];
        docSecController.pageType = indexPath.section;
        [self.navigationController pushViewController:docSecController animated:YES];
    }
  
}


@end
