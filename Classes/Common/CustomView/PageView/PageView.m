//
//  PageView.m
//  Desea
//
//  Created by 文彬 on 14-4-14.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "PageView.h"

#define Action_Tag_Front 100
#define Action_Tag_Next  101

#define kOnePageCount 20 //一页显示的条数

@implementation PageView

- (void)setAllPageDatas:(NSMutableArray *)allPageDatas
{
    if (allPageDatas.count==0) {
        self.frontBtn.enabled = NO;
        self.nextBtn.enabled = NO;
        self.currentPageDatas = [NSMutableArray arrayWithCapacity:0];
        return;
    }
    
    _allPageDatas = allPageDatas;
    
    if (self.allPageDatas.count%kOnePageCount==0)
    {
        self.maxPage = self.allPageDatas.count/kOnePageCount;
    }
    else
    {
        self.maxPage = self.allPageDatas.count/kOnePageCount+1;
    }
    
    self.currentPage=1;
    
    [self getCurrentPageData];
    
}
/**
 *  根据当前页面从所有的数据中获取当前页的数据
 */
- (void)getCurrentPageData
{
    int pageLength;
    if (self.allPageDatas.count%kOnePageCount==0)
    {
        pageLength = kOnePageCount;
    }
    else
    {
        if (self.currentPage<self.maxPage)
        {
            pageLength = kOnePageCount;
        }
        else
        {
            pageLength = self.allPageDatas.count%kOnePageCount;
        }
    }
    
    self.currentPageDatas =[NSMutableArray arrayWithArray: [self.allPageDatas subarrayWithRange:NSMakeRange((self.currentPage-1)*kOnePageCount, pageLength)]];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentPage,self.maxPage];
    
    if (self.maxPage==1)
    {
        self.frontBtn.enabled = NO;
        self.nextBtn.enabled = NO;
    }
    else
    {
        if (self.currentPage==1)
        {
            self.frontBtn.enabled = NO;
            self.nextBtn.enabled = YES;
        }
        else if(self.currentPage==self.maxPage)
        {
            self.nextBtn.enabled = NO;
            self.frontBtn.enabled = YES;
        }
        else
        {
            self.frontBtn.enabled = YES;
            self.nextBtn.enabled = YES;
        }
    }
    
}

- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case Action_Tag_Front:
        {
            if (self.currentPage==1)
           {
               [StaticTools showAlertWithTag:0
                                       title:nil
                                     message:@"已经是第一页"
                                   AlertType:CAlertTypeDefault
                                   SuperView:nil];
               return;
            }
            
            self.currentPage--;
            
            [self getCurrentPageData];
            
            if ([self.delegate respondsToSelector:@selector(frontPageClickWihtCurrentPage:)])
            {
                [self.delegate frontPageClickWihtCurrentPage:self.currentPageDatas];
            }
        }
            break;
        case Action_Tag_Next:
        {
            if (self.currentPage==self.maxPage)
            {
                [StaticTools showAlertWithTag:0
                                        title:nil
                                      message:@"已经是最后一页"
                                    AlertType:CAlertTypeDefault
                                    SuperView:nil];
                return;
            }
            
            self.currentPage++;
            
            [self getCurrentPageData];
            
            if ([self.delegate respondsToSelector:@selector(nextPageClickWithCurrentPage:)])
            {
                [self.delegate nextPageClickWithCurrentPage:self.currentPageDatas];
            }
        }
            break;
            
        default:
            break;
    }
}
@end
