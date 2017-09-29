//
//  MyMessageViewController.m
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "MyMessageDetailViewController.h"

@interface MyMessageDetailViewController ()

@end

@implementation MyMessageDetailViewController

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
    
    self.navigationItem.title = @"短信详情";
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0)
    {
        return [StaticTools getLabelHeight:@"标题" defautWidth:tableView.frame.size.width-20 defautHeight:480 fontSize:17]+40;
    }
    else if(indexPath.row == 1)
    {
        
        return 55;
    }
    
    return 44;
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
    
    if (indexPath.row==0)
    {
   
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, [StaticTools getLabelHeight:@"标题" defautWidth:tableView.frame.size.width-20 defautHeight:480 fontSize:17])];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"title";
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 200, 30)];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.text = @"2012-13-13";
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.textColor = RGBCOLOR(29, 60, 229);
        [cell.contentView addSubview:timeLabel];
    }
    else if(indexPath.row == 1)
    {
        NSString *detail = @"详情测试详情测试详情测试详情测试详情测试详情测试详情测试";
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, [StaticTools getLabelHeight:detail defautWidth:tableView.frame.size.width-20 defautHeight:4800 fontSize:15])];
        detailLabel.font = [UIFont systemFontOfSize:17];
        detailLabel.textAlignment = UITextAlignmentCenter;
        detailLabel.text = detail;
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:detailLabel];
        

    }
   
    return cell;
}


@end
