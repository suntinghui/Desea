//
//  FlowPathViewController.m
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "FlowPathViewController.h"

@interface FlowPathViewController ()

@end

@implementation FlowPathViewController

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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = kLevelOneFont;
    cell.detailTextLabel.font = kLevelOneFont;
    
    if (indexPath.row==0)
    {
        cell.textLabel.text = @"序号：";
        cell.detailTextLabel.text = @"detail";
    }
    else if (indexPath.row==1)
    {
        cell.textLabel.text = @"办理人：";
        cell.detailTextLabel.text = @"detail";
    }
    else if (indexPath.row==2)
    {
        cell.textLabel.text = @"办理状态：";
        cell.detailTextLabel.text = @"detail";
    }
    else if (indexPath.row==3)
    {
        cell.textLabel.text = @"办理结果：";
        cell.detailTextLabel.text = @"detail";
    }
    else if (indexPath.row==4)
    {
        cell.textLabel.text = @"工作点：";
        cell.detailTextLabel.text = @"detail";
    }
    
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section%2==0)
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = RGBCOLOR(170, 211, 231);
    }
    
}
@end
