//
//  EmailDetailViewController.h
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：邮件详情页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface EmailDetailViewController : BaseViewController<UITableViewDelegate,
    UITableViewDataSource,
    UITextViewDelegate,
    UIWebViewDelegate,
    UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *emailId; //邮件id 列表页传过来
@property (strong, nonatomic) NSString *emailInId; //接收邮件序号
@property (strong, nonatomic) NSDictionary *resultDict;
@property (strong, nonatomic) NSString *people; //发件人
@property (strong, nonatomic) NSString *theme;  //主题
@property (strong, nonatomic) NSString *content; //内容
@property (assign, nonatomic) UIViewController *fatherController;
@property (assign, nonatomic) int type; //邮件类型  前一个页面传过来

- (IBAction)buttonClickHandle:(id)sender;

@end
