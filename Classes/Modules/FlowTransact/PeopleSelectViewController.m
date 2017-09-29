//
//  PeopleSelectViewController.m
//  Desea
//
//  Created by wenbin on 14-2-28.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "PeopleSelectViewController.h"
#import "ContactsModel.h"
#import "pinyin.h"
#import "FlowHandleSecViewController.h"
#import "FlowHandleViewController.h"
#import "PersonalManageViewController.h"

@interface PeopleSelectViewController ()

@end

@implementation PeopleSelectViewController

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
    self.contactsArr = [[NSMutableArray alloc]init];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    if (ShareManager.addressArr.count==0)
    {
        [self getAddressList];
    }
    else
    {
        self.addressArr = ShareManager.addressArr;
        [self sortWithName];
        [self.listTableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark 功能函数
/**
 *  按姓名排序
 */
- (void)sortWithName
{
    NSMutableArray *chineseStringsArray = [NSMutableArray arrayWithArray:self.addressArr];
    
    [self.contactsArr removeAllObjects];
    self.selectPeople = [NSMutableArray arrayWithCapacity:0];
    
   
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"chinseStrOfName" ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    for (ContactsModel *contact in chineseStringsArray)
    {
        
        BOOL has = NO;
        for (NSString *idStr in self.selectId)
        {
            if([contact.usrId isEqualToString:idStr])
            {
                [self.selectPeople addObject:contact];
                has = YES;
                break;
            }
        }
        if (has)
        {
            
            continue;
        }
    }
    [chineseStringsArray removeObjectsInArray:self.selectPeople];
    
    
    //将string按首字母进行分割  保存至相应数组
    int j=0;
    int i=0;
    //子部门联系人页面里数组里没有首字母项
    int max = chineseStringsArray.count-1;
    
    for (i=0; i<max; i++)
    {
        
        ContactsModel *contact = [chineseStringsArray objectAtIndex:i];
        
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:0];
        
        //不是字母开头的加到一个数组里 并且将该分类首字母作为该数组第一个元素加入 方便后面使用
        if ([ALPHA rangeOfString:[contact.chinseStrOfName substringToIndex:1]].length==0)
        {
            [temArr addObject:@"#"];
        }
        else
        {
            [temArr addObject:[contact.chinseStrOfName substringToIndex:1]];
        }
        
        [temArr addObject:contact];
        for (j = i+1; j<chineseStringsArray.count; j++)
        {  //从当前元素向后遍历 寻找首字母一样的元素 加入同一数组里
            
            ContactsModel *pcontact = [chineseStringsArray objectAtIndex:j];
            
            
            if ([ALPHA rangeOfString:[contact.chinseStrOfName substringToIndex:1]].length==0)
            {  //数字开头的加到一个数组里
                
                if ([ALPHA rangeOfString:[pcontact.chinseStrOfName substringToIndex:1]].length==0)
                {
                    
                    [temArr addObject:pcontact];
                    
                }
                else
                {
                    
                    break;
                }
            }
            else
            {
                if ([[contact.chinseStrOfName substringToIndex:1] isEqualToString: [pcontact.chinseStrOfName substringToIndex:1]] )
                {
                    
                    [temArr addObject:pcontact];
                    
                }
                else
                {
                    break;
                }
            }
        }
        
        i=j-1;
        [self.contactsArr addObject:temArr];
        
        //把#号标志的元素放最后
        if ([[[self.contactsArr objectAtIndex:0] objectAtIndex:0] isEqualToString:@"#"])
        {
            [self.contactsArr addObject:[self.contactsArr objectAtIndex:0]];
            [self.contactsArr removeObjectAtIndex:0];
        }
        
    }
}

- (NSString*)getContactNameWithID:(NSString*)idStr
{
    for (ContactsModel *contact in ShareManager.addressArr)
    {
        if ([contact.usrId isEqualToString:idStr])
        {
            return contact.name;
        }
    }
    
    return Nil;
}

- (NSString*)getContactDepartmentWithID:(NSString*)idStr
{
    for (ContactsModel *contact in ShareManager.addressArr)
    {
        if ([contact.usrId isEqualToString:idStr])
        {
            return contact.departMent;
        }
    }
    
    return Nil;
}

#pragma mark
#pragma mark 按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    
    if ([self.fatherController isKindOfClass:[FlowHandleSecViewController class]])
    {
        FlowHandleSecViewController *flowHandleController = (FlowHandleSecViewController*)self.fatherController;
        if (self.selectId.count>0)
        {
            if (self.isMutSelect) //相关办理人
            {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (NSString *idstr in self.selectId)
                {
                    [arr addObject:[NSDictionary dictionaryWithObject:@{@"UserId":idstr,@"UserName":[self getContactNameWithID:idstr]} forKey:@"CYR"]];
                }
                
                 [flowHandleController.currentAct setObject:arr forKey:@"CYRs"];
            }
            else //主办人
            {
                [flowHandleController.currentAct[@"ZBR"] setObject:self.selectId[0] forKey:@"UserId"];
                [flowHandleController.currentAct[@"ZBR"] setObject:[self getContactNameWithID:self.selectId[0]] forKey:@"UserName"];
               
            }
        }
        
        [flowHandleController performSelector:@selector(refreshData) withObject:nil];
        
    }
    else if([self.fatherController isKindOfClass:[FlowHandleViewController class]])
    {
        FlowHandleViewController *flowHandleController = (FlowHandleViewController*)self.fatherController;
        if (self.selectId.count>0)
        {
            NSMutableString *value = [[NSMutableString alloc]init];
            NSMutableString *content = [[NSMutableString alloc]init];
            
            for (NSString *idstr in self.selectId)
            {
                [value appendString:[NSString stringWithFormat:@"%@,",idstr]];
                [content appendString:[NSString stringWithFormat:@"%@,",[self getContactNameWithID:idstr]]];
            }
            
            content = (NSMutableString*)[content substringToIndex:content.length-1];
            value = (NSMutableString*)[value substringToIndex:value.length-1];
      
            [self.operationData setValue:content forKey:@"SHOWCONTENT"];
            [self.operationData setValue:value forKey:@"Value"];
            
             [flowHandleController performSelector:@selector(refreshData) withObject:nil];
        }
    }
    else if([self.fatherController isKindOfClass:[PersonalManageViewController class]])
    {
        if (self.selectId.count>0)
        {
            PersonalManageViewController *personManageController = (PersonalManageViewController*)self.fatherController;
            ContactsModel *contact = [[ContactsModel alloc]init];
            contact.usrId = self.selectId[0];
            contact.name = [self getContactNameWithID:self.selectId[0]];
            contact.departMent = [self getContactDepartmentWithID:self.selectId[0]];
            
            personManageController.selectContact = contact;
        }
    
    }
    [self dismissModalViewControllerAnimated:YES];
    
    
}

#pragma mark-
#pragma mark--HTTP请求
- (void)getAddressList
{
    NSDictionary *dict = @{kMethodName:@"GetSysAddress_Book",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"sUserId":ShareManager.userId}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSArray class]])
                                             {
                                                 NSArray *array = (NSArray*)obj;
                                                 self.addressArr = [NSMutableArray arrayWithArray:array];
                                                 ShareManager.addressArr = [NSMutableArray arrayWithArray:array];
                                                 [self sortWithName];
                                                 
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
    return self.contactsArr.count+(self.selectPeople.count>0?1:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectPeople.count>0)
    {
        if (section==0)
        {
            return  self.selectPeople.count;
        }
        else
        {
              return [[self.contactsArr objectAtIndex:section-1] count]-1;
        }
        
    }
    return [[self.contactsArr objectAtIndex:section] count]-1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    NSMutableArray *indices = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 27; i++)
    {
        [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    }
    
    return indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    
    for (int i=0; i<self.contactsArr.count;i++)
    {
        NSString *str = [[self.contactsArr objectAtIndex:i] objectAtIndex:0];
        if ([title isEqualToString:str])
        {
            return self.selectPeople.count>0?i+1:i;
        }
    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    title.backgroundColor = RGBCOLOR(209, 218, 235);
    
    if (self.selectPeople.count>0)
    {
        if (section==0)
        {
            title.text = @"已选择";
        }
        else
        {
             title.text = [NSString stringWithFormat:@"  %@",[[self.contactsArr objectAtIndex:section-1] objectAtIndex:0]];
        }
        
    }
    else
    {
         title.text = [NSString stringWithFormat:@"  %@",[[self.contactsArr objectAtIndex:section] objectAtIndex:0]];
    }
   
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.font = kLevelOneFont;
    
    ContactsModel * contact;
    
    if (self.selectPeople.count>0)
    {
        if (indexPath.section==0)
        {
            contact = self.selectPeople[indexPath.row];
        }
        else
        {
            contact = [[self.contactsArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row+1];
        }
        
    }
    else
    {
        contact = [[self.contactsArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    }
    
    cell.textLabel.text = contact.name;
    
//    if ([ShareManager.selectPeople containsObject:contact])
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    
    BOOL has = NO;
    for (NSString *idstr in self.selectId)
    {
        if([idstr isEqualToString:contact.usrId])
        {
            has = YES;
        }
    }
    
    if (has)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

//定制tableview背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = RGBCOLOR(236, 236, 236);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ContactsModel *contact;
    
    if (self.selectPeople.count>0)
    {
        if (indexPath.section==0)
        {
            contact = [self.selectPeople objectAtIndex:indexPath.row];
        }
        else
        {
            contact = [[self.contactsArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row+1];
        }
    }
    else
    {
        contact = [[self.contactsArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    }
    

//    if ([ShareManager.selectPeople containsObject:contact])
//    {
//        [ShareManager.selectPeople removeObject:contact];
//    }
//    else
//    {
//        [ShareManager.selectPeople addObject:contact];
//    }
    
    if (self.isMutSelect)
    {
        BOOL has = NO;
        for (NSString *idstr in self.selectId)
        {
            if([idstr isEqualToString:contact.usrId])
            {
                has = YES;
                break;
            }
        }
        if (has)
        {
            for (NSString *idstr in self.selectId)
            {
                if([idstr isEqualToString:contact.usrId])
                {
                    [self.selectId removeObject:idstr];
                    break;
                }
            }
        }
        else
        {
            [self.selectId addObject:contact.usrId];
        }
    }
    else
    {
        [self.selectId removeAllObjects];
        [self.selectId addObject:contact.usrId];
    }
 
    
    [self.listTableView reloadData];

}


@end
