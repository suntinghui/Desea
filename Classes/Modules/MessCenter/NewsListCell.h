//
//  NewsListCell.h
//  Desea
//
//  Created by wenbin on 14-1-9.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detalLabel;

@end
