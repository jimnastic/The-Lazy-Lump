//
//  SpinWhellViewController.h
//  LazyLump
//
//  Created by iMobDev Technologies Pvt. Ltd. on 31/01/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WheelControl.h"

@interface SpinWhellViewController : UIViewController<WheelControlDelegate> 
{
//    CGFloat lastRotation;
//    int previousTimestamp;
//    float speed;
//    float revolutions;
//    NSTimer *timerUpdate;
     NSArray *colorNames;
     WheelControl *wheelControl;
    int selectedIndex;
}
//-(void)TimerStart;
@property (retain, nonatomic) IBOutlet UIView *TaskView;
@property (retain, nonatomic) IBOutlet UIImageView *TaskImage;
@property (retain, nonatomic) IBOutlet UILabel *SelectedTaskLbl;
//- (void)rotateAccordingToAngle:(float)angle;
//-(void)startAnimationWithRevolutions:(float)revPerSecond forTime:(float)time;
- (IBAction)PlayBtnClicked:(id)sender;
-(void)TaskShowAnimation;

@end
