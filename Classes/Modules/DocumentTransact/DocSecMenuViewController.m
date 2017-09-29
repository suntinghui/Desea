//
//  DocSecMenuViewController.m
//  Desea
//
//  Created by wenbin on 14-2-25.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "DocSecMenuViewController.h"
#import "DocumentListViewController.h"

@interface DocSecMenuViewController ()

@end

@implementation DocSecMenuViewController

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
    
    if (self.pageType == 1)
    {
        self.navigationItem.title = @"收文管理";
    }
    else  if (self.pageType == 2)
    {
        self.navigationItem.title = @"发文管理";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    
//    //未办理数组
//    UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuzibeijing"]];
//    numImg.frame = CGRectMake(250, 15, 18, 18);
//    [cell.contentView addSubview:numImg];
//    
//    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 13, 18, 18)];
//    numLabel.backgroundColor = [UIColor clearColor];
//    numLabel.font = [UIFont boldSystemFontOfSize:12];
//    numLabel.textColor = [UIColor redColor];
//    numLabel.textAlignment = UITextAlignmentCenter;
//    [numLabel setAdjustsFontSizeToFitWidth:YES];
//    [cell.contentView addSubview:numLabel];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    
//    NSArray *numArr = [self.unreadCount componentsSeparatedByString:@";"];
//    if (((indexPath.section<3)&&[numArr[indexPath.section] isEqualToString:@"0"])||indexPath.section==3||indexPath.section==4)
//    {
//        numLabel.hidden = YES;
//        numImg.hidden = YES;
//    }
    
    if (indexPath.section==0)
    {
        titleLabel.text = @"待办文件";
        titleImgView.image = [UIImage imageNamed:@"liucheng_wodedaiban"];
    }
   
    else  if (indexPath.section==1)
    {
        titleLabel.text = @"已办文件";
        titleImgView.image = [UIImage imageNamed:@"liucheng_lishi"];
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
    
    DocumentListViewController *documentListController = [[DocumentListViewController alloc]initWithNibName:@"DocumentListViewController" bundle:nil];
    int nextType;
    if (self.pageType==1)
    {
        if (indexPath.section==0)
        {
            nextType = 7;
        }
        else if (indexPath.section==1)
        {
            nextType = 9;
        }
    }
    else if(self.pageType==2)
    {
        if (indexPath.section==0)
        {
            nextType = 12;
        }
        else if (indexPath.section==1)
        {
            nextType = 14;
        }
    }
    documentListController.pageType = nextType;
    [self.navigationController pushViewController:documentListController animated:YES];
    
}


@end
