
#import <UIKit/UIKit.h>
@protocol WheelControlDelegate <NSObject>

@optional
-(void) movedWithInitialAngularVelocity:(float)initialVelocity;
-(void) didRotate:(float)radians;
-(void) interruptedAfterRotation:(float)radians;
-(void) rotationDidEnd:(float) radians;
-(void) nearestIndexAfterRotationEnded:(int)index;

@end
