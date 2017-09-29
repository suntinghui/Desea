//
//  PersonalManageViewController.m
//  Desea
//
//  Created by 文彬 on 14-5-23.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "PersonalManageViewController.h"
#import "PersonTableViewCell.h"
#import "PeopleSelectViewController.h"

#define Button_Tag_People  100
#define Button_Tag_Start   101
#define Button_Tag_End     102
#define Button_Tag_Search  103

@interface PersonalManageViewController ()

@end

@implementation PersonalManageViewController

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
    self.navigationItem.title = @"人事管理";
    
    self.personType = @"0";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    NSString *time = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:NO];
    NSString *beTime =[StaticTools getDateStrWithDate:[StaticTools getDateFromDate:[NSDate date] withYear:0 month:0 day:-1] withCutStr:@"-" hasTime:NO];
    [self.startBtn setTitle:beTime forState:UIControlStateNormal];
     [self.endBtn setTitle:time forState:UIControlStateNormal];
    
    ContactsModel *contact = [[ContactsModel alloc]init];
    contact.usrId = ShareManager.userId;
    contact.name = ShareManager.userName;
    self.selectContact =contact;
    
    [self getPersonInfoList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setSelectContact:(ContactsModel *)selectContact
{
    _selectContact = selectContact;
    
    [self.peopleBtn setTitle:selectContact.name forState:UIControlStateNormal];
    self.depLabel.text = selectContact.departMent;
}
#pragma mark -按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Button_Tag_People:
        {
            if ([self.personType isEqualToString:@"0"])
            {
                [SVProgressHUD showErrorWithStatus:@"非管理员账户不能查看他人考勤记录"];
                return;
            }
            
            PeopleSelectViewController *peopleSelectController = [[PeopleSelectViewController alloc]initWithNibName:@"PeopleSelectViewController" bundle:nil];
            peopleSelectController.fatherController = self;
            peopleSelectController.isMutSelect = NO;
            peopleSelectController.selectId = [[NSMutableArray alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:peopleSelectController];
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
            }
            
            [self presentModalViewController:nav animated:YES];

        }
            break;
        case Button_Tag_Start:
        {
            [StaticTools showDateSelectInViewController:self indexDate:nil type:kDatePickerTypeFull clickOk:^(NSString *selectDateStr) {
                
                [self.startBtn setTitle:selectDateStr forState:UIControlStateNormal];
                
            }];
        }
            break;
        case Button_Tag_End:
        {
            [StaticTools showDateSelectInViewController:self indexDate:nil type:kDatePickerTypeFull clickOk:^(NSString *selectDateStr) {
                
                [self.endBtn setTitle:selectDateStr forState:UIControlStateNormal];
                
            }];
        }
            break;
        case Button_Tag_Search:
        {
            NSDate *start =[StaticTools getDateFromDateStr: self.startBtn.titleLabel.text];
            NSDate *end =[StaticTools getDateFromDateStr: self.endBtn.titleLabel.text];
            if ([start earlierDate:end] == end)
            {
                [SVProgressHUD showErrorWithStatus:@"结束日期不能早于开始日期"];
                return;
            }
            
            if (self.selectContact==nil)
            {
                [SVProgressHUD showErrorWithStatus:@"请选择查找人员"];
                return;
            }
            
            [self getPersonInfoList];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -http请求
/**
 *  获取人员考勤数据
 */
- (void)getPersonInfoList
{
    NSDictionary *dict = @{kMethodName:@"GetKaoQin",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"startdate":self.startBtn.titleLabel.text,
                                        @"enddate":self.endBtn.titleLabel.text,
                                        @"sUserIds ":self.selectContact.usrId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 NSArray *listArr = obj[@"list"];
                                                 self.personType = obj[@"userType"];
                                                 
                                                 self.infoList = [NSArray arrayWithArray:listArr];
                                                 if (self.infoList.count==0)
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:@"暂无考勤数据"];
                                                 }
                                                 
                                                 
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
    return self.infoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonTableViewCell" owner:nil options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary *dict = self.infoList[indexPath.row];
    cell.timeLabel.text = dict[@"CHECKTIME"];
    cell.stateLabel.text = dict[@"CHECKTYPE"];
  

    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0)
    {
        cell.backgroundColor = [StaticTools colorWithHexString:@"#F1F1F1"];
    }
    else
    {
        cell.backgroundColor = [StaticTools colorWithHexString:@"#B3E4CE"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
