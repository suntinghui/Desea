//
//  FlowHandleViewController.h
//  Desea
//
//  Created by wenbin on 14-1-20.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 菊花小分队
 // 版权所有。
 //
 // 文件功能描述：流程办理详情页
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "ScrollSelectView.h"

@interface FlowHandleViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UITextViewDelegate,
    ScrollSelectDelegate,
    UIScrollViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate>
{
    float keyBoardLastHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *infoId;

@property (assign, nonatomic) int sType;
/*0 =流程管理待接收、今日收文、收文管理待接收、发文管理待接收，
 1=流程管理办理中、收文管理办理中、发文管理办理中，，
 2=流程管理历史记录、收文管理历史记录、发文管理历史记录，，
 3=流程管理待批、收文管理待批、发文管理待批，，
 4=流程管理撤销、收文管理撤销、发文管理撤销，
*/

@property (strong, nonatomic) NSMutableDictionary *resultDict;
@property (weak, nonatomic) IBOutlet UIView *dateView;  //时间和日期选择视图
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (assign, nonatomic) int currentEditIndex; //当前正在编辑的行号


- (IBAction)buttonClickHandle:(id)sender;

- (void)saveFormWithType:(NSString*)type;

@end
