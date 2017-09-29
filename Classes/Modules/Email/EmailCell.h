//
//  EmailCell.h
//  Desea
//
//  Created by wenbin on 14-2-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@end
