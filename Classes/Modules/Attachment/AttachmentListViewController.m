//
//  AttachmentListViewController.m
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "AttachmentListViewController.h"
#import "ShowContentViewController.h"
#import "NSString+HTML.h"

@interface AttachmentListViewController ()

@end

@implementation AttachmentListViewController

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
    
    [self getAttchmentList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取附件列表
 */
- (void)getAttchmentList
{
    
    NSDictionary *dict = @{kMethodName:@"GetAttList",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"Id":self.infoId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                 NSArray *listArr = (NSArray*)obj;
                                                 self.attchArr = [NSMutableArray arrayWithArray:listArr];
                                                 self.attchmentNumLabel.text = [NSString stringWithFormat:@"已添加附件%d个",self.attchArr.count];
                                                 [self.listTableView reloadData];
                                                 
                                                 if (self.attchArr.count==0)
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
    return self.attchArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.attchArr[indexPath.row];
    float height = [StaticTools getLabelHeight:dict[@"title"] defautWidth:245 defautHeight:480 fontSize:15];
    height = height<40?40:height;
    return height+5;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    //左侧图标
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    titleImgView.backgroundColor = [UIColor clearColor];
    titleImgView.image = [UIImage imageNamed:@"attachment"];
    [cell.contentView addSubview:titleImgView];
    
    //右侧箭头
    UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou"]];
    arrowImg.frame = CGRectMake(290, 20, 5, 10);
    [cell.contentView addSubview:arrowImg];
    
    NSDictionary *dict = self.attchArr[indexPath.section];
    
    float height = [StaticTools getLabelHeight:dict[@"title"] defautWidth:245 defautHeight:480 fontSize:15];
    height = height<40?40:height;
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 245, height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.font =[UIFont systemFontOfSize:15];
    titleLabel.font = kLevelTwoFont;
    titleLabel.text = dict[@"title"];
    [cell.contentView addSubview:titleLabel];
    
    titleImgView.frame = CGRectMake(titleImgView.frame.origin.x, (height+5-titleImgView.frame.size.height)/2, titleImgView.frame.size.width, titleImgView.frame.size.height);
    
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.attchArr[indexPath.section];
    ShowContentViewController *showContent = [[ShowContentViewController alloc]initWithFileName:dict[@"title"] AttachId:dict[@"Id"]];
    if (self.fatherController!=nil)
    {
        [self.fatherController.navigationController pushViewController:showContent animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:showContent animated:YES];
    }
}

@end
