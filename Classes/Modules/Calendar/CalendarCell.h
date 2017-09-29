//
//  CalendarCell.h
//  Desea
//
//  Created by wenbin on 14-1-17.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //标题
@property (weak, nonatomic) IBOutlet UILabel *arearLabel; //范围
@property (weak, nonatomic) IBOutlet UILabel *stateLabel; //状态
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  //时间
@property (weak, nonatomic) IBOutlet UILabel *arearTitleLabel;

@end
