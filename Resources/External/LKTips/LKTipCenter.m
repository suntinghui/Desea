//  横幅tips
//  LKTipCenter.m
//
//  Created by luke on 10-11-17.
//  Copyright 2010 pica.com. All rights reserved.
//

#import "LKTipCenter.h"
#import "LKTipView.h"
#import "LKTip.h"

/*
@protocol LKTipDelegate <NSObject>

@optional
- (void)LKTipPressed:(NSString *)message;

@end
*/
 
@interface LKTipCenter ()

@property (nonatomic, retain) NSMutableArray *tips;
@property (nonatomic, retain) LKTipView *tipView;
@property (nonatomic, assign) LKTip *curTip;

- (void)disposeTip;
- (void)animationFadeout:(NSTimer *)theTimer;
- (void)showDownTips;
- (void)showUpTips;
- (void)fallingTips;

@end


@implementation LKTipCenter

@synthesize tips, tipView, curTip;

- (id)init {
	
	if (!(self=[super init]))
		return nil;
	
	self.tips = [NSMutableArray array];
	active = NO;
	positionDown = NO;
	return self;
}

- (void)dealloc {
	
	[tips release];
	[tipView release];
	[super dealloc];
}

- (void)disposeTip {
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[tipView removeFromSuperview];
	[tips removeObjectAtIndex:0];
    if (positionDown) {
        [self showDownTips];
    }
    else {
        [self showUpTips];
    }
	
}

- (void)animationDrawup:(NSTimer *)theTimer {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(disposeTip)];
	
    if (positionDown) {
        tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y - 40, tipView.frame.size.width, tipView.frame.size.height);
        tipView.alpha = 0;
    }
	else {
        tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40, tipView.frame.size.width, tipView.frame.size.height);
        tipView.alpha = 0;
    }
	[UIView commitAnimations];
}

- (void)timedDrawup {
	
	LKTip *aTip = [tips objectAtIndex:0];
	if (aTip && aTip.time) {
//		DLog(@"");
		[NSTimer scheduledTimerWithTimeInterval:aTip.time target:self selector:@selector(animationDrawup:) userInfo:nil repeats:NO];
	} 
    else {
		[self animationDrawup:nil];
	}
}

- (void)animationFadeout:(NSTimer *)theTimer {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(disposeTip)];
#if 0
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		degrees = -90;
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		degrees = 90;
	} else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		degrees = 180;
	}
#endif
	//tipView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//tipView.transform = CGAffineTransformScale(tipView.transform, 0.5, 0.5);
	
	tipView.alpha = 0;
	[UIView commitAnimations];
}

- (void)timedFadeout {
	
	LKTip *aTip = [tips objectAtIndex:0];
	if (aTip && aTip.time) {
		[NSTimer scheduledTimerWithTimeInterval:aTip.time target:self selector:@selector(animationFadeout:) userInfo:nil repeats:NO];
	} else {
		[self animationFadeout:nil];
	}
}

- (void)showDownTips {
	
	if ([self.tips count] < 1) {
		active = NO;
        positionDown = NO;
		return;
	}
	
	active = YES;
	CGFloat degrees = 0;
	CGRect rc = [[UIScreen mainScreen] bounds];
    LKTip *aTip = [self.tips objectAtIndex:0];
    
    UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height/2;

		tipView.center = CGPointMake(0, h);//  240); 
		degrees = -90;
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h =  rc.size.height/2;

		float w =  rc.size.width;
		tipView.center = CGPointMake(w,h); //(320, 240); 
		degrees = 90;
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.width, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height;
		tipView.center = CGPointMake(rc.size.width/2, h);////480);
		degrees = 180;
	}
	else 
	{   
        CGRect f = CGRectMake(0, 0, rc.size.width, 40);
        self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
        tipView.center = CGPointMake(rc.size.width/2, 0); 
	}
	tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y, tipView.frame.size.width, aTip.image ? aTip.image.size.height : tipView.frame.size.height);
	tipView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//tipView.transform = CGAffineTransformScale(tipView.transform, 1, 1);
	tipView.alpha = 1;
	[[UIApplication sharedApplication].keyWindow addSubview:tipView];
	tipView.tag = 2011;
	
	
	
    if (aTip.image) {
        [tipView setImage:aTip.image];
    }
    
	if(aTip.message)
		[tipView setText:aTip.message];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(timedDrawup)];
	
	tipView.alpha = 1;
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x+ 40, tipView.frame.origin.y + 40 , tipView.frame.size.width, tipView.frame.size.height);
		
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x - 40, tipView.frame.origin.y + 40 , tipView.frame.size.width, tipView.frame.size.height);
		//tipView.frame = CGRectMake(0, 20, rc.size.height, 40);
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y - 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
		
	}
	else 
	{ 
        //tipView.frame = CGRectMake(0, 20, rc.size.width, 40);
        if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:1] || [[[UIApplication sharedApplication] keyWindow] viewWithTag:2]) {
            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40, tipView.frame.size.width, tipView.frame.size.height);
        }
        else
        {
//            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40, tipView.frame.size.width, tipView.frame.size.height);
        }
	}
	
	[UIView commitAnimations];
}

- (void)showUpTips {
	
	if ([self.tips count] < 1) {
		active = NO;
        positionDown = NO;
		return;
	}
	
	active = YES;
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	CGRect rc = [[UIScreen mainScreen] bounds];
    
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		CGRect f = CGRectMake(0, 0, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height/2;
        
		tipView.center = CGPointMake(0, h);//  240); 
		degrees = -90;
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		CGRect f = CGRectMake(0, 0, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h =  rc.size.height/2;
        
		float w =  rc.size.width;
		tipView.center = CGPointMake(w,h); //(320, 240); 
		degrees = 90;
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		CGRect f = CGRectMake(0, 0, rc.size.width, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height;
		tipView.center = CGPointMake(rc.size.width/2, h);////480);
		degrees = 180;
	}
	else 
	{
		CGRect f = CGRectMake(0, 0, rc.size.width, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		tipView.center = CGPointMake(rc.size.width/2, rc.size.height+20); 
	}
	
	tipView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//tipView.transform = CGAffineTransformScale(tipView.transform, 1, 1);
	tipView.alpha = 1;
	[[UIApplication sharedApplication].keyWindow addSubview:tipView];
	tipView.tag = 2011;
	
	LKTip *aTip = [self.tips objectAtIndex:0];
	
    if (aTip.image)
        [tipView setImage:aTip.image];
    
	if(aTip.message)
		[tipView setText:aTip.message];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(timedDrawup)];
	
	tipView.alpha = 1;
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x+ 40, tipView.frame.origin.y + 40 , tipView.frame.size.width, tipView.frame.size.height);
		
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x - 40, tipView.frame.origin.y + 40 , tipView.frame.size.width, tipView.frame.size.height);
		//tipView.frame = CGRectMake(0, 20, rc.size.height, 40);
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y - 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
		
	}
	else 
	{ 
        //tipView.frame = CGRectMake(0, 20, rc.size.width, 40);
        if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:1] || [[[UIApplication sharedApplication] keyWindow] viewWithTag:2]) {
            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y - 40, tipView.frame.size.width, tipView.frame.size.height);
        }
        else
        {
            //            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
            tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y-40, tipView.frame.size.width, tipView.frame.size.height);
            NSLog(@"%@", NSStringFromCGRect(tipView.frame));
        }
	}
	
	[UIView commitAnimations];
}

- (void)fallingTips {
	
	if ([self.tips count] < 1) {
		active = NO;
        positionDown = NO;
		return;
	}
	
	active = YES;
	tipView.transform = CGAffineTransformIdentity;
	//[UIApplication sharedApplication].keyWindow.center;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	CGRect rc = [[UIScreen mainScreen] bounds];

	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height/2;
		
		tipView.center = CGPointMake(0, h);//  240); 
		degrees = -90;
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.height, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h =  rc.size.height/2;
		
		float w =  rc.size.width;
		tipView.center = CGPointMake(w,h); //(320, 240); 

		degrees = 90;
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		CGRect f = CGRectMake(0, -20, rc.size.width, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		float h = rc.size.height;
		tipView.center = CGPointMake(rc.size.width/2, h);////480);
		degrees = 180;
	}
	else 
	{
		CGRect f = CGRectMake(0, 0, rc.size.width, 40);
		self.tipView = [[[LKTipView alloc] initWithFrame:f] autorelease];
		tipView.center = CGPointMake(rc.size.width/2, 0); 
	}

	tipView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//tipView.transform = CGAffineTransformScale(tipView.transform, 1, 1);
	tipView.alpha = 1;
	[[UIApplication sharedApplication].keyWindow addSubview:tipView];
	
	LKTip *aTip = [self.tips objectAtIndex:0];
	
	if(aTip.message)
		[tipView setText:aTip.message];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(timedDrawup)];
	
	tipView.alpha = 1;
	if (o == UIInterfaceOrientationLandscapeLeft) 
	{
	  tipView.frame = CGRectMake(tipView.frame.origin.x+ 40, tipView.frame.origin.y + 40 , tipView.frame.size.width, tipView.frame.size.height);
		
	} 
	else if (o == UIInterfaceOrientationLandscapeRight) 
	{
		 tipView.frame = CGRectMake(tipView.frame.origin.x - 40, tipView.frame.origin.y + 40, tipView.frame.size.width, tipView.frame.size.height);
		//tipView.frame = CGRectMake(0, 20, rc.size.height, 40);
	} 
	else if (o == UIInterfaceOrientationPortraitUpsideDown) 
	{
		tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y - 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
		
	}
	else 
	{ 
        
		tipView.frame = CGRectMake(tipView.frame.origin.x, tipView.frame.origin.y + 40 + 40, tipView.frame.size.width, tipView.frame.size.height);
		
		//tipView.frame = CGRectMake(0, 20, rc.size.width, 40);
		
	}
	
	[UIView commitAnimations];
}

#pragma mark -
+ (LKTipCenter *)defaultCenter {
	
	static LKTipCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[LKTipCenter alloc] init];
	}
	return defaultCenter;
}


- (void)postTipWithMessage:(NSString *)message image:(UIImage *)image time:(NSTimeInterval)dTime ignoreAddition:(BOOL)ignore  {
	
	if (ignore && [tips count] > 0) {
		return;
	}

	LKTip *aTip = [[LKTip alloc] initWithMsg:message img:image durationTime:dTime];
	if (aTip) {
		self.curTip = aTip;
		[self.tips addObject:aTip];
		[aTip release];
		if (!active) {
            if (positionDown) {
                [self showDownTips];
            }
            else {
                [self showUpTips];
            }
        }
	}
}

- (void)postFallingTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime {
	
	LKTip *aTip = [[LKTip alloc] initWithMsg:message img:nil durationTime:dTime];
	if (aTip) {
		self.curTip = aTip;
		[self.tips addObject:aTip];
		[aTip release];
		if (!active)
			[self fallingTips];
	}
}

#pragma mark - DownTip Ignore Touch
- (void)postDownTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime
{
    [self postTipWithMessage:message time:dTime ignoreTouch:YES position:YES];
}

- (void)postDownTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image
{
    [self postTipWithMessage:message time:dTime image:image ignoreTouch:YES position:YES];
}

#pragma mark - UpTip Ignore Touch
- (void)postUpTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime
{
    [self postTipWithMessage:message time:dTime ignoreTouch:YES position:NO];
}
- (void)postUpTipWithMessage:(NSString *)message time:(NSTimeInterval)dTime image:(UIImage *)image
{
    [self postTipWithMessage:message time:dTime image:image ignoreTouch:YES position:NO];
}
#pragma mark - Wether Ignore Touch
- (void)postTipWithMessage:(NSString *)message 
                      time:(NSTimeInterval)dTime
               ignoreTouch:(BOOL)touch
                  position:(BOOL)position
{
    if (touch) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    positionDown = position;
    [self postTipWithMessage:message image:nil time:dTime ignoreAddition:NO];
}

- (void)postTipWithMessage:(NSString *)message 
                      time:(NSTimeInterval)dTime 
                     image:(UIImage *)image
               ignoreTouch:(BOOL)touch 
                  position:(BOOL)position
{
    if (touch) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    positionDown = position;
    [self postTipWithMessage:message image:image time:dTime ignoreAddition:NO];
}

- (void)postTipWithMessage:(NSString *)message
                      time:(NSTimeInterval)dTime
                     image:(UIImage *)image
            ignoreAddition:(BOOL)ignore 
               ignoreTouch:(BOOL)touch
                  position:(BOOL)position 
{
    if (touch) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
     positionDown = position;
    [self postTipWithMessage:message image:nil time:dTime ignoreAddition:ignore];
}

#pragma mark touch handle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
//	DLog(@"");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
//	DLog(@"");
}


@end
