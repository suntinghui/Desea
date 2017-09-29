//
//  WriteMessageViewController.h
//  Desea
//
//  Created by wenbin on 14-2-13.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：我的短信--信息编写页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "YFInputBar.h"
#import "ContactsModel.h"

@interface WriteMessageViewController : BaseViewController<YFInputBarDelegate,
    UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *inputBackImgView;
@property (weak, nonatomic) IBOutlet UITextView *reciverTxtView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) ContactsModel *recever;
@property (strong, nonatomic) NSMutableString *reciverName; //收件人姓名 用分号分隔
@property (strong, nonatomic) NSMutableString *reciverPhone; //收件人号码 用分号分隔

- (IBAction)buttonClickHandle:(id)sender;

@end
