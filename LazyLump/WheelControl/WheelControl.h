
#import <UIKit/UIKit.h>
#import "WheelControlDelegate.h"
#import "Marker.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define kDeceleration 0.1

@interface WheelControl : UIView {
    SystemSoundID _pewPewSound;

	float centerX;
	float centerY;
	float angle;
	float currentX;
	float currentY;
	float previousX;
	float previousY;
	float radius;
	UIImageView *imgView;
	UIImage *image;
	double dragStartTime;
	double dragEndTime;
	float previousDragX;
	float previousDragY;
	BOOL runWheel;
	id <WheelControlDelegate> delegate;
	float rotationCount;
	float callbackAngle; //in radians
	int level;
	float sleepTime;
	NSMutableArray *checkPoints;
	CGPoint refPoint;
	BOOL touchMoved;
//    AVAudioPlayer *player;
    BOOL SLOW;
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, assign) id <WheelControlDelegate> delegate;
@property(nonatomic, assign) float callbackAngle;
@property(nonatomic, assign) CGPoint refPoint;

-(void) calculateMarkersWithCenter:(CGPoint)wheelCenter 
						  arcCount:(int) arcCount //Number of arcs in the wheel
						startPoint:(CGPoint) startPoint;


@end
