//
//  DocumentTransactHandleViewController.m
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "DocumentTransactHandleViewController.h"
#import "AttachmentListViewController.h"
#import "FlowPathViewController.h"

@interface DocumentTransactHandleViewController ()
{
    ScrollSelectView *scrollSelectView;
    NSArray *titleArr;
    AttachmentListViewController *attchmentListController;
    FlowPathViewController *flowPathController;
}
@end

@implementation DocumentTransactHandleViewController

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
    
    self.navigationItem.title = @"公文办理";
    
    scrollSelectView= [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 30) titles:@[@"表单",@"正文",@"附件",@"办理轨迹"]];
    scrollSelectView.delegate = self;
    [self.view addSubview:scrollSelectView];
    
    titleArr = @[@"密  级",@"保密期限",@"紧急程度",@"发文类型",@"文  种",@"主办单位",@"拟稿人",@"标  题",@"主送分送",@"内部分送"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark--SrollSelectViewDelegate
- (void)ScrollSelectDidCickWith:(int)num
{
    if (num ==scrollSelectView.selectIndex )
    {
        return;
    }
    for (UIView *view in self.view.subviews)
    {
        if (![view isKindOfClass:[ScrollSelectView class]]&&
            ![view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if (num==0)
    {
        
    }
    else if(num==1)
    {
        
    }
    else if(num==2) //附件
    {
        NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
        attchmentListController = [[AttachmentListViewController alloc]initWithNibName:@"AttachmentListViewController" bundle:nil];
        attchmentListController.view.frame = self.listTableView.frame;
        [self.view addSubview:attchmentListController.view];
    }
    else if(num==3) //办理轨迹
    {
        flowPathController = [[FlowPathViewController alloc]initWithNibName:@"FlowPathViewController" bundle:nil];
        flowPathController.view.frame = self.listTableView.frame;
        [self.view addSubview:flowPathController.view];
    }
}

#pragma mark-
#pragma mark--UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 50;
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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = kLevelOneFont;
    titleLabel.text = titleArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
  
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 80, 30)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = kLevelOneFont;
    detailLabel.text = titleArr[indexPath.row];
    [cell.contentView addSubview:detailLabel];


    return cell;
    
}
@end
