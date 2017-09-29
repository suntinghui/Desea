//
//  FlowHandleSecViewController.m
//  Desea
//
//  Created by wenbin on 14-2-27.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "FlowHandleSecViewController.h"
#import "SelectorViewController.h"
#import "PeopleSelectViewController.h"

@interface FlowHandleSecViewController ()

@end

@implementation FlowHandleSecViewController

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
//    self.operationType=2;
    self.navigationItem.title  = @"操作提交";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    rightButton.tag = 99;
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.currentAct  = self.activitys[0][@"Activity"];
    self.operationType = [self.currentAct[@"Mode"] intValue];
    
    //默认设置为选择第一个节点
    for (int i=0; i<self.activitys.count; i++)
    {
        NSMutableDictionary *dict = self.activitys[i][@"Activity"];
        [dict setValue:@"0" forKey:@"Select"];
    }
    [self.currentAct setObject:@"1" forKey:@"Select"];
    
     [self setBackButtonWithTitle:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark

/**
 *  在选择页面选择了数据后调用 刷新页面显示
 */
- (void)refreshData
{
    
    [self.listTableView reloadData];
}

#pragma mark
#pragma mark 按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag==99) //流程提交
    {
        if ( [self.currentAct[@"Mode"] isEqualToString:@"0"])
        {
         
            if (self.currentAct[@"ZBR"]==nil)
            {
                [StaticTools showAlertWithTag:0
                                        title:nil
                                      message:@"请选择主办人！"
                                    AlertType:CAlertTypeDefault
                                    SuperView:nil];

            }
        }
        else
        {
            NSArray *cyrs = self.currentAct[@"CYRs"];
            if (cyrs.count==0)
            {
                [StaticTools showAlertWithTag:0
                                        title:nil
                                      message:@"请选择相关办理人！"
                                    AlertType:CAlertTypeDefault
                                    SuperView:nil];
                return;
            }
        }
        
        
        if ([self.fatherController respondsToSelector:@selector(saveFormWithType:)])
        {
         
            [self.fatherController performSelector:@selector(saveFormWithType:) withObject:@"1"];
        }
        
        
        
    }
    else
    {
        if (button.tag == 200) //下级节点选择
        {
            SelectorViewController *selectorController = [[SelectorViewController alloc]initWithNibName:@"SelectorViewController" bundle:nil];
            selectorController.dataArr = self.activitys;
            selectorController.fatherController = self;
            selectorController.pageType=1;
            selectorController.title = @"下级节点选择";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectorController];
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
            }
            [self presentModalViewController:nav animated:YES];
        }
        else if(button.tag==203||button.tag==204)
        {
            PeopleSelectViewController *peopleSelectController = [[PeopleSelectViewController alloc]initWithNibName:@"PeopleSelectViewController" bundle:nil];
            peopleSelectController.fatherController = self;
            if (button.tag==203) //主办人员（单选）
            {
                NSString *value = self.currentAct[@"ZBR"][@"UserId"];
                if (![StaticTools isEmptyString:value])
                {
                  peopleSelectController.selectId = [NSMutableArray arrayWithObject:value];   
                }
                else
                {
                    peopleSelectController.selectId = [[NSMutableArray alloc]init];
                }
                peopleSelectController.isMutSelect = NO;
                
            }
            else //相关办理人员（多选）
            {
                NSArray *cyrs =self.currentAct[@"CYRs"];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in cyrs)
                {
                    [arr addObject:dict[@"CYR"][@"UserId"]];
                }
                peopleSelectController.selectId = arr;
                peopleSelectController.isMutSelect = YES;
            }
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:peopleSelectController];
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
            }
            
            [self presentModalViewController:nav animated:YES];
        }
        
      
    }
   
}


#pragma mark
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark-
#pragma mark--UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableViewCell *cell;
    if (IOS7_OR_LATER)
    {
        cell = (UITableViewCell*)[[[textView superview] superview] superview];
    }
    else
    {
        cell = (UITableViewCell*)[[textView superview] superview];
    }
    CGRect frame = [self.listTableView convertRect:cell.frame toView:self.listTableView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.listTableView.contentOffset = CGPointMake(0, frame.origin.y);
    }];
    
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
  if(indexPath.row==4)
    {
        NSArray *cyrArr =self.currentAct[@"CYRs"];
        NSMutableString *cyrStr = [[NSMutableString alloc]init];
        for (NSDictionary *dict in cyrArr)
        {
            [cyrStr appendString:[NSString stringWithFormat:@"%@,",dict[@"CYR"][@"UserName"]]];
        }
        
        return [StaticTools getLabelHeight:cyrStr defautWidth:300 defautHeight:4800 fontSize:15]+40;
    }
  
    return 60;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:titleLabel];
    
//    
//    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 30, 300, 30)];
//    [cell.contentView addSubview:detailTextView];
//    detailTextView.tag = 100+indexPath.row;
//    detailTextView.font = [UIFont systemFontOfSize:15];
//    detailTextView.backgroundColor = [UIColor clearColor];
//    detailTextView.delegate = self;
//    [cell.contentView addSubview:detailTextView];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 300, 30)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont boldSystemFontOfSize:15];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [cell.contentView addSubview:detailLabel];
    
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actBtn.frame = CGRectMake(280, 5, 25, 25);
    [actBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [actBtn setTitle:@"选择" forState:UIControlStateNormal];
    actBtn.tag = 200+indexPath.row;
    [actBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:actBtn];
    
    if (indexPath.row==0)
    {
        titleLabel.text = @"下级节点";
        detailLabel.text = self.currentAct[@"Name"];
    }
    else if(indexPath.row==1)
    {
        titleLabel.text = @"节点办理时限(工作日)";
        detailLabel.text = self.currentAct[@"DealTime"];
        actBtn.hidden = YES;
    }
  
    else if(indexPath.row==2)
    {
        [actBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
        titleLabel.text = @"节点模式";
        actBtn.hidden = YES;
        
        if ( [self.currentAct[@"Mode"] isEqualToString:@"0"])
        {
             detailLabel.text = @"主办人模式";
        }
        else if ( [self.currentAct[@"Mode"] isEqualToString:@"1"])
        {
            detailLabel.text = @"会签人模式";
        }
        else if ( [self.currentAct[@"Mode"] isEqualToString:@"2"])
        {
            detailLabel.text = @"单人签发模式";
        }
       
    }
    else if(indexPath.row==3)
    {
        
        titleLabel.text = @"主办人员";
        detailLabel.text = self.currentAct[@"ZBR"][@"UserName"];
    }
    else if(indexPath.row==4)
    {
       
        titleLabel.text = @"相关办理人员";
        NSArray *cyrArr =self.currentAct[@"CYRs"];
        NSMutableString *cyrStr = [[NSMutableString alloc]init];
        for (NSDictionary *dict in cyrArr)
        {
            [cyrStr appendString:[NSString stringWithFormat:@"%@,",dict[@"CYR"][@"UserName"]]];
        }
        detailLabel.text = cyrStr;
        detailLabel.frame = CGRectMake(5, 30, 300, [StaticTools getLabelHeight:detailLabel.text defautWidth:300 defautHeight:4800 fontSize:15]);
    }
    
   
    
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

@end
