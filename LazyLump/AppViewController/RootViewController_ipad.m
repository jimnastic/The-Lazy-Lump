//
//  RootViewController.m
//
//  Created by Darji Mehul iMobDev on 20/01/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import "RootViewController_ipad.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation RootViewController_ipad

@synthesize spinWheel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)rotateAccordingToAngle:(float)angle
{
    [spinWheel setTransform:CGAffineTransformRotate(spinWheel.transform, angle)];
}

- (void)viewDidUnload
{
    [self setSpinWheel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{    
    previousTimestamp = event.timestamp;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view==spinWheel)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint center = CGPointMake(CGRectGetMidX([spinWheel bounds]), CGRectGetMidY([spinWheel bounds]));
        CGPoint currentTouchPoint = [touch locationInView:spinWheel];
        CGPoint previousTouchPoint = [touch previousLocationInView:spinWheel];
        CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
        
        [self rotateAccordingToAngle:angleInRadians];
        
        CGFloat angleInDegree = RADIANS_TO_DEGREES(angleInRadians);
        revolutions+= (angleInDegree/360.0f);
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view==spinWheel) 
    {
        NSTimeInterval timeSincePrevious = event.timestamp - previousTimestamp;
        CGFloat revolutionsPerSecond = revolutions/timeSincePrevious;
        NSLog(@"%.3f",revolutionsPerSecond);
        [self startAnimationWithRevolutions:revolutionsPerSecond forTime:5.0f];
    }
    revolutions = 0;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    spinWheel.userInteractionEnabled = TRUE;
    if (timerUpdate) {
        [timerUpdate invalidate];
        timerUpdate = nil;
    }
}
-(void)updateTransform{
    spinWheel.transform = [[spinWheel.layer presentationLayer] affineTransform];
}
-(void)startAnimationWithRevolutions:(float)revPerSecond forTime:(float)time{
    spinWheel.userInteractionEnabled = FALSE;
    float totalRevolutions = revPerSecond * time;
    
    timerUpdate = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTransform) userInfo:nil repeats:YES];
    
    [CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:time] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation* spinAnimation = [CABasicAnimation
									   animationWithKeyPath:@"transform.rotation"];
	CGAffineTransform transform = spinWheel.transform;
	float fromAngle = atan2(transform.b, transform.a);
	float toAngle = fromAngle + (totalRevolutions*4*M_PI);
	spinAnimation.fromValue = [NSNumber numberWithFloat:fromAngle];
	spinAnimation.toValue = [NSNumber numberWithFloat:toAngle];
	spinAnimation.repeatCount = 0;
	spinAnimation.removedOnCompletion = NO;
    spinAnimation.delegate = self;
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
                                     kCAMediaTimingFunctionEaseOut];
	[spinWheel.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
	[CATransaction commit];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [spinWheel release];
    [super dealloc];
}
@end
