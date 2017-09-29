//
//  SelectorViewController.m
//  Desea
//
//  Created by wenbin on 14-2-27.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "SelectorViewController.h"
#import "FlowHandleSecViewController.h"

#define Action_Tag_OK  100
#define Action_Tag_Cancel 101

@interface SelectorViewController ()

@end

@implementation SelectorViewController

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
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.tag = Action_Tag_OK;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.leftBarButtonItem = nil;
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 50, 30);
//    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    leftButton.tag = Action_Tag_Cancel;
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark 按钮点击事件

- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    [self dismissModalViewControllerAnimated:YES];
    switch (button.tag)
    {
        case Action_Tag_OK:
        {
            if (self.pageType==1)//下级节点选择
            {
                FlowHandleSecViewController *flowSecController = (FlowHandleSecViewController*)self.fatherController;
                flowSecController.currentAct = self.dataArr[self.currentSelect][@"Activity"];
            }
            [self.fatherController performSelector:@selector(refreshData) withObject:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pageType == 0 ) //枚举值单选
    {
        NSArray *arr =self.fileldDict[@"OPTIONS"];
        return arr.count;
    }
    else if(self.pageType==1) //下级节点选择
    {
        return self.dataArr.count;
    }
   
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
    
    if (self.pageType==0) //枚举值单选
    {
         NSArray *arr =self.fileldDict[@"OPTIONS"];
        
        NSMutableDictionary *dict = arr[indexPath.row][@"Item"];
        cell.textLabel.text = dict[@"Text"];
        
        if ([dict[@"DefaultFlag"] isEqualToString:@"1"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if(self.pageType==1) //下级节点选择
    {
        NSMutableDictionary *dict = self.dataArr[indexPath.row][@"Activity"];
        cell.textLabel.text = dict[@"Name"];
        
        if ([dict[@"Select"] isEqualToString:@"1"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    

    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.currentSelect = indexPath.row;
    
  if(self.pageType==0) //枚举值单选
  {
      NSArray *arr =self.fileldDict[@"OPTIONS"];
      for (int i=0; i<arr.count; i++)
      {
           NSMutableDictionary *dict = arr[i][@"Item"];
           [dict setValue:@"0" forKey:@"DefaultFlag"];
      }
     
     NSMutableDictionary *dict = arr[indexPath.row][@"Item"];
     [dict setValue:@"1" forKey:@"DefaultFlag"];
      
    [self.listTableView reloadData];
      
  [self.fileldDict setObject:dict[@"Text"] forKey:@"SHOWCONTENT"];
  [self.fileldDict setObject:dict[@"Value"] forKey:@"Value"];
    
      
  }
  else if(self.pageType==1) //下级节点选择
  {
      for (int i=0; i<self.dataArr.count; i++)
      {
          NSMutableDictionary *dict = self.dataArr[i][@"Activity"];
          [dict setValue:@"0" forKey:@"Select"];
      }
      
      NSMutableDictionary *dict = self.dataArr[indexPath.row][@"Activity"];
      [dict setValue:@"1" forKey:@"Select"];
      
      [self.listTableView reloadData];
  }
    
}

@end
