//
//  FlowHandleViewController.m
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "FlowHandleViewController.h"
#import "FlowPathViewController.h"
#import "AttachmentListViewController.h"
#import "ShowContentViewController.h"
#import "SelectorViewController.h"
#import "FlowHandleSecViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "DepartmentSelectorViewController.h"
#import "PeopleSelectViewController.h"
#import "XMLWriter.h"
#import "SubTableViewController.h"
#import "RelationTableViewController.h"

#define Alert_Tag_Cancel  100
#define Alert_Tag_Back    101

@interface FlowHandleViewController ()
{
    ScrollSelectView *scrollSelectView;
    AttachmentListViewController *attchmentListController;
    FlowPathViewController *flowPathController;
    ShowContentViewController *contentViewController;
    SubTableViewController *subTableController;
    RelationTableViewController *relationTableController;
}
@end

@implementation FlowHandleViewController

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
    self.navigationItem.title = @"流程办理";
    
    [self initPageControl];
    
    [self getDetail];
    
     [self setBackButtonWithTitle:nil];
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark
#pragma mark 功能函数
- (void)back
{
    [super back];
    [ShareManager.departmentArr removeAllObjects];
    [ShareManager.selectDepartment removeAllObjects];
}

/**
 *  初始化页面控件
 */
- (void)initPageControl
{
    self.dateView.frame = CGRectMake(0,0, 320, self.view.frame.size.height);
    [self.view addSubview:self.dateView];
    self.dateView.hidden = YES;
    
    //暂时先去掉办理轨迹
    //    scrollSelectView= [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 30) titles:@[@"表单",@"正文",@"附件",@"办理轨迹"]];
    scrollSelectView= [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 30) titles:@[@"表单",@"正文",@"附件",@"从表",@"关联流程"]];
    scrollSelectView.delegate = self;
    [self.view addSubview:scrollSelectView];
    
    //历史记录和撤销箱不能保存和提交
    if (self.sType==2||self.sType==4)
    {
        self.toolBar.hidden = YES;
        self.listTableView.frame = CGRectMake(self.listTableView.frame.origin.x, self.listTableView.frame.origin.y, self.listTableView.frame.size.width, self.listTableView.frame.size.height+40);

    }
    
    [self getList];
    
}

/**
 *  弹出时间或日期选择页面
 *
 *  @param type 
 */
- (void)showDatePickerWithType:(UIDatePickerMode)type
{
    [UIView animateWithDuration:0.5 animations:^{
       
    self.datePicker.datePickerMode = type;
       
         self.dateView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        [self.view endEditing:YES];
    }];
   

}

/**
 *  在选择页面选择了数据后调用 刷新页面显示
 */
- (void)refreshData
{
 
    [self.view endEditing:YES];
    [self.listTableView reloadData];
}

/**
 *  检查页面输入
 *
 *  @return
 */
- (BOOL)checkInputValue
{
    for (NSDictionary *dict in self.resultDict[@"Fields"])
    {
        NSDictionary *field = dict[@"Field"];
        if ([field[@"LK_FIELDEDITMODE"] isEqualToString:@"2"]&&
            [StaticTools isEmptyString:field[@"Value"]]) //必填项没有内容
        {
            [StaticTools showAlertWithTag:0
                                    title:nil
                                  message:[NSString stringWithFormat:@"%@项没有填内容！",field[@"LK_FIELDEDIT_TIPNAME"]]
                                AlertType:CAlertTypeDefault
                                SuperView:nil];
            return NO;
            
        }
        
    }
    
    return YES;
    
}

#pragma mark -keyboardDelegate
-(void)keyboardWasShown:(NSNotification *)notification
{

    
    NSValue  *valu_=[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGRect rectForkeyBoard=[valu_ CGRectValue];
    
  
//    self.listTableView.contentSize=CGSizeMake(self.listTableView.contentSize.width,self.listTableView.contentSize.height+rectForkeyBoard.size.height-keyBoardLastHeight);
    
     keyBoardLastHeight=rectForkeyBoard.size.height;
    
     NSIndexPath * indexPath=[NSIndexPath indexPathForRow:self.currentEditIndex inSection:0];
    
    CGRect rectForRow=[self.listTableView rectForRowAtIndexPath:indexPath];
    
    float touchSetY=(IsIPhone5?548:460)-rectForkeyBoard.size.height-rectForRow.size.height-self.listTableView.frame.origin.y-49;//44为navigationController的高度,如果没有就不用减去44
    if (rectForRow.origin.y>touchSetY) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.listTableView.contentOffset=CGPointMake(0,rectForRow.origin.y-touchSetY);
        [UIView commitAnimations];
    }
    
    
}

-(void)keyboardWasHidden:(NSNotification *)notification
{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
//    self.listTableView.contentSize=CGSizeMake(self.listTableView.contentSize.width,self.listTableView.contentSize.height);
    
    keyBoardLastHeight=0;
    [UIView commitAnimations];
}
#pragma mark
#pragma mark 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case 200: //日期控件取消
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.dateView.hidden = YES;
            }];
        }
            break;
        case 201: //日期控件确定
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.dateView.hidden = YES;
            }];
            
            NSDate *selected = [self.datePicker date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            if (self.datePicker.datePickerMode == UIDatePickerModeTime)
            {
                  [dateFormatter setDateFormat:@"HH:mm"];
            }
            else   if (self.datePicker.datePickerMode == UIDatePickerModeDate)
            {
                  [dateFormatter setDateFormat:@"yyy-MM-dd"];
            }
            else   if (self.datePicker.datePickerMode == UIDatePickerModeDateAndTime)
            {
                  [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm"];
            }
            
            NSString *select = [dateFormatter stringFromDate:selected];
                    
            NSArray *fields = self.resultDict[@"Fields"];
            NSMutableDictionary *dict = fields[self.currentEditIndex][@"Field"];
            [dict setObject:select forKey:@"SHOWCONTENT"];
            [dict setObject:select forKey:@"Value"];
            [self.listTableView reloadData];
        }
            
            break;
        case 202: //保存
        {
            if (![self checkInputValue])
            {
                return;
            }
            
            [self saveFormWithType:@"0"];
        }
            break;
        case 203: //提交流程
        {
            if (![self checkInputValue])
            {
                return;
            }
            
            FlowHandleSecViewController *flowHandleSecController = [[FlowHandleSecViewController alloc]initWithNibName:@"FlowHandleSecViewController" bundle:nil];
            flowHandleSecController.activitys = self.resultDict[@"Activitys"];
            flowHandleSecController.fatherController = self;
            [self.navigationController pushViewController:flowHandleSecController animated:YES];
        }
            break;
        case 204: //撤销
        {
            [StaticTools showAlertWithTag:Alert_Tag_Cancel
                                    title:nil
                                  message:@"您确定要撤销吗？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
        }
            break;
        case 205: //退回
        {
            [StaticTools showAlertWithTag:Alert_Tag_Back
                                    title:nil
                                  message:@"您确定要退回吗？"
                                AlertType:CAlertTypeCacel
                                SuperView:self];
        }
            break;
    
        default:
            break;
    }
}

//兼职部门选择   原 button.tag>200
- (void)commonAdviceClick1:(UIButton*)button
{
    self.currentEditIndex  = button.tag-200;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"兼职部门"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:@"取消"
                                             otherButtonTitles:nil];
    NSArray *ParttimesArr =self.resultDict[@"Parttimes"];
    for (NSDictionary *item in ParttimesArr)
    {
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@ %@",item[@"DeptName"],item[@"PostName"]]];
    }
    sheet.tag = 100;
    [sheet showInView:self.view];

}

//意见选择
- (void)commonAdviceClick2:(UIButton*)button
{
    self.currentEditIndex  = button.tag-100;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"常用意见"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:@"取消"
                                             otherButtonTitles:nil];
    NSArray *cyyjArr =self.resultDict[@"CYYJ"];
    for (NSString *item in cyyjArr)
    {
        [sheet addButtonWithTitle:item];
    }
    sheet.tag = 200;
    [sheet showInView:self.view];
}


#pragma mark-
#pragma mark--HTTP请求
/**
 *  获取流程管理
 */
- (void)getDetail
{
//    self.sType = 0;
//    
//    NSDictionary *dict = @{kMethodName:@"GetLCBD",
//                           kWebServiceName:@"WebService.asmx",
//                           kParamName:@{@"InfoId":@"5011c1d3-8d8a-4758-8c3b-d8ce7fd28669",//self.infoId,
//                                        @"sUserId":@"1",//ShareManager.userId,
//                                        @"sType":@"0"}}; //[NSString stringWithFormat:@"%d",self.sType]}};
    
    NSDictionary *dict = @{kMethodName:@"GetLCBD",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.infoId,
                                        @"sUserId":ShareManager.userId,
                                        @"sType":[NSString stringWithFormat:@"%d",self.sType]}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSMutableDictionary class]])
                                             {
                                                 NSLog(@"%@",obj);
                                                 self.resultDict = [NSMutableDictionary dictionaryWithDictionary:obj];
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
 *  获取正文url
 */
- (void)getContentUrl
{
    
    NSDictionary *dict = @{kMethodName:@"GetLCZW",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.infoId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSString class]])
                                             {
                                                 //没有正文时返回一个空字符串
                                                 if ([StaticTools isEmptyString:obj])
                                                 {
                                                     [StaticTools showAlertWithTag:0
                                                                             title:nil
                                                                           message:@"暂无正文！"
                                                                         AlertType:CAlertTypeDefault SuperView:nil];
                                                 }
                                                 else
                                                 {
                                                     NSString *host = [UserDefaults objectForKey:kHostAddress];
                                                     contentViewController = [[ShowContentViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@",host,obj]];
                                                     
                                                 }
                                               
                                                 
                                                 [self ScrollSelectDidCickWith:1];
                                                 
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
 *  保存或提交表单
 *
 *  @param type   @"0":保存  @“1”：提交 2:退回 3；撤销
 */
- (void)saveFormWithType:(NSString*)type
{
    
    NSMutableString *activitys = [[NSMutableString alloc]init];
    [activitys appendString:@"<Activitys>"];
    NSArray *arr = self.resultDict[@"Activitys"];
    for (NSDictionary *actdict in arr)
    {
        NSDictionary *dict = actdict[@"Activity"];
        NSMutableString *activity = [[NSMutableString alloc]init];
        [activity appendString:@"<Activity>"];
    
        [activity appendString:[NSString stringWithFormat:@"<ZBR>%@%@</ZBR>",[self getNodStrWithDict:dict[@"ZBR"] andKey:@"UserId"] ,[self getNodStrWithDict:dict[@"ZBR"] andKey:@"UserName"]]];
        
         [activity appendString:[self getNodStrWithDict:dict andKey:@"ReSelect"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"Interpose"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"DealTime"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"Mode"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"Type"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"Name"]];
         [activity appendString:[self getNodStrWithDict:dict andKey:@"Id"]];
        [activity appendString:[self getNodStrWithDict:dict andKey:@"Select"]];
        
        
//        [activity appendString:[NSString stringWithFormat:@"<Select><![CDATA[%@]]></Select>",dict[@"Select"]]];


        NSArray *cyrsArr= dict[@"CYRs"];
        if (cyrsArr.count>0)
        {
            NSMutableString *cyrs = [[NSMutableString alloc]init];
            
            [cyrs appendString:@"<CYRs>"];
            for (NSDictionary *opetiondict in cyrsArr)
            {
                NSDictionary *dict = opetiondict[@"CYR"];
                NSMutableString *CYR = [[NSMutableString alloc]init];
                [CYR appendString:@"<CYR>"];
                
                [CYR appendString:[self getNodStrWithDict:dict andKey:@"UserId"]];
                [CYR appendString:[self getNodStrWithDict:dict andKey:@"UserName"]];
                
                [CYR appendString:@"</CYR>"];
                
                [cyrs appendString:CYR];
            }
            
            [cyrs appendString:@"</CYRs>"];
            [activity appendString:cyrs];
        }
        else
        {
            [activity appendString:@"<CYRs/>"];
        }

        
        [activity appendString:@"</Activity>"];
        
        [activitys appendString:activity];
    }
   [activitys appendString:@"</Activitys>"];
    
    NSMutableString *fields = [[NSMutableString alloc]init];
    
    [fields appendString:@"<Fields>"];
    NSArray *fieldsarr = self.resultDict[@"Fields"];
    for (NSDictionary *fielddict in fieldsarr)
    {
        NSDictionary *dict = fielddict[@"Field"];
        NSMutableString *field = [[NSMutableString alloc]init];
        [field appendString:@"<Field>"];
        
        [field appendString:[self getNodStrWithDict:dict andKey:@"LK_FIELDEDITMODE"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"LK_FLDDBTYPE"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"LK_FIELDEDIT_TIPNAME"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"LK_COLFIELDID"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"Value"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"ParttimeDept"]];
        [field appendString:[self getNodStrWithDict:dict andKey:@"ParttimePost"]];
        
        NSArray *optionsArr= fielddict[@"Field"][@"OPTIONS"];
        if (optionsArr.count>0)
        {
            NSMutableString *options = [[NSMutableString alloc]init];
            [options appendString:@"<OPTIONS>"];
            for (NSDictionary *opetiondict in optionsArr)
            {
                NSDictionary *dict = opetiondict[@"Item"];
                NSMutableString *Item = [[NSMutableString alloc]init];
                [Item appendString:@"<Item>"];
                
                 [Item appendString:[self getNodStrWithDict:dict andKey:@"Value"]];
                 [Item appendString:[self getNodStrWithDict:dict andKey:@"Text"]];
                 [Item appendString:[self getNodStrWithDict:dict andKey:@"DefaultFlag"]];

                [Item appendString:@"</Item>"];
                
                [options appendString:Item];
            }
            
            [options appendString:@"</OPTIONS>"];
            [field appendString:options];
        }
        else
        {
            [field appendString:@"<OPTIONS/>"];
        }
        
        [field appendString:@"</Field>"];
        
        [fields appendString:field];
    }
    [fields appendString:@"</Fields>"];
    
    
    
    NSString *FEG_20_COL_10 = [self getNodStrWithDict:self.resultDict andKey:@"FEG_20_COL_10"];
    NSString *FEG_30_COL_10 = [self getNodStrWithDict:self.resultDict andKey:@"FEG_30_COL_10"] ;
    NSString *FEG_20_COL_20 = [self getNodStrWithDict:self.resultDict andKey:@"FEG_20_COL_20"] ;
    
    NSString *info = [NSString stringWithFormat:@"<Infor>%@%@%@%@%@</Infor>",FEG_20_COL_10,FEG_30_COL_10,FEG_20_COL_20,fields,activitys];
    
    NSLog(@"info is %@",info);
    
    NSDictionary *dict = @{kMethodName:@"SetGLBD",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sType":[NSString stringWithFormat:@"%@",type],
                                        @"sUserId":ShareManager.userId,
                                        @"Infors":(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)info, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8))}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                             {
                                 
                                 if ([obj isKindOfClass:[NSString class]])
                                 {
                                    
                                     if (![obj isEqualToString:@"0"])
                                     {
                                         
                                         
                                         if ([type isEqualToString:@"0"])
                                         {
                                            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }
                                         else if([type isEqualToString:@"1"])
                                         {
                                            [SVProgressHUD showSuccessWithStatus:@"流转成功！"];
                                             
                                             [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                                         }
                                         else if([type isEqualToString:@"2"])
                                         {
                                             [SVProgressHUD showSuccessWithStatus:@"退回成功！"];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         else if([type isEqualToString:@"3"])
                                         {
                                             [SVProgressHUD showSuccessWithStatus:@"撤销成功！"];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         
                                         
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEORCOMMITSUCESS" object:nil];
                                     }
                                     else
                                     {
                                         
                                        [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                        
                                         
                                     }
                                 }

                             }
                            failure:^(NSString *errMsg)
                             {
                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试!"];
                                 
                             }];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在提交..." completeBlock:^(NSArray *operations) {
    }];
    
}

- (NSString *)getNodStrWithDict:(NSDictionary*)dic andKey:(NSString*)key
{
    
    NSString *value = dic[key];
    //将中文字段用url编码
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)value, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
//    CFShow((CFStringRef)value);

    return [NSString stringWithFormat:@"<%@><![CDATA[%@]]></%@>",key,encodedValue,key] ;
}

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
                                                 
                                                 if (listArr.count!=0)
                                                 {
                                                     UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuzibeijing"]];
                                                     numImg.frame = CGRectMake(245, 0, 15, 15);
                                                     [scrollSelectView addSubview:numImg];
                                                     
                                                     UILabel *label  = [[UILabel alloc]init];
                                                     label.frame = CGRectMake(248, 0, 15, 15);
                                                     label.backgroundColor = [UIColor clearColor];
                                                     label.font = [UIFont systemFontOfSize:13];
                                                     label.textColor = [UIColor redColor];
                                                     label.text = [NSString stringWithFormat:@"%d",listArr.count];
                                                     [scrollSelectView addSubview:label];

                                                 }
                                                 
                                                 
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:nil completeBlock:^(NSArray *operations) {
    }];
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (Alert_Tag_Back==alertView.tag&&buttonIndex!=alertView.cancelButtonIndex)
    {
        [self saveFormWithType:@"2"];
    }
    else if(Alert_Tag_Cancel == alertView.tag&&buttonIndex!=alertView.cancelButtonIndex)
    {
         [self saveFormWithType:@"3"];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    @try {
        NSArray *fields = self.resultDict[@"Fields"];
        NSMutableDictionary *dict = fields[self.currentEditIndex][@"Field"];
        
        if (actionSheet.tag==200) //常用意见选择
        {
            if (buttonIndex!=0)
            {
                
                [dict setObject:self.resultDict[@"CYYJ"][buttonIndex-1] forKey:@"Value"];
                
                [self.listTableView reloadData];
            }
        }
        else if(actionSheet.tag == 100) //兼职部门
        {
            NSDictionary *temDict = self.resultDict[@"Parttimes"][buttonIndex-1];
            [dict setObject:temDict[@"DeptName"] forKey:@"ParttimeDept"];
            [dict setObject:temDict[@"PostName"] forKey:@"ParttimePost"];
            [self.listTableView reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"有可能是取消按纽导致的BUG，可忽略。。。");
    }
   
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
            ![view isKindOfClass:[UITableView class]]&&![view isKindOfClass:[UIToolbar class]])
        {
            [view removeFromSuperview];
        }
    }
    
    self.listTableView.hidden = YES;
//    self.toolBar.hidden = YES;
    
    if (num==0) //表单
    {
        self.listTableView.hidden = NO;
        self.toolBar.hidden = NO;
        
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    else if(num==1) //正文
    {
    
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
        if (contentViewController!=nil)
        {
            contentViewController.view.frame = self.listTableView.frame;
            [self.view addSubview:contentViewController.view];
        }
        else
        {
            [self getContentUrl];
        }
        
        
    }
    else if(num==2) //附件
    {
        NSLog(@"##################################################");
        attchmentListController = [[AttachmentListViewController alloc]initWithNibName:@"AttachmentListViewController" bundle:nil];
        attchmentListController.infoId = self.infoId;
        attchmentListController.view.frame = self.listTableView.frame;
        attchmentListController.fatherController = self;
        [self.view addSubview:attchmentListController.view];
        
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;

    }
    else if(num==3) //从表
    {
//        flowPathController = [[FlowPathViewController alloc]initWithNibName:@"FlowPathViewController" bundle:nil];
//        flowPathController.view.frame = self.listTableView.frame;
//        [self.view addSubview:flowPathController.view];
        subTableController = [[SubTableViewController alloc]initWithNibName:@"SubTableViewController" bundle:nil];
        subTableController.infoId = self.infoId;
        subTableController.sType = self.sType;
        subTableController.view.frame = self.listTableView.frame;
        [self.view addSubview:subTableController.view];
        
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;

    }
    else if(num == 4) //关联流程
    {
        relationTableController = [[RelationTableViewController alloc]initWithNibName:@"RelationTableViewController" bundle:nil];
        relationTableController.infoId = self.infoId;
        relationTableController.fatherController  = self;
        relationTableController.view.frame = self.listTableView.frame;
        [self.view addSubview:relationTableController.view];
        
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;

    }
}

#pragma mark-
#pragma mark--UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
 
    if (textView.tag<200) //正常项输入
    {
        self.currentEditIndex  = textView.tag-100;
        
        
//        UITableViewCell *cell;
//        if (IOS7_OR_LATER)
//        {
//            cell = (UITableViewCell*)[[[textView superview] superview] superview];
//        }
//        else
//        {
//            cell = (UITableViewCell*)[[textView superview] superview];
//        }
//        //    CGRect textViewFrame = [cell.contentView convertRect:textView.frame fromView:cell.contentView];
//        CGRect frame = [self.listTableView convertRect:cell.frame toView:self.listTableView];
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.listTableView.contentOffset = CGPointMake(0, frame.origin.y);
//        }];
        
        
        NSArray *fields = self.resultDict[@"Fields"];
        NSMutableDictionary *dict = fields[textView.tag-100][@"Field"];
        if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"8"]) //时间
        {
            [self showDatePickerWithType:UIDatePickerModeTime];
        }
        else if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"7"]|| //日期
                 [dict[@"LK_FLDDBTYPE"] isEqualToString:@"17"]) //年月
        {
            [self showDatePickerWithType:UIDatePickerModeDate];
        }
        else if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"9"]) //时间和日期
        {
            [self showDatePickerWithType:UIDatePickerModeDateAndTime];
        }
        //枚举值 处理模式是1,2时 是单选下拉框，要选中 节点Field/ Value对应的 Item/ Value
        else if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"6"])
        {
         
            NSMutableArray *options = dict[@"OPTIONS"];
            if (options!=0) //有子节点数据
            {
                SelectorViewController *selectorController = [[SelectorViewController alloc]initWithNibName:@"SelectorViewController" bundle:nil];
                selectorController.fileldDict = dict;
                selectorController.fatherController = self;
                selectorController.title = dict[@"LK_FIELDEDIT_TIPNAME"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectorController];
                
                if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                    [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
                }
                [self presentModalViewController:nav animated:YES];
            }
           
        }
        else if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"12"]|| //单选部门
                 [dict[@"LK_FLDDBTYPE"] isEqualToString:@"13"])  //多选部门
        {
            
            DepartmentSelectorViewController *departmentSelectorController = [[DepartmentSelectorViewController alloc]initWithNibName:@"DepartmentSelectorViewController" bundle:nil];
            departmentSelectorController.title = @"部门选择";
            departmentSelectorController.opetationData = dict;
            departmentSelectorController.fatherController = self;
            if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"13"])
            {
                departmentSelectorController.isMutSelect = YES;
            }
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:departmentSelectorController];
            
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
            }
            [self presentModalViewController:nav animated:YES];
        }
        else if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"10"]|| //单选人员
                 [dict[@"LK_FLDDBTYPE"] isEqualToString:@"11"])  //多选人员
        {
            
            
            NSString *value = dict[@"Value"];
        
            PeopleSelectViewController *peopleSelectController = [[PeopleSelectViewController alloc]initWithNibName:@"PeopleSelectViewController" bundle:nil];
            peopleSelectController.fatherController = self;
            peopleSelectController.operationData = dict;
            
            if (![StaticTools isEmptyString:value])
            {
                peopleSelectController.selectId = [NSMutableArray arrayWithArray:[value componentsSeparatedByString:@","]];
            }
            else
            {
                peopleSelectController.selectId = [[NSMutableArray alloc]init];
            }
            
            
            if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"10"]) //单选人员
            {
                peopleSelectController.isMutSelect = NO;
                
            }
            else  //多选人员
            {
               
                peopleSelectController.isMutSelect = YES;
            }
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:peopleSelectController];
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
                [nav.navigationBar setBackgroundImage:IOS7_OR_LATER?[UIImage imageNamed:@"daohangtiao"]:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
            }
            
            [self presentModalViewController:nav animated:YES];
            
        }
        

    }
    else if(textView.tag>=200) //历史意见下面的输入框
    {
        self.currentEditIndex  = textView.tag-200;
        
//        UITableViewCell *cell;
//        if (IOS7_OR_LATER)
//        {
//            cell = (UITableViewCell*)[[[textView superview] superview] superview];
//        }
//        else
//        {
//            cell = (UITableViewCell*)[[textView superview] superview];
//        }
//       
//        UITextView *historyTxtView = (UITextView*)[cell.contentView viewWithTag:textView.tag-100];
//        CGRect frame = [self.listTableView convertRect:cell.frame toView:self.listTableView];
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.listTableView.contentOffset = CGPointMake(0, frame.origin.y+historyTxtView.frame.size.height+30);
//        }];
        
    }
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSArray *fields = self.resultDict[@"Fields"];
    NSMutableDictionary *dict = fields[self.currentEditIndex][@"Field"];
    if (textView.tag<200) //正常项输入
    {
         [dict setObject:textView.text forKey:@"SHOWCONTENT"];
         [dict setObject:textView.text forKey:@"Value"];
    }
    else if(textView.tag>=200) //历史意见下面的输入框
    {
         [dict setObject:textView.text forKey:@"Value"];
    }
   
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
   
}

#pragma mark-
#pragma mark--UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==self.listTableView)
    {
        [self.view endEditing:YES];
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
    NSArray *fields = self.resultDict[@"Fields"];
    return fields.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *fields = self.resultDict[@"Fields"];
    NSDictionary *dict = fields[indexPath.row][@"Field"];
    
    float witdth = indexPath.row==0?0:100;
    float height = [StaticTools getLabelHeight:dict[@"SHOWCONTENT"] defautWidth:320-witdth-5 defautHeight:4800 fontSize:15];
    height=height<50?50:height+10;
    height=height>400?400:height;
    
    //5=意见 处理模式是1,2时，先展示showcontent的历史值，再出现文本框，然后把Value节点的值放进去
    if ([dict[@"LK_FLDDBTYPE"] isEqualToString:@"5"]&&([dict[@"LK_FIELDEDITMODE"] isEqualToString:@"1"]|| [dict[@"LK_FIELDEDITMODE"] isEqualToString:@"2"]))
    {
        if ([StaticTools isEmptyString:dict[@"SHOWCONTENT"]]) //历史意见为空
        {
            return height+95+80;
        }
        return height+95+80;
    }
    else
    {
        return height;
    }
    
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
    
    NSArray *fields = self.resultDict[@"Fields"];

    NSDictionary *field = fields[indexPath.row][@"Field"];
    
    //标题
    float titleheight = [StaticTools getLabelHeight:field[@"LK_FIELDEDIT_TIPNAME"] defautWidth:100 defautHeight:480 fontSize:16];
    titleheight=titleheight<45?45:titleheight+5;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 100, titleheight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.font = kLevelOneFont;
    titleLabel.text = field[@"LK_FIELDEDIT_TIPNAME"];
    [cell.contentView addSubview:titleLabel];
    
    
    float witdth = indexPath.row==0?0:100;
    //内容
    float height = [StaticTools getLabelHeight:field[@"SHOWCONTENT"] defautWidth:320-witdth-5 defautHeight:4800 fontSize:15];
    
    height=height<45?45:height+5;
    height=height>400?400:height;
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(witdth+3,3, 320-witdth-5, height)];
    detailTextView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:detailTextView];
    detailTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    detailTextView.tag = 100+indexPath.row;
    detailTextView.font = [UIFont systemFontOfSize:15];
    detailTextView.delegate = self;
    detailTextView.text = field[@"SHOWCONTENT"];
    if (indexPath.row==0)
    {
        detailTextView.textAlignment = UITextAlignmentCenter;
    }
    else
    {
        detailTextView.textAlignment = UITextAlignmentLeft;
    }
    
    
    if ([field[@"LK_FIELDEDITMODE"] isEqualToString:@"0"]) //显示只读
    {
        detailTextView.editable = NO;
    }
    else if ([field[@"LK_FIELDEDITMODE"] isEqualToString:@"1"]) //可更新
    {
        detailTextView.layer.borderWidth = 0.5;
        detailTextView.font = [UIFont systemFontOfSize:15];
    }
    else if ([field[@"LK_FIELDEDITMODE"] isEqualToString:@"2"]) //必填
    {
        detailTextView.layer.borderWidth = 0.5;
        detailTextView.font = [UIFont systemFontOfSize:15];
    }
    else if ([field[@"LK_FIELDEDITMODE"] isEqualToString:@"4"]) //显示只读
    {
        
        detailTextView.editable = NO;
    }
    
    //5=意见 处理模式是1,2时，先展示showcontent的历史值，再出现文本框，然后把Value节点的值放进去
    if ([field[@"LK_FLDDBTYPE"] isEqualToString:@"5"]&&([field[@"LK_FIELDEDITMODE"] isEqualToString:@"1"]|| [field[@"LK_FIELDEDITMODE"] isEqualToString:@"2"]))
    {
        if ( [StaticTools isEmptyString:field[@"SHOWCONTENT"]]) //历史意见为空
        {
            
            detailTextView.hidden = YES;
            height=0;
        }
        
        UITextView *inputTxtView = [[UITextView alloc]initWithFrame:CGRectMake(5, 35+height, 300, 60)];
        [cell.contentView addSubview:inputTxtView];
        inputTxtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        inputTxtView.layer.borderWidth = 0.5;
        inputTxtView.tag = 200+indexPath.row;
        inputTxtView.delegate = self;
        inputTxtView.font = [UIFont systemFontOfSize:15];
        inputTxtView.text = field[@"Value"];
        
        detailTextView.editable = NO;
        detailTextView.layer.borderColor = [UIColor clearColor].CGColor;
        
        UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actBtn.frame = CGRectMake(293, 23+height, 25, 25);
        [actBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        actBtn.tag = indexPath.row+100;
        [actBtn addTarget:self action:@selector(commonAdviceClick2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:actBtn];
        
        UITextView *partTxtView = [[UITextView alloc]initWithFrame:CGRectMake(5, 35+height+70+5, 300, 60)];
        [cell.contentView addSubview:partTxtView];
        partTxtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        partTxtView.layer.borderWidth = 0.5;
        partTxtView.tag = 200+indexPath.row;
        partTxtView.delegate = self;
        partTxtView.font = [UIFont systemFontOfSize:15];
        partTxtView.text = [NSString stringWithFormat:@"%@ %@",field[@"ParttimeDept"],field[@"ParttimePost"]];
        
        detailTextView.editable = NO;
        detailTextView.layer.borderColor = [UIColor clearColor].CGColor;
        
        UIButton *partBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        partBtn.frame = CGRectMake(293, 23+height+70+5, 25, 25);
        [partBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        partBtn.tag = indexPath.row+200;
        [partBtn addTarget:self action:@selector(commonAdviceClick1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:partBtn];
        
    }
    
    return cell;
    
}

@end
