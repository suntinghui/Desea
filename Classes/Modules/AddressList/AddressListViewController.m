//
//  AddressListViewController.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "AddressListViewController.h"
#import "ContactsModel.h"
#import "pinyin.h"
#import "ContactDetailViewController.h"

#define Action_Tag_SelectAll   100
#define Action_Tag_Commit      101

@interface AddressListViewController ()
{
    int sortWay;  //0:按姓名排序  1：按部门排序
}
@end

@implementation AddressListViewController

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
    if ([StaticTools isEmptyString:self.department])
    {
         self.navigationItem.title = @"通讯录";
    }
    else
    {
         self.navigationItem.title = self.department;
    }
   
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    self.contactsArr = [NSMutableArray arrayWithCapacity:0];
    self.departmentArr = [NSMutableArray arrayWithCapacity:0];
  
    if (self.pageType==0)
    {
        ScrollSelectView *scrollSelectView  = [[ScrollSelectView alloc]initWithFrame:CGRectMake(0, 0, 320, 30) titles:@[@"按姓名排序",@"按部门排序"]];
        scrollSelectView.delegate = self;
        [self.view addSubview:scrollSelectView];
        
        self.addressArr = [NSMutableArray arrayWithCapacity:0];
        
        
    }
    else //子部门联系人页面
    {
        self.listTableView.frame = self.view.frame;
        [self sortWithName];
        [self.listTableView reloadData];
        
    }
    
    //点击通讯录进入时 重新获取通讯录数据  从写邮件选择联系人或写短信选择联系人进入时 若有缓存数据 使用缓存 否则重新请求
    if (self.isSelectContace)
    {
       
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(250, 2, 90, 40)];
        rightView.backgroundColor = [UIColor clearColor];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
        [saveBtn setTitle:@"全选" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        saveBtn.frame = CGRectMake(0, 3, 40, 30);
        saveBtn.tag = Action_Tag_SelectAll;
        [saveBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:saveBtn];
        
        UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
        [operationBtn setTitle:@"完成" forState:UIControlStateNormal];
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        operationBtn.frame = CGRectMake(45, 3, 40, 30);
        operationBtn.tag = Action_Tag_Commit;
        [operationBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:operationBtn];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        
        if (ShareManager.addressArr.count!=0)
        {
            self.selectContactArr = [NSMutableArray arrayWithArray:ShareManager.selectPeople];
            self.selectDepArr = [NSMutableArray arrayWithArray:ShareManager.selectDepartment];
            self.addressArr = ShareManager.addressArr;
            [self sortWithName];
            [self sortWithDepartment];
            sortWay = 0;
            
            [self.listTableView reloadData];
        }
        else
        {
            [self getAddressList];
        }
        
    }
    else
    {
        if (self.pageType!=1)
        {
               [self getAddressList];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark  功能函数
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.isSelectContace) //选择联系人时  点击返回按钮  要取消其选择的联系人
    {
        ShareManager.selectPeople = [NSMutableArray arrayWithArray:self.selectContactArr];
        ShareManager.selectDepartment = [NSMutableArray arrayWithArray:self.selectDepArr];
    }
}
/**
 *  按姓名排序
 */
- (void)sortWithName
{
    NSMutableArray *chineseStringsArray = [NSMutableArray arrayWithArray:self.addressArr];
    [self.contactsArr removeAllObjects];
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"chinseStrOfName" ascending:YES]];
 
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    [chineseStringsArray removeObjectsInArray:self.selectContactArr];
    
    //将string按首字母进行分割  保存至相应数组
    int j=0;
    int i=0;
    //子部门联系人页面里数组里没有首字母项
    int max = self.pageType==0?chineseStringsArray.count-1:chineseStringsArray.count;
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

/**
 *  按部门排序
 */
- (void)sortWithDepartment
{
    NSMutableArray *chineseStringsArray = [NSMutableArray arrayWithArray:self.addressArr];
  
    NSMutableArray *deArr = [NSMutableArray arrayWithCapacity:0];
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"chinseStrOfDepartment" ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptor];
    
    //将string按首字母进行分割  保存至相应数组
    int j=0;
    int i=0;
    for (i=0; i<chineseStringsArray.count-1; i++)
    {
        ContactsModel *contact = [chineseStringsArray objectAtIndex:i];
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:0];
        
        //没有部门信息的加到一个数组里
        if ([StaticTools isEmptyString:contact.departMent])
        {
            NSLog(@"wubumen %@",contact.name);
            [temArr addObject:@"#"];
        }
        else
        {
            [temArr addObject:[contact.chinseStrOfDepartment substringToIndex:1]];
        }
        
        [temArr addObject:contact];
        //从当前元素向后遍历 寻找部门一样的元素 加入同一数组里
        for (j = i+1; j<chineseStringsArray.count; j++)
        {
            ContactsModel *pcontact = [chineseStringsArray objectAtIndex:j];
            if ([StaticTools isEmptyString:pcontact.departMent])
            {  //没有部门信息的加到一个数组里
                [temArr addObject:pcontact];
                break;
            }
            else
            {
                if ([contact.departMent isEqualToString: pcontact.departMent] )
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
        [deArr addObject:temArr];
    }
    
    NSMutableArray *temArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSArray *arr in deArr) //过滤掉已经选择的部门
    {
        ContactsModel *contact = arr[1];
        for (NSArray *arrtem in self.selectDepArr)
        {
            
            ContactsModel *contacttem = arrtem[0];
            if ([contact.departMent isEqualToString:contacttem.departMent])
            {
                [temArr addObject:arr];
                break;
            }

        }
    }
    [deArr removeObjectsInArray:temArr];
    
    //将数据按首字母相同的进行合并  保存至相应数组
    int k=0;
    int g=0;
    for (g=0; g<deArr.count-1; g++)
    {
        
        NSString *key = deArr[g][0];
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:0];
        
        [temArr addObject:key];
        [deArr[g] removeObjectAtIndex:0];
        [temArr addObject:deArr[g]];
        //从当前元素向后遍历 寻找部门一样的数组 加入同一数组里
        for (k = g+1; k<deArr.count; k++)
        {
            
            NSString *pkey = deArr[k][0];
            
            if ([key isEqualToString: pkey] )
            {
                [deArr[k] removeObjectAtIndex:0];
                [temArr addObject:deArr[k]];
            }
            else
            {
                break;
            }
        }
        
        g=k-1;
        
       
        [self.departmentArr addObject:temArr];
        
    }
    
    //把#号标志的元素放最后
    if ([[[self.departmentArr objectAtIndex:0] objectAtIndex:0] isEqualToString:@"#"])
    {
        [self.departmentArr addObject:[self.departmentArr objectAtIndex:0]];
        [self.departmentArr removeObjectAtIndex:0];
    }
    NSLog(@"departmentArr %@",self.departmentArr);
    
}


#pragma mark
#pragma mark 按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (Action_Tag_Commit==button.tag)
    {
        if ([self.fatherController respondsToSelector:@selector(freshRecevePeople)])
        {
            [self.fatherController performSelector:@selector(freshRecevePeople) withObject:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button.tag ==Action_Tag_SelectAll)
    {
        if (sortWay ==0) //按姓名排序
        {
            //全选状态
            if (ShareManager.selectPeople.count == self.addressArr.count)
            {
                [ShareManager.selectPeople removeAllObjects];
            }
            else
            {
                [ShareManager.selectPeople removeAllObjects];
                for (NSArray *arr in self.contactsArr)
                {
                    for (int i=1; i<arr.count; i++)
                    {
                        [ShareManager.selectPeople addObject:arr[i]];
                    }
                }
            }
            
        }
        else
        {
            int count = 0;
            for (NSArray *arr in self.departmentArr)
            {
                count+=(arr.count-1);
            }
            
            //全选状态
            if (ShareManager.selectDepartment.count == count)
            {
                [ShareManager.selectDepartment removeAllObjects];
            }
            else
            {
                [ShareManager.selectDepartment removeAllObjects];
                for (NSArray *arr in self.departmentArr)
                {
                    for (int i=1; i<arr.count; i++)
                    {
                        [ShareManager.selectDepartment addObject:arr[i]];
                    }
                }
            }
        }
        
        [self.listTableView reloadData];
    }
    
}

#pragma mark-
#pragma mark--SrollSelectViewDelegate
- (void)ScrollSelectDidCickWith:(int)num
{
    if (num==0) //按姓名排序
    {
        sortWay = 0;
    }
    else //按部门排序
    {
        sortWay = 1;
    }
    
    [self.listTableView reloadData];
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
                                     [self sortWithDepartment];
                                     sortWay = 0;
                                    
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
    if (sortWay==0)
    {
        return self.contactsArr.count+(self.selectContactArr.count>0?1:0);
    }
    else if(sortWay==1)
    {
        return self.departmentArr.count+(self.selectDepArr.count>0?1:0);
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sortWay==0)
    {
        if (self.selectContactArr.count>0)
        {
            if (section==0)
            {
                return self.selectContactArr.count;
            }
            else
            {
                return [[self.contactsArr objectAtIndex:section-1] count]-1;
            }
        }
        else
        {
            return [[self.contactsArr objectAtIndex:section] count]-1;
        }
        
 
    }
    else if(sortWay == 1)
    {
        if (self.selectDepArr.count>0)
        {
            if (section==0)
            {
                return self.selectDepArr.count;
            }
            else
            {
                return [[self.departmentArr objectAtIndex:section-1] count]-1;
            }
        }
        else
        {
            return [[self.departmentArr objectAtIndex:section] count]-1;
        }
        
    }
    
    return 0;
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
    
    if (sortWay==0)
    {
        for (int i=0; i<self.contactsArr.count;i++)
        {
            NSString *str = [[self.contactsArr objectAtIndex:i] objectAtIndex:0];
            if ([title isEqualToString:str])
            {
                return i+(self.selectContactArr.count>0?1:0);
            }
        }
    }
    else if(sortWay==1)
    {
        for (int i=0; i<self.departmentArr.count;i++)
        {
            NSString *str = [[self.departmentArr objectAtIndex:i] objectAtIndex:0];
            if ([title isEqualToString:str])
            {
                return i+(self.selectDepArr.count>0?1:0);
            }
        }
    }
    
    
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    title.backgroundColor = RGBCOLOR(209, 218, 235);
    if (sortWay==0)
    {
        if (self.selectContactArr.count>0)
        {
            if (section==0)
            {
                title.text = @"已选择人员";
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
        
    }
    else if(sortWay==1)
    {
        if (self.selectDepArr.count>0)
        {
            if (section==0)
            {
              title.text = @"已选择部门";
            }
            else
            {
                 title.text = [NSString stringWithFormat:@"  %@",[[self.departmentArr objectAtIndex:section-1] objectAtIndex:0]];
            }
        }
        else
        {
           title.text = [NSString stringWithFormat:@"  %@",[[self.departmentArr objectAtIndex:section] objectAtIndex:0]];
        }
        
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
    
    if (sortWay==0)
    {
        ContactsModel *contact ;
        
        if (self.selectContactArr.count>0)
        {
            if (indexPath.section==0)
            {
                contact = self.selectContactArr[indexPath.row];
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
        
        if ([ShareManager.selectPeople containsObject:contact])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if(sortWay==1)
    {
        NSArray *arr;
        if (self.selectDepArr.count>0)
        {
            if (indexPath.section==0)
            {
                arr = [self.selectDepArr objectAtIndex:indexPath.row];
            }
            else
            {
                arr = [[self.departmentArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row+1];
            }
        }
        else
        {
            arr = [[self.departmentArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
        }
        
        ContactsModel * contact = arr[0];
        
        if ([StaticTools isEmptyString:contact.departMent]) //没有部门信息的放在在一起
        {
            cell.textLabel.text = @"其他";
        }
        else
        {
            cell.textLabel.text = contact.departMent;
        }
        
       
        
        if ([ShareManager.selectDepartment containsObject:arr])
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
    cell.backgroundColor = RGBCOLOR(236, 236, 236);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (sortWay==0) //按姓名排序
    {
        ContactsModel *contact ;
        
        if (self.selectContactArr.count>0)
        {
            if (indexPath.section==0)
            {
                contact = self.selectContactArr[indexPath.row];
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
        
        if (self.isSelectContace) //联系人选择模式 将选择的联系人保存至单例里
        {
            if ([ShareManager.selectPeople containsObject:contact])
            {
                [ShareManager.selectPeople removeObject:contact];
            }
            else
            {
                [ShareManager.selectPeople addObject:contact];
            }
            [self.listTableView reloadData];
        }
        else //进入联系人详情
        {
            ContactDetailViewController *contactDetailController = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
            contactDetailController.contact = self.contactsArr[indexPath.section][indexPath.row+1];
            [self.navigationController pushViewController:contactDetailController animated:YES];
        }
    }
    else if(sortWay == 1) //按部门排序
    {
         NSArray *arr ;
        if(self.selectDepArr.count>0)
        {
            if (indexPath.section==0)
            {
                arr = [self.selectDepArr objectAtIndex:indexPath.row];
            }
            else
            {
                arr = [[self.departmentArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row+1];
            }
        }
        else
        {
            arr = [[self.departmentArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
        }
        
        if (self.isSelectContace) //联系人选择模式 选择整个部门的联系人
        {
            if ([ShareManager.selectDepartment containsObject:arr])
            {
                [ShareManager.selectDepartment removeObject:arr];
            }
            else
            {
                [ShareManager.selectDepartment addObject:arr];
            }
            [self.listTableView reloadData];
        }
        else //查看某个部门里的联系人
        {
           
           ContactsModel *contact = [[self.departmentArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1][0];
            AddressListViewController *addressListController = [[AddressListViewController alloc]initWithNibName:@"AddressListViewController" bundle:nil];
            addressListController.department = contact.departMent;
            addressListController.pageType = 1;
            addressListController.addressArr = [NSMutableArray arrayWithArray:arr];
            [self.navigationController pushViewController:addressListController animated:YES];

        }
        
    }

  
}
@end
