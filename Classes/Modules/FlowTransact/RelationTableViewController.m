//
//  RelationTableViewController.m
//  Desea
//
//  Created by 文彬 on 14-4-2.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "RelationTableViewController.h"
#import "DocumentCell.h"
#import "FlowHandleViewController.h"

@interface RelationTableViewController ()

@end

@implementation RelationTableViewController

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
    
    [self getList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark--HTTP请求

/**
 *  获取关联流理列表
 *
 *  @param
 */
- (void)getList
{
    
    NSDictionary *dict = @{kMethodName:@"GetGLLCList",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.infoId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                 NSArray *listArr = (NSArray*)obj;
                                                 self.resultArr = [NSMutableArray arrayWithArray:listArr];
                                                 
                                                 [self.listTableView reloadData];
                                                 
                                                 if (self.resultArr.count==0)
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DocumentCell" owner:nil options:nil] objectAtIndex:0];
        
        cell.titleLabel.frame = CGRectMake(20, cell.titleLabel.frame.origin.y, 300, cell.titleLabel.frame.size.height);
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 2, 17, 30)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:numLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dict = self.resultArr[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    cell.typeLabel.text = dict[@"type"];
    cell.contentLabel.text = dict[@"content"];
    cell.pepoleLabel.text = dict[@"people"];
    
    
    
    return cell;
}
//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row%2==0)
    //    {
    cell.backgroundColor = [StaticTools colorWithHexString:@"#F1F1F1"];
    //    }
    //    else
    //    {
    //        cell.backgroundColor = [StaticTools colorWithHexString:self.cellColor];
    //    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.resultArr[indexPath.row];
    
    FlowHandleViewController *flowHandleController = [[FlowHandleViewController alloc]initWithNibName:@"FlowHandleViewController" bundle:nil];
    flowHandleController.sType = 2;
    flowHandleController.infoId = dict[@"id"];
    [self.fatherController.navigationController pushViewController:flowHandleController animated:YES];
}


@end
