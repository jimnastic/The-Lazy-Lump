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
    BOOL player1Fill;
    BOOL player2Fill;
    BOOL player3Fill;
    BOOL player4Fill;
    NSMutableArray *AllPlayer;
}
@property (retain, nonatomic) IBOutlet UIView *Player1;
@property (retain, nonatomic) IBOutlet UIView *Player2;
@property (retain, nonatomic) IBOutlet UIView *Player3;
@property (retain, nonatomic) IBOutlet UIView *Player4;
@property (retain, nonatomic) IBOutlet UIButton *PlayButton;


- (IBAction)StartBtnClicked:(id)sender;
- (IBAction)TipsBtnClicked:(id)sender;
- (IBAction)DoneBtnClicked:(id)sender;
-(id)easeInOut:(float)timeDuration;             //fading animation for text
- (IBAction)wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
- (IBAction)BtnTouchEnd:(id)sender forEvent:(UIEvent *)event;
@end
