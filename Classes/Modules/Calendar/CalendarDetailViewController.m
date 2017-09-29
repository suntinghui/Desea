//
//  CalendarDetailViewController.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import "ShowContentViewController.h"

@interface CalendarDetailViewController ()

@end

@implementation CalendarDetailViewController

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
    self.navigationItem.title = @"日程详情";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
        
    [self getCalendarDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取日程详情
 */
- (void)getCalendarDetail
{
  
    NSDictionary *dict = @{kMethodName:@"GetRC",
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
    NSArray *attachArr = self.resultDict[@"attachments"];
    return attachArr.count+6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2||indexPath.row==3)
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
        str  = self.resultDict[@"man"];
    }
    else if(indexPath.row == 4)
    {
        str  = self.resultDict[@"people"];
    }
    else if(indexPath.row == 5)
    {
        str  = self.resultDict[@"content"];
    }
    else if(indexPath.row>5)
    {
        NSArray *arr = self.resultDict[@"attachments"];
        str = arr[indexPath.row-6][@"title"];
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = kLevelOneFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 250, 30)];
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
        titleLabel.text = @"执行人";
         detailLabel.text = self.resultDict[@"man"];
    }
    else if (indexPath.row==2)
    {
        titleLabel.text = @"时间";
         detailLabel.text = self.resultDict[@"time"];
    }
    else if (indexPath.row==3)
    {
        titleLabel.text = @"范围";
         detailLabel.text = self.resultDict[@"arear"];
        
        
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 50, 30)];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.font = kLevelOneFont;
        stateLabel.text = @"状态";
        [cell.contentView addSubview:stateLabel];
        
        UILabel *stateDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 70, 30)];
        stateDetailLabel.backgroundColor = [UIColor clearColor];
        stateDetailLabel.font = kLevelOneFont;
        [cell.contentView addSubview:stateDetailLabel];
        stateDetailLabel.text = self.resultDict[@"state"];
        
        
    }
    else if (indexPath.row==4)
    {
        titleLabel.text = @"参与者";
        detailLabel.text = self.resultDict[@"people"];
    }
    else if (indexPath.row==5)
    {
        titleLabel.text = @"内容";
         detailLabel.text =self.resultDict[@"content"];
    }
    else
    {
        if (indexPath.row!=6)
        {
            titleLabel.hidden = YES;
        }
        NSDictionary *attachmentDict = self.resultDict[@"attachments"][indexPath.row-6];
        titleLabel.text = @"附件";
        detailLabel.text = attachmentDict[@"title"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        detailLabel.textColor = [UIColor blueColor];
    }
    
    
    if (indexPath.row!=2&&indexPath.row!=3)
    {
        float height = [StaticTools getLabelHeight:detailLabel.text defautWidth:250 defautHeight:480 fontSize:15];
        height = height<30?30:height;
        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width,height );
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>5)
    {
        NSArray *attachments  = self.resultDict[@"attachments"];
        NSDictionary *attachment = attachments[indexPath.row-6];
        
        ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:attachment[@"title"] AttachId:attachment[@"Id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
