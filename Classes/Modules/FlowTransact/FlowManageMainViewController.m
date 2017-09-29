//
//  FlowManageMainViewController.m
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "FlowManageMainViewController.h"
#import "FlowHandleViewController.h"
#import "FlowHandleListViewController.h"
@interface FlowManageMainViewController ()

@end

@implementation FlowManageMainViewController

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
    self.navigationItem.title = @"流程管理";
    
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
    NSDictionary *dict = @{kMethodName:@"GetLCGLCount",
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
  
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    
    
    if (![StaticTools isEmptyString:self.unreadCount])
    {
        numLabel.hidden = NO;
        numImg.hidden = NO;
    }
    NSArray *numArr = [self.unreadCount componentsSeparatedByString:@";"];
   
    
    if (indexPath.section==2||indexPath.section==4)
    {
        numLabel.hidden = YES;
        numImg.hidden = YES;
    }
   
    
    if (indexPath.section==0)
    {
        if ([numArr[0] isEqualToString:@"0"])
        {
            numLabel.hidden = YES;
            numImg.hidden = YES;
        }
        titleLabel.text = @"我的待办";
        titleImgView.image = [UIImage imageNamed:@"liucheng_wodedaiban"];
        numLabel.text = numArr[0];
    }
    else  if (indexPath.section==1)
    {
        if ([numArr[1] isEqualToString:@"0"])
        {
            numLabel.hidden = YES;
            numImg.hidden = YES;
        }
        
        titleLabel.text = @"正在办理";
        titleImgView.image = [UIImage imageNamed:@"liucheng_zhengzaibanli"];
        numLabel.text = numArr[1];
    }
    else  if (indexPath.section==3)
    {
        if ([numArr[2] isEqualToString:@"0"])
        {
            numLabel.hidden = YES;
            numImg.hidden = YES;
        }
        
        titleLabel.text = @"待批文件";
        titleImgView.image = [UIImage imageNamed:@"liucheng_daiban"];
        numLabel.text = numArr[2];
      
    }
    else  if (indexPath.section==2)
    {
        titleLabel.text = @"历史记录"; // 流程管理页面二级菜单
        titleImgView.image = [UIImage imageNamed:@"liucheng_lishi"];
    }
    else  if (indexPath.section==4)
    {
        titleLabel.text = @"撤销箱";
        titleImgView.image = [UIImage imageNamed:@"liucheng_chexiaoxiang"];
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

    FlowHandleListViewController *flowHandleListController = [[FlowHandleListViewController alloc]initWithNibName:@"FlowHandleListViewController" bundle:nil];
    flowHandleListController.pageType = indexPath.section;
    [self.navigationController pushViewController:flowHandleListController animated:YES];

}
@end
