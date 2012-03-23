//
//  RootViewController.m
//
//  Created by Darji Mehul iMobDev on 20/01/12.
//  Copyright (c) 2012 iMobDev Tech. All rights reserved.
//

#import "RootViewController_ipad.h"
#import "SpinWhellViewController.h"
#import "TipsViewController.h"

@implementation RootViewController_ipad
@synthesize Player1;
@synthesize Player2;
@synthesize Player3;
@synthesize Player4;
@synthesize PlayButton;

#define Rect1 CGRectMake(271,331,100,100)
#define Rect2 CGRectMake(398,208,100,100)
#define Rect3 CGRectMake(526,208,100,100)
#define Rect4 CGRectMake(643,331,100,100)
#define Rect5 CGRectMake(526,443,100,100)
#define Rect6 CGRectMake(398,443,100,100)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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
    player1Fill=FALSE;
    player2Fill=FALSE;
    player3Fill=FALSE;
    player4Fill=FALSE;
    AllPlayer=[[NSMutableArray alloc]init];
    [AllPlayer addObject:@"Rabit1"];
    [AllPlayer addObject:@"Rabit2"];
    [AllPlayer addObject:@"Rabit3"];
    [AllPlayer addObject:@"Rabit4"];
    [AllPlayer addObject:@"Rabit5"];
    [AllPlayer addObject:@"Rabit6"];
}

- (IBAction)StartBtnClicked:(id)sender
{
    SpinWhellViewController *moveToSpinView=[[SpinWhellViewController alloc]initWithNibName:@"SpinWhellView" bundle:nil];
    [self.navigationController pushViewController:moveToSpinView animated:YES];
    [moveToSpinView release];
}

- (IBAction)TipsBtnClicked:(id)sender
{
    //    [self.view addSubview:TipsView];
    //    [TipsView.layer addAnimation:[self easeInOut:0.5] forKey:@"Easein"];
    TipsViewController  *Move=[[TipsViewController alloc]initWithNibName:@"TipsView" bundle:nil];
    [self.navigationController presentModalViewController:Move animated:YES];
    [Move release];
}

- (IBAction)DoneBtnClicked:(id)sender
{
//    [TipsView removeFromSuperview];
}
-(id)easeInOut:(float)timeDuration             //fading animation for text
{
	CABasicAnimation* fadein = [CATransition animation];
	[fadein setDuration:timeDuration];
	[fadein setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return fadein;
}	

- (IBAction)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
	button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
    //    NSLog(@"ButtonTag:%d",button.tag);
    if (CGRectIntersectsRect(Player1.frame, button.frame) && [[Player1 subviews]count]==0)
    {
        button.frame=CGRectMake(0, 0,100,100);
        [Player1 addSubview:button];
        player1Fill=TRUE;
    }
    else if(CGRectIntersectsRect(Player2.frame, button.frame) && [[Player2 subviews]count]==0)
    {
        button.frame=CGRectMake(0, 0,100,100);
        [Player2    addSubview:button];
        player2Fill=TRUE;
    }
    else if(CGRectIntersectsRect(Player3.frame, button.frame)&& [[Player3 subviews]count]==0)
    {
        button.frame=CGRectMake(0, 0,100,100);
        [Player3 addSubview:button];
        player3Fill=TRUE;
    }
    else if(CGRectIntersectsRect(Player4.frame, button.frame) && [[Player4 subviews]count]==0)
    {
        button.frame=CGRectMake(0, 0,100,100);
        [Player4 addSubview:button];
        player4Fill=TRUE;
    }
}

- (IBAction)BtnTouchEnd:(id)sender forEvent:(UIEvent *)event 
{
    NSLog(@"called");
    UIButton *button=(UIButton *)sender;
    //    button.frame=button.frame;
    //    [self.view addSubview:button];
    UITouch *touch = [[event touchesForView:button] anyObject];
	CGPoint location = [touch locationInView:self.view];
    
    if ([button superview]==Player1&&player1Fill) 
    {
        [self.view addSubview:button];
        button.center=location;
        if (CGRectIntersectsRect(Player1.frame, button.frame)) 
        {
            button.frame=CGRectMake(0, 0,100,100);
            [Player1    addSubview:button];
            player1Fill=TRUE;
        }
        else
        {
            player1Fill=FALSE;
            button.center=location;
            [self.view addSubview:button];
        }
    }
    else if ([button superview]==Player2&&player2Fill) 
    {
        [self.view addSubview:button];
        button.center=location;
        if (CGRectIntersectsRect(Player2.frame, button.frame)) 
        {
            button.frame=CGRectMake(0, 0, 100, 100);
            [Player2    addSubview:button];
            player2Fill=TRUE;
        }
        else
        {
            player2Fill=FALSE;
            button.center=location;
            [self.view addSubview:button];
        }
    } 
    else if ([button superview]==Player3&&player3Fill)
    {
        [self.view addSubview:button];
        button.center=location;
        if (CGRectIntersectsRect(Player3.frame, button.frame)) 
        {
            button.frame=CGRectMake(0, 0, 100, 100);
            [Player3    addSubview:button];
            player3Fill=TRUE;
        }
        else
        {
            player3Fill=FALSE;
            button.center=location;
            [self.view addSubview:button];
        }
    }
    else if ([button superview]==Player4&&player4Fill)
    {
        [self.view addSubview:button];
        button.center=location;
        if (CGRectIntersectsRect(Player4.frame, button.frame)) 
        {
            button.frame=CGRectMake(0,0,100,100);
            [Player4    addSubview:button];
            player4Fill=TRUE;
        }
        else
        {
            player4Fill=FALSE;
            button.center=location;
            [self.view addSubview:button];
        }
    }
    else if([button superview]==self.view)
    {
        button.frame=button.frame;
    }
    [UIView beginAnimations:@"1" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    if ([button superview]==self.view) 
    {
        if (button.tag==100) 
        {
            button.frame=Rect1;
        }
        else if (button.tag==200) 
        {
            button.frame=Rect2;
        }
        else if (button.tag==300) 
        {
            button.frame=Rect3;
        } 
        else if (button.tag==400) 
        {
            button.frame=Rect4;
        } 
        else if (button.tag==500) 
        {
            button.frame=Rect5;
        }
        else if (button.tag==600) 
        {
            button.frame=Rect6;
        }
    }
    else
    {
        button.frame=CGRectMake(0, 0, 100, 100);
    }
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)viewDidUnload
{
    [self setPlayer1:nil];
    [self setPlayer2:nil];
    [self setPlayer3:nil];
    [self setPlayer4:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [AllPlayer release];
    [Player1 release];
    [Player2 release];
    [Player3 release];
    [Player4 release];
    [PlayButton release];
    [super dealloc];
}

@end
