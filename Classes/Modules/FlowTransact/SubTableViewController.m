//
//  SubTableViewController.m
//  Desea
//
//  Created by wenbin on 14-3-12.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "SubTableViewController.h"

@interface SubTableViewController ()

@end

@implementation SubTableViewController

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
    
    [self getSubTableInfo];
//    [self GetGLLCList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能函数
- (float)getCellHeightWithIndex:(NSIndexPath*)index
{

    if (index.section<self.resultArr.count)
    {
        NSDictionary *dict = self.resultArr[index.section];
        NSArray *bodys = dict[@"body"];
        NSArray *bodyArr = bodys[index.row];
        NSArray *widths  = dict[@"width"];
        float width = [widths[index.section] floatValue];
        
        float height = 45;
        for (int i=0; i<bodyArr.count; i++)
        {
            float he  = [StaticTools getLabelHeight:bodyArr[i] defautWidth:width defautHeight:4800 fontSize:15];
            height = height>he?height:he;
        }
        return height;
    }
   
    return 35;
}
#pragma mark
#pragma mark http请求

/**
 *  获取从表数据
 */
- (void)getSubTableInfo
{

    NSDictionary *dict = @{kMethodName:@"GetLCBDCB",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId,
                                        @"InfoId":self.infoId,
                                        @"sType":[NSString stringWithFormat:@"%d",self.sType]}}; 
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if (obj==nil)
                                             {
                                                 [StaticTools showAlertWithTag:0
                                                                         title:nil
                                                                       message:@"暂无相关数据！"
                                                                     AlertType:CAlertTypeDefault
                                                                     SuperView:nil];
                                                 return ;
                                             }
                                             
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                
                                                 self.resultArr = [NSMutableArray arrayWithArray:obj];
                                                 if (self.resultArr.count==0)
                                                 {
                                                     [StaticTools showAlertWithTag:0
                                                                             title:nil
                                                                           message:@"暂无相关数据！"
                                                                         AlertType:CAlertTypeDefault
                                                                         SuperView:nil];
                                                     return ;
                                                 }
                                                 
                                                 //查找宽度最大的table组 作为scroview的content width
                                                 float maxWidth = 0;
                                                 for (NSDictionary *dict in self.resultArr)
                                                 {
                                                     float singleWidth=0;
                                                     NSArray *widths = dict[@"width"];
                                                     for (NSString *width in widths)
                                                     {
                                                         singleWidth+=[width floatValue];
                                                     }
                                                     
                                                     maxWidth=maxWidth>singleWidth?maxWidth:singleWidth;
                                                 }
                                                 
                                                 self.scrView.contentSize = CGSizeMake(maxWidth, self.view.frame.size.height);
                                                 self.listTableView.frame = CGRectMake(0, 0, maxWidth,  self.view.frame.size.height);
                                                 
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

/**
 *  获取管理流程列表
 */
- (void)GetGLLCList
{
    
    NSDictionary *dict = @{kMethodName:@"GetGLLCList",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.infoId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                 self.flowArr = [NSMutableArray arrayWithArray:obj];
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
    return self.resultArr.count+self.flowArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<self.resultArr.count)
    {
        NSDictionary *dict = self.resultArr[section];
        NSArray *bodys = dict[@"body"];
        return bodys.count;
    }
    else
    {
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeightWithIndex:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    backView.backgroundColor = [UIColor lightGrayColor];
    
    if (section<self.resultArr.count)
    {
       
        NSDictionary *dict = self.resultArr[section];
        NSArray *heads = dict[@"head"];
        NSArray *widths = dict[@"width"];
        
        
        UILabel *lastTabel;
        for (int i=0; i<heads.count; i++)
        {
            float width = [widths[i] floatValue];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i==0?2:lastTabel.frame.origin.x+lastTabel.frame.size.width+2, 0, width, 35)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = UITextAlignmentCenter;
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeCharacterWrap;
            label.text = heads[i];
            
            [backView addSubview:label];
            lastTabel = label;
        }
        
        return backView;

    }
    else
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, tableView.frame.size.width-10, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:titleLabel];
         NSDictionary *dict = self.flowArr[section-self.resultArr.count];
        titleLabel.text = dict[@"title"];
        return backView;
    }
    return nil;
    
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

    if (indexPath.section<self.resultArr.count)
    {
        NSDictionary *dict = self.resultArr[indexPath.section];
        NSArray *bodys = dict[@"body"];
        NSArray *heads = dict[@"head"];
        NSArray *widths = dict[@"width"];
        NSArray *bodyArr = bodys[indexPath.row];
        
        UILabel *lastTabel;
        for (int i=0; i<heads.count; i++)
        {
            float width = [widths[i] floatValue];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i==0?2:lastTabel.frame.origin.x+2+lastTabel.frame.size.width, 0, width, [StaticTools getLabelHeight:bodyArr[i] defautWidth:width defautHeight:4800 fontSize:15])];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text = bodyArr[i];
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeCharacterWrap;
            
            [cell.contentView addSubview:label];
            lastTabel = label;
            
            if (i!=0)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x-4, 0, 1, [self getCellHeightWithIndex:indexPath])];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
            }
            
        }
        
         return cell;
        
    }
    else
    {

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 3, tableView.frame.size.width-110, 30)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:detailLabel];
        
        NSDictionary *dict = self.flowArr[indexPath.section-self.resultArr.count];
        if (indexPath.row==0)
        {
            titleLabel.text = @"工作类型";
            detailLabel.text = dict[@"type"];
        }
        else  if (indexPath.row==1)
        {
            titleLabel.text = @"工作任务";
            detailLabel.text = dict[@"work"];
        }
        else  if (indexPath.row==2)
        {
            titleLabel.text = @"发送人";
            detailLabel.text = dict[@"people"];
        }
        return cell;
    }
    
    
    return nil;
}


@end
