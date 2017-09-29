//
//  GroupActivityViewController.m
//  Desea
//
//  Created by wenbin on 14-2-23.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "GroupActivityDetailViewController.h"

@interface GroupActivityDetailViewController ()

@end

@implementation GroupActivityDetailViewController

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
    self.navigationItem.title = @"活动详情";
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    [self getActivityDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取集团活动详情
 */
- (void)getActivityDetail
{
    
    NSDictionary *dict = @{kMethodName:@"GetJTHD",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.infoId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 self.resultDict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)obj];
                                                 
                                                 NSLog(@"resultDict %@",self.resultDict);
                                                 [self.listTableView reloadData];
                                                 
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
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3||indexPath.row==4)
    {
        return 35;
    }
    
    NSString *str;
    if (indexPath.row==0)
    {
        str  = self.resultDict[@"title"];
    }
    else if(indexPath.row == 1)
    {
        str  = self.resultDict[@"place"];
    }
    else if(indexPath.row == 2)
    {
        str  = self.resultDict[@"department"];
    }
    else if(indexPath.row == 5)
    {
        str  = self.resultDict[@"content"];
    }
    else if(indexPath.row==6)
    {
        str  = self.resultDict[@"content"];
    }
    
    
    float height  = [StaticTools getLabelHeight:str defautWidth:250 defautHeight:480 fontSize:15];
    height = height<35?35:height;
    return height+10;
    
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = kLevelOneFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 230, 30)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = kLevelOneFont;
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    detailLabel.numberOfLines = 0;
    [cell.contentView addSubview:detailLabel];
    
    
    
    if (indexPath.row==0)
    {
        titleLabel.text = @"标题";
        detailLabel.text = self.resultDict[@"title"];
    }
    else if (indexPath.row==1)
    {
        titleLabel.text = @"活动地点";
        detailLabel.text = self.resultDict[@"place"];
    }
    else if (indexPath.row==2)
    {
        titleLabel.text = @"发起部门";
        detailLabel.text = self.resultDict[@"department"];
    }
    else if (indexPath.row==3)
    {
        titleLabel.text = @"时间";
        detailLabel.text = self.resultDict[@"time"];
    
    }
    else if(indexPath.row==4)
    {
        titleLabel.text = @"状态";
        detailLabel.text = self.resultDict[@"state"];
    }
    else if (indexPath.row==5)
    {
        titleLabel.text = @"参与者";
        detailLabel.text = self.resultDict[@"people"];
    
    }
    else if (indexPath.row==6)
    {
        titleLabel.text = @"内容";
        detailLabel.text =self.resultDict[@"content"];
    }
    
    
    if (indexPath.row!=3&&indexPath.row!=4)
    {
        float height = [StaticTools getLabelHeight:detailLabel.text defautWidth:250 defautHeight:480 fontSize:15];
        height = height<30?30:height;
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width,height );
    }
    
    return cell;
}


@end
