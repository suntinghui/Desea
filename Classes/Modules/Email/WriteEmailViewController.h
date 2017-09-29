//
//  WriteEmailViewController.h
//  Desea
//
//  Created by wenbin on 14-2-19.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：邮件编写页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface WriteEmailViewController : BaseViewController<UITextViewDelegate,
    UIScrollViewDelegate,
    UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrView;
@property (weak, nonatomic) IBOutlet UILabel *receveLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UITextView *receveTxtView;
@property (weak, nonatomic) IBOutlet UITextView *themeTxtView;
@property (weak, nonatomic) IBOutlet UITextView *contentTxtView;
@property (weak, nonatomic) IBOutlet UIImageView *lineOne;
@property (weak, nonatomic) IBOutlet UIImageView *lineTwo;
@property (strong, nonatomic) NSString *reciver;
@property (strong, nonatomic) NSMutableString *reciverId;
@property (assign, nonatomic) BOOL isFromCaoGao;  //是否为草稿箱点进来
@property (strong, nonatomic) NSString *mailId;   //邮件id 

- (IBAction)buttonClickHandle:(id)sender;

@end
