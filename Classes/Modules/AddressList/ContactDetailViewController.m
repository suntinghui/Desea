//
//  ContactDetailViewController.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "WriteEmailViewController.h"
#import "WriteMessageViewController.h"

#define Action_Tag_MakeTel     100 //办公电话
#define Action_Tag_MakePhone   101 //手机
#define Action_Tag_MakeMessage 102 //短信
#define Action_Tag_Email1      103 //邮件1
#define Action_Tag_Email2      104 //邮件2


@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController

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
    self.navigationItem.title = @"通讯录";
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_MakeTel: //打办公电话
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contact.telNum] ]];
        }
            break;
        case Action_Tag_MakePhone: //打手机
        {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contact.phoneNum]]];
        }
            break;
        case Action_Tag_MakeMessage: //发短信
        {
            WriteMessageViewController *writeMessageContrller = [[WriteMessageViewController alloc]initWithNibName:@"WriteMessageViewController" bundle:nil];
//            writeMessageContrller.recever = self.contact;
            ShareManager.selectPeople = [NSMutableArray arrayWithObject:self.contact];
            [writeMessageContrller performSelector:@selector(freshRecevePeople) withObject:nil afterDelay:0.5];
            [self.navigationController pushViewController:writeMessageContrller animated:YES];
        }
            break;
        case Action_Tag_Email1: //邮件1发邮件
        {
            WriteEmailViewController *writeEmailContrller = [[WriteEmailViewController alloc]initWithNibName:@"WriteEmailViewController" bundle:nil];
//            writeEmailContrller.reciver = self.contact.emailOne;
            ShareManager.selectPeople = [NSMutableArray arrayWithObject:self.contact];
            [writeEmailContrller performSelector:@selector(freshRecevePeople) withObject:nil afterDelay:0.5];

            [self.navigationController pushViewController:writeEmailContrller animated:YES];
        }
            break;
        case Action_Tag_Email2: //邮件2发邮件
        {
            WriteEmailViewController *writeEmailContrller = [[WriteEmailViewController alloc]initWithNibName:@"WriteEmailViewController" bundle:nil];
            writeEmailContrller.reciver = self.contact.emailTwo;
            [self.navigationController pushViewController:writeEmailContrller animated:YES];
        }
            break;
            
        default:
            break;
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0?100:70;
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
    
    //姓名
   UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 80, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = kLevelOneFont;
    [cell.contentView addSubview:nameLabel];
    
    //部门
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, 8, 180, 30)];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.textColor = [UIColor blueColor];
    positionLabel.font = [UIFont systemFontOfSize:11];
    positionLabel.textColor = RGBCOLOR(88, 129, 210);
    [cell.contentView addSubview:positionLabel];

    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textColor = [UIColor blueColor];
    phoneLabel.font = [UIFont systemFontOfSize:13];
    phoneLabel.textColor = RGBCOLOR(88, 129, 210);
    [cell.contentView addSubview:phoneLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 180, 30)];
    phoneNumLabel.backgroundColor = [UIColor clearColor];
    phoneNumLabel.font = kLevelOneFont;
    phoneNumLabel.text = @"123456";
    [cell.contentView addSubview:phoneNumLabel];
    
    //第一个操作按钮
    UIButton *operationOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operationOneBtn.frame = CGRectMake(230, 60, 20, 20);
    [cell.contentView addSubview:operationOneBtn];
    [operationOneBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    operationOneBtn.tag = indexPath.row+100;
    
    //第二个操作按钮
    UIButton *operationTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operationTwoBtn.frame = CGRectMake(270, 60, 20, 20);
    [operationTwoBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:operationTwoBtn];
    
    if (indexPath.row==0)
    {
        phoneLabel.text = @"办公电话";
        operationOneBtn.hidden = YES;
        nameLabel.text = self.contact.name;
        positionLabel.text = self.contact.departMent;
        phoneNumLabel.text = self.contact.telNum;
        operationTwoBtn.tag = Action_Tag_MakeTel;
        operationTwoBtn.hidden = [StaticTools isEmptyString:self.contact.telNum];
        [operationOneBtn setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        
        nameLabel.frame = CGRectMake(10, 10, [StaticTools getLabelWidth:self.contact.name defautWidth:300 defautHeight:30 fontSize:15], 30);
        positionLabel.frame = CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, 15, 300-nameLabel.frame.size.width, 30);
        
    }
    else
    {
        nameLabel.hidden = YES;
        positionLabel.hidden = YES;
        if (indexPath.row!=1)
        {
            operationOneBtn.hidden = YES;
        }
        
        
        phoneLabel.frame = CGRectMake(10, 7, 80, 30);
        phoneNumLabel.frame = CGRectMake(10, 30, 180, 30);
        operationOneBtn.frame = CGRectMake(230, 40, 20, 20);
        operationTwoBtn.frame = CGRectMake(270, 40, 20, 20);
        
        if (indexPath.row==1)
        {
            phoneNumLabel.text = self.contact.phoneNum;
            phoneLabel.text = @"移动电话";
            operationTwoBtn.tag = Action_Tag_MakePhone;
            operationOneBtn.tag = Action_Tag_MakeMessage;
            operationTwoBtn.hidden = [StaticTools isEmptyString:self.contact.phoneNum];
            operationOneBtn.hidden = [StaticTools isEmptyString:self.contact.phoneNum];
            
            [operationOneBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            [operationTwoBtn setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];

        }
        else if(indexPath.row==2)
        {
            phoneNumLabel.text = self.contact.emailOne;
            phoneLabel.text = @"Email1";
            operationTwoBtn.tag = Action_Tag_Email1;
            operationTwoBtn.hidden = [StaticTools isEmptyString:self.contact.emailOne];
            
             [operationTwoBtn setBackgroundImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
        }
        else if(indexPath.row==3)
        {
            phoneNumLabel.text = self.contact.emailTwo;
            phoneLabel.text = @"Email2";
            operationTwoBtn.tag = Action_Tag_Email2;
            operationTwoBtn.hidden = [StaticTools isEmptyString:self.contact.emailTwo];
            
             [operationTwoBtn setBackgroundImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
        }
    }
    
    
    return cell;
}

@end
