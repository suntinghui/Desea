//
//  MessThrMenuViewController.m
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "MessThrMenuViewController.h"
#import "NewsListViewController.h"

@interface MessThrMenuViewController ()

@end

@implementation MessThrMenuViewController

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
    self.navigationItem.title = self.titleStr;
    
    [StaticTools setExtraCellLineHidden:self.listTableView];

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
    return self.titleArr.count;
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
      NSDictionary *dict = self.titleArr[indexPath.section];
    
    //左侧图标
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    titleImgView.backgroundColor = [UIColor clearColor];
    titleImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"zcb%d",indexPath.section%6+1]];

    [cell.contentView addSubview:titleImgView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kLevelTwoFont;
    titleLabel.text = dict[@"name"];
    [cell.contentView addSubview:titleLabel];
    
    //右侧箭头
    UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou"]];
    arrowImg.frame = CGRectMake(290, 20, 5, 10);
    [cell.contentView addSubview:arrowImg];
    
    if (![StaticTools isEmptyString:dict[@"count"]]&&![dict[@"count"]isEqualToString:@"0"])
    {
        //未办理数
        UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuzibeijing"]];
        numImg.frame = CGRectMake(250, 15, 18, 18);
        [cell.contentView addSubview:numImg];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 15, 18, 18)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont boldSystemFontOfSize:12];
        numLabel.textColor = [UIColor redColor];
        numLabel.textAlignment = UITextAlignmentCenter;
        [numLabel setAdjustsFontSizeToFitWidth:YES];
        [cell.contentView addSubview:numLabel];
        numLabel.text = dict[@"count"];
    }

    
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
    NSDictionary *dict = self.titleArr[indexPath.section];
    NewsListViewController *newsListController = [[NewsListViewController alloc]initWithNibName:@"NewsListViewController" bundle:nil];
    newsListController.titleStr = dict[@"name"];
    newsListController.pageType=1;
    newsListController.depId = dict[@"Id"];
    [self.navigationController pushViewController:newsListController animated:YES];

}


@end
