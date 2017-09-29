//
//  PageView.h
//  Desea
//
//  Created by 文彬 on 14-4-14.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegate <NSObject>

- (void)frontPageClickWihtCurrentPage:(NSMutableArray*)pageDatas;
- (void)nextPageClickWithCurrentPage:(NSMutableArray*)pageDatas;

@end

@interface PageView : UIView

@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (assign, nonatomic) int maxPage; //最大页码
@property (assign, nonatomic) int currentPage; //当前页码
@property (assign, nonatomic) id<PageViewDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *allPageDatas;  //所有数据
@property (strong, nonatomic) NSMutableArray *currentPageDatas; //当前页码的数据

- (IBAction)buttonClickHandle:(id)sender;

@end
