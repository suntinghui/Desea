//
//  LKTipCenter.h
//
//  Created by luke on 10-11-17.
//  Copyright 2010 pica.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKTipView;
@class LKTip;

@interface LKTipCenter : NSObject {
	
	BOOL active;
    BOOL positionDown;
	//id<LKTipDelegate> delegate;
@private
	NSMutableArray *tips;
	LKTipView *tipView;
	LKTip *curTip;
}



+ (LKTipCenter *)defaultCenter;

- (void)postTipWithMessage:(NSString *)message image:(UIImage *)image time:(NSTimeInterval)dTime ignoreAddition:(BOOL)ignore;
- (void)postFallingTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime;

- (void)postDownTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime;
- (void)postDownTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image;

- (void)postUpTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime;
- (void)postUpTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image;

- (void)postTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime ignoreTouch:(BOOL)touch  position:(BOOL)position;
- (void)postTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image ignoreTouch:(BOOL)touch  position:(BOOL)position;
- (void)postTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image ignoreAddition:(BOOL)ignore ignoreTouch:(BOOL)touch  position:(BOOL)position;

- (void)animationDrawup:(NSTimer *)theTimer;

@end
