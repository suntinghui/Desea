//
//  PublicCell.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "PublicCell.h"

@implementation PublicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end