//
//  DepartmentSelectorViewController.m
//  Desea
//
//  Created by wenbin on 14-2-28.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "DepartmentSelectorViewController.h"

@interface DepartmentSelectorViewController ()

@end

@implementation DepartmentSelectorViewController

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
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_l"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
    
    if (self.pageType==0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        if (ShareManager.departmentArr.count==0)
        {
            [self getDepartmentInfo];
        }
        else
        {
            self.departments = ShareManager.departmentArr;
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.listTableView reloadData];
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
    if (self.isMutSelect)
    {
        if ( ShareManager.selectDepartment.count>0)
        {
            NSMutableString *idStr = [[NSMutableString alloc]init];
            NSMutableString *nameStr = [[NSMutableString alloc]init];
            for (NSDictionary *dict in ShareManager.selectDepartment)
            {
                [idStr appendString:[NSString stringWithFormat:@"%@,",dict[@"DeptId"]]];
                [nameStr appendString:[NSString stringWithFormat:@"%@,",dict[@"DeptName"]]];
                
            }
            [self.opetationData setObject:[nameStr substringToIndex:nameStr.length-1] forKey:@"SHOWCONTENT"];
            [self.opetationData setObject:[idStr substringToIndex:idStr.length-1] forKey:@"Value"];
        }
        
    }
    
    
    if ([self.fatherController respondsToSelector:@selector(refreshData)])
    {
        [self.fatherController performSelector:@selector(refreshData) withObject:nil];
    }

    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark
#pragma mark http请求

/**
 *  获取部门列表
 */
- (void)getDepartmentInfo
{
    NSDictionary *dict = @{kMethodName:@"GetDept",
                           kWebServiceName:@"WebService.asmx"};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
//                                                 ShareManager.departmentArr = [NSMutableArray arrayWithArray:obj];
//                                                 self.departments = [NSArray arrayWithArray:obj];
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

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.pageType==0? self.resultDict[@"Infors"]:self.resultDict[@"Infors"][@"Infors"];
    return arr.count;
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
    
    NSArray *arr = self.pageType==0? self.resultDict[@"Infors"]:self.resultDict[@"Infors"][@"Infors"];
    
    NSDictionary *dict = arr[indexPath.row];
    cell.textLabel.text = dict[@"DeptName"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if ([dict[@"Infors"] isKindOfClass:[NSDictionary class]])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        
        
        if (!self.isMutSelect)
        {
            if ([self.opetationData[@"SHOWCONTENT"] isEqualToString:dict[@"DeptName"]])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            if([ShareManager.selectDepartment containsObject:dict])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr= self.pageType==0? self.resultDict[@"Infors"]:self.resultDict[@"Infors"][@"Infors"];
    NSDictionary *dict = arr[indexPath.row];
    if ([dict[@"Infors"] isKindOfClass:[NSDictionary class]])
    {
        DepartmentSelectorViewController *departmentSelectController = [[DepartmentSelectorViewController alloc]initWithNibName:@"DepartmentSelectorViewController" bundle:nil];
        departmentSelectController.resultDict = dict;
        departmentSelectController.pageType=1;
        departmentSelectController.isMutSelect = self.isMutSelect;
        departmentSelectController.opetationData = self.opetationData;
        departmentSelectController.fatherController = self.fatherController;
        departmentSelectController.title =  dict[@"DeptName"];
        [self.navigationController pushViewController:departmentSelectController animated:YES];
    }
    else
    {
        if (self.isMutSelect)
        {
            if([ShareManager.selectDepartment containsObject:dict])
            {
                [ShareManager.selectDepartment removeObject:dict];
            }
            else
            {
                [ShareManager.selectDepartment addObject:dict];
            }
            [self.listTableView reloadData];
        }
        else
        {
            [self.opetationData setObject:dict[@"DeptName"] forKey:@"SHOWCONTENT"];
            [self.opetationData setObject:dict[@"DeptId"] forKey:@"Value"];
            
            [self.listTableView reloadData];
        }
    }
}
@end
