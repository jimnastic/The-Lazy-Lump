//
//  SpinWhellViewController.m
//  LazyLump
//
//  Created by iMobDev Technologies Pvt. Ltd. on 31/01/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import "SpinWhellViewController.h"
#import "WheelControl.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation SpinWhellViewController
@synthesize TaskView;
@synthesize TaskImage;
@synthesize SelectedTaskLbl;
//@synthesize spinWheel;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    colorNames = [[NSArray alloc] initWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",nil];
    wheelControl = [[WheelControl alloc] initWithFrame:CGRectMake(0, 0,570,570)];
	wheelControl.image = [UIImage imageNamed:@"wheel.png"];
	wheelControl.center = self.view.center;
	wheelControl.refPoint = CGPointMake(797,250);
	wheelControl.delegate = self;
	[wheelControl calculateMarkersWithCenter:CGPointMake(285,285) arcCount:[colorNames count] startPoint:CGPointMake(295,0)];
	[self.view addSubview:wheelControl];
    [self.view addSubview:TaskView];
}

- (void)viewDidUnload
{
    [self setSelectedTaskLbl:nil];
    [self setTaskView:nil];
    [self setTaskImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma mark WheelControlDelegate methods

-(void) movedWithInitialAngularVelocity:(float)initialVelocity {
}

-(void) didRotate:(float)radians 
{
}

-(void) interruptedAfterRotation:(float)radians {
}

-(void) rotationDidEnd:(float) radians {
	
}

-(void) nearestIndexAfterRotationEnded:(int)index
{
//	NSLog(@"Selected Color is: %@", [colorNames objectAtIndex:index]);
//	statusLabel.text = [NSString stringWithFormat:@"Selected Color is: %@", [colorNames objectAtIndex:index]];
    NSLog(@"value:%@",[colorNames  objectAtIndex:index]);
    SelectedTaskLbl.text=[NSString stringWithFormat:@"Selected Task : %@",[colorNames  objectAtIndex:index]];
    
    selectedIndex=index+1;
    [self TaskShowAnimation];
//  [self performSelectorOnMainThread:@selector(TaskShowAnimation) withObject:nil waitUntilDone:NO];
}
- (IBAction)PlayBtnClicked:(id)sender 
{
    TaskView.hidden=TRUE;
}

-(void)TaskShowAnimation
{
    sleep(1);
    TaskView.hidden=FALSE;
    TaskImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"Task%d.png",selectedIndex]];
    TaskView.frame=CGRectMake(512,374,0,0);
	[UIView beginAnimations:@"3" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
    TaskView.frame=CGRectMake(0,0,1024,748);
	[UIView commitAnimations];
}

//- (void)rotateAccordingToAngle:(float)angle
//{
//    [spinWheel setTransform:CGAffineTransformRotate(spinWheel.transform, angle)];
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
//{    
//    [spinWheel.layer removeAllAnimations];
//    previousTimestamp = event.timestamp;
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if (touch.view==spinWheel)
//    {
//        UITouch *touch = [touches anyObject];
//        CGPoint center = CGPointMake(CGRectGetMidX([spinWheel bounds]), CGRectGetMidY([spinWheel bounds]));
//        CGPoint currentTouchPoint = [touch locationInView:spinWheel];
//        CGPoint previousTouchPoint = [touch previousLocationInView:spinWheel];
//        CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
//        
//        [self rotateAccordingToAngle:angleInRadians];
//        
//        CGFloat angleInDegree = RADIANS_TO_DEGREES(angleInRadians);
//        revolutions+= (angleInDegree/360.0f);
//    }
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if (touch.view==spinWheel) 
//    {
//        NSTimeInterval timeSincePrevious = event.timestamp - previousTimestamp;
//        CGFloat revolutionsPerSecond = revolutions/timeSincePrevious;
//        NSLog(@"%.3f",revolutionsPerSecond);
//        [self startAnimationWithRevolutions:revolutionsPerSecond forTime:5.0f];
//    }
//    revolutions = 0;
//}
//
//- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
//{
//    spinWheel.userInteractionEnabled = TRUE;
//    if (timerUpdate) {
//        [timerUpdate invalidate];
//        timerUpdate = nil;
//    }
//}
//-(void)updateTransform{
//    spinWheel.transform = [[spinWheel.layer presentationLayer] affineTransform];
//}
//-(void)startAnimationWithRevolutions:(float)revPerSecond forTime:(float)time
//{
//    spinWheel.userInteractionEnabled = FALSE;
//    float totalRevolutions = revPerSecond * time;
//    
//    timerUpdate = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTransform) userInfo:nil repeats:YES];
//    
//    [CATransaction begin];
//	[CATransaction setValue:[NSNumber numberWithFloat:time] forKey:kCATransactionAnimationDuration];
//	
//	CABasicAnimation* spinAnimation = [CABasicAnimation
//									   animationWithKeyPath:@"transform.rotation"];
//	CGAffineTransform transform = spinWheel.transform;
//	float fromAngle = atan2(transform.b, transform.a);
//	float toAngle = fromAngle + (totalRevolutions*4*M_PI);
//	spinAnimation.fromValue = [NSNumber numberWithFloat:fromAngle];
//	spinAnimation.toValue = [NSNumber numberWithFloat:toAngle];
//	spinAnimation.repeatCount = 0;
//	spinAnimation.removedOnCompletion = NO;
//    spinAnimation.delegate = self;
////    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
////                                    kCAMediaTimingFunctionEaseOut];
//    spinAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//	[spinWheel.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
//	[CATransaction commit];
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)dealloc 
{
//  [spinWheel release];
    [SelectedTaskLbl release];
    [TaskView release];
    [TaskImage release];
    [super dealloc];
    [wheelControl release];
}
@end
