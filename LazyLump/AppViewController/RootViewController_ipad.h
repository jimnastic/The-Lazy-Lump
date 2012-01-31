//
//  RootViewController.h
//
//  Created by Darji Mehul iMobDev on 20/01/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RootViewController_ipad : UIViewController
{
	CGFloat lastRotation;
    int previousTimestamp;
    float speed;
    float revolutions;
    NSTimer *timerUpdate;
}
@property (retain, nonatomic) IBOutlet UIImageView *spinWheel;

- (void)rotateAccordingToAngle:(float)angle;
-(void)startAnimationWithRevolutions:(float)revPerSecond forTime:(float)time;

@end
