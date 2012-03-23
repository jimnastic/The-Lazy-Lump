
#import "WheelControl.h"
@interface WheelControl (Private)

-(void) initializeControl;
-(void) rotateWheel:(float) angle dragTime:(float) time;
-(void) resetPoints;

@end



@implementation WheelControl

@synthesize delegate, refPoint;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self initializeControl];
      	}
    return self;
}

//if interface builder used...
-(void) awakeFromNib {

	[self initializeControl];
}

-(void) initializeControl 
{
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"TICK" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((CFURLRef)pewPewURL, &_pewPewSound);
	CGRect aRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	imgView = [[UIImageView alloc] initWithFrame:aRect];
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:imgView];
	[self sendSubviewToBack:imgView];
	angle = 0;
	centerX = self.frame.size.width / 2;
	centerY = self.frame.size.height / 2;
	previousX = 0;
	previousY = 0;
	currentX = 0;
	currentY = 0;
	previousDragX = 0;
	previousDragY = 0;
	rotationCount = 0;
	radius = self.frame.size.width / 2;
	sleepTime = 0.1f;
	//default eference points
	refPoint.x = centerX;
	refPoint.y = self.frame.size.height;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark - Gesture handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [player stop];
//    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"TICK" ofType:@"wav"];
//    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
//    player.numberOfLoops = -1; //infinite

//    AudioServicesPlaySystemSound(_pewPewSound);
    touchMoved	= NO;
    runWheel = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    currentX = (point.x - centerX);
    currentY = (point.y - centerY);
    //NSLog(@"Touch began: %f %f", currentX, currentY);
    previousX = currentX;
    previousY = currentY;
    previousDragX = previousX;
    previousDragY = previousY;
    level = 0;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	currentX = (point.x - centerX);
	currentY = (point.y - centerY);
	//NSLog(@"Touch moved: %f %f", currentX, currentY);
	//read : http://www.ltcconline.net/greenl/Courses/107/vectors/dotcros.htm
	float dotProduct = (currentX * previousX) + (currentY * previousY);
	//read: http://www.flaviusalecu.com/?p=29 for signed angle between two vectors
	float perpDot = ((currentY * previousX) - (currentX * previousY));
	//NSLog(@"DOT: product: %f", dotProduct);
	// signed angle is calculated as mentioned below, in radians
	float radianAngle = atan2f(perpDot, dotProduct);
	//NSLog(@"radianAngle:%f", radianAngle);
	float degrees = ((radianAngle * 180) / M_PI);
	//NSLog(@"degrees: %f", degrees);
	if (radianAngle < 0) {
		radianAngle *= -1;
	}
	rotationCount += radianAngle;
	//NSLog(@"Rotation count: %f", rotationCount);
	int currentLevel = (int)rotationCount / callbackAngle;
	if (currentLevel > level){
		if (delegate != nil && [delegate respondsToSelector:@selector(didRotate:)]) {
			[delegate didRotate:rotationCount];
			level = currentLevel;
		}
	}
	
	angle += degrees;
	
	NSDate *startTime = [NSDate date];
	dragStartTime = [startTime timeIntervalSince1970];
    
	imgView.center = CGPointMake(centerX, centerY);
	imgView.transform = CGAffineTransformMakeRotation((angle * M_PI) / 180);
	previousDragX = previousX;
	previousDragY = previousY;
	previousX = currentX;
	previousY = currentY;
	touchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
	//if(playing) return;
    SLOW=FALSE;
	if(touchMoved){
//        player.numberOfLoops = -1; //infinite
//        [player play];
        AudioServicesPlaySystemSound(_pewPewSound);

		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:self];
		currentX = (point.x - centerX);
		currentY = (point.y - centerY);
		
		//read : http://www.ltcconline.net/greenl/Courses/107/vectors/dotcros.htm
		float dotProduct = (currentX * previousDragX) + (currentY * previousDragY);
		//read: http://www.flaviusalecu.com/?p=29 for signed angle between two vectors
		float perpDot = ((currentY * previousDragX) - (currentX * previousDragY));
		
		// signed angle is calculated as mentioned below, in radians
		float radianAngle = atan2f(perpDot, dotProduct);
		rotationCount += radianAngle;
        
		NSDate *endTime = [NSDate date];
		dragEndTime = [endTime timeIntervalSince1970];
		double dragTime = dragEndTime - dragStartTime;
		[self rotateWheel:radianAngle dragTime:(float)dragTime];
		previousX = 0;
		previousY = 0;
		currentX = 0;
		currentY = 0;
		previousDragX = 0;
		previousDragY = 0;
	}
} 

-(void) rotateWheel:(float)theta dragTime:(float) time {
	//NSLog(@"-- theta: %f time: %f", theta, time);
	float angularVelocity = theta / time; //remember angular velocity is in radians
	//calculated adjusted velocity...
	float adjustedVelocity = (sleepTime / time) * theta;
	//NSLog(@"---- adjusted velocity is: %f", adjustedVelocity);
	//NSLog(@"angular velocity is for angle: %f with time:%f is: %f", theta, time, angularVelocity);
	NSNumber *_initialVelocity = [NSNumber numberWithFloat:adjustedVelocity];
	if (delegate != nil && [delegate respondsToSelector:@selector(movedWithInitialAngularVelocity:)]) {
		[delegate movedWithInitialAngularVelocity:angularVelocity];
	}
	runWheel = YES;
	[NSThread detachNewThreadSelector:@selector(playRotationAnimation:) toTarget:self withObject:_initialVelocity];
}


-(void) playRotationAnimation:(NSNumber *) _initialVelocity 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	float initialVelocity = abs([_initialVelocity floatValue]); //take absolute value, ignore direction

	float currentVelocity = initialVelocity;
	while(currentVelocity > 0.05 && runWheel) 
    { //hacked ... ignore if velocity is lesser then 0.2 radians
        SLOW=TRUE;
		currentVelocity -= (currentVelocity * kDeceleration);
		float netRotation = currentVelocity;
		rotationCount += netRotation;
		if([_initialVelocity floatValue] < 0) netRotation *= -1;
		
		int currentLevel = (int)rotationCount / callbackAngle;
		if (currentLevel > level){
			if (delegate != nil && [delegate respondsToSelector:@selector(didRotate:)]) {
				[delegate didRotate:rotationCount];
				level = currentLevel;
			}
		}
		angle += ((netRotation * 180) / M_PI);
		NSNumber *_rotation = [NSNumber numberWithFloat:((angle * M_PI) / 180)];
		[self performSelectorOnMainThread:@selector(rotateWheelView:) withObject:_rotation waitUntilDone:YES];
		[NSThread sleepForTimeInterval:sleepTime];
	}
    if (initialVelocity<0.05 && SLOW==FALSE) 
    {
        NSLog(@"TRY AGAIN");   
        AudioServicesDisposeSystemSoundID(_pewPewSound);
        NSString *pewPewPath = [[NSBundle mainBundle] 
                                pathForResource:@"TICK" ofType:@"wav"];
        NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
        AudioServicesCreateSystemSoundID((CFURLRef)pewPewURL, &_pewPewSound);
        UIAlertView *ALERT= [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please try again !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [ALERT show];
        [ALERT release];
    }
    else
    {
	if (runWheel)
    {
		if(delegate != nil && [delegate respondsToSelector:@selector(rotationDidEnd:)]) {
//            [player stop];
            AudioServicesDisposeSystemSoundID(_pewPewSound);
			[self resetPoints];
			rotationCount = 0;
			[delegate rotationDidEnd:rotationCount];
		}
	}
	else {
		if (delegate != nil && [delegate respondsToSelector:@selector(interruptedAfterRotation:)]) {
            AudioServicesDisposeSystemSoundID(_pewPewSound);
            NSString *pewPewPath = [[NSBundle mainBundle] 
                                    pathForResource:@"TICK" ofType:@"wav"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((CFURLRef)pewPewURL, &_pewPewSound);

			[delegate interruptedAfterRotation:rotationCount];
			rotationCount = 0;
		}
	}
    }
	[pool release];
}

-(void)rotateWheelView:(NSNumber *)_rotation {
	float rotation = [_rotation floatValue];
	//NSLog(@"Rotating View by: %f", rotation);
	imgView.center = CGPointMake(centerX, centerY);
	imgView.transform = CGAffineTransformMakeRotation(rotation);
}

-(void) resetPoints {
	//NSLog(@"Current angle is : %f", rotationCount);
	float radians = ((angle * M_PI) / 180) * -1;
	float shortestDistance = 768; //lets be safe to assume iphone height
	int indexOfNearestPoint = -1;
	if (checkPoints != nil) {
		//NSLog(@"....points count: %d", [checkPoints count]);
		int count = [checkPoints count];
		for (int i = 0; i < count; i++) {
			Marker *marker = [checkPoints objectAtIndex:i];
			//Visit http://en.wikipedia.org/wiki/Rotation_matrix
			float xpoint = marker.x * cos(radians) - marker.y * sin(radians);
			float ypoint = marker.x * sin(radians) + marker.y * cos(radians);
			float adjustedY = ypoint;
			if (ypoint < 0) {
				adjustedY =  centerY + (ypoint * -1);;
			}
			else {
				adjustedY = centerY - adjustedY;
			}
			float adjustedX = xpoint;
			if (xpoint < 0) {
				adjustedX = centerX - (xpoint * -1);
			}
			else {
				adjustedX += centerX;
			}
			float yDiff = adjustedY - refPoint.y;
			float xDiff = adjustedX - refPoint.x;
			float distance = sqrt((yDiff * yDiff) + (xDiff * xDiff));
			//NSLog(@"Distance at %d is %f", i, distance);
			if (distance < shortestDistance) {
				shortestDistance = distance;
				indexOfNearestPoint = i;
			}
			//NSLog(@"--->> new values are: %f %f", marker.x, marker.y);
		}
		if (delegate != nil && [delegate respondsToSelector:@selector(nearestIndexAfterRotationEnded:)]) {
			[delegate nearestIndexAfterRotationEnded:indexOfNearestPoint];
            NSString *pewPewPath = [[NSBundle mainBundle] 
                                    pathForResource:@"TICK" ofType:@"wav"];
            NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
            AudioServicesCreateSystemSoundID((CFURLRef)pewPewURL, &_pewPewSound);
		}
    }
}

-(UIImage *) image {
	return imgView.image;
}

-(void) setImage:(UIImage *)anImage {
	imgView.image = anImage;
}

//return in degrees
-(float) callbackAngle {
	return ((callbackAngle * 180) / M_PI);
}

//convert it into radians
-(void) setCallbackAngle:(float)_angle {
	callbackAngle = ((_angle * M_PI) / 180);
}

#pragma mark -
#pragma mark calculate markers

-(void) calculateMarkersWithCenter:(CGPoint)wheelCenter arcCount:(int) arcCount startPoint:(CGPoint) startPoint 
{
    checkPoints = [[NSMutableArray alloc] init];
	float startX = startPoint.x - wheelCenter.x;
	float startY = wheelCenter.y - startPoint.y;
	float rotationAngle = 360.0f / (float)arcCount;
	int rotations = arcCount;
	for (int i = 0; i < rotations; i++) 
    {
		Marker *marker = [[Marker alloc] init];
		marker.x = startX;
		marker.y = startY;
		float radians = ((rotationAngle * -1) * (M_PI / 180));
		float nextX = startX * cos(radians) - startY * sin(radians);
		float nextY = startX * sin(radians) + startY * cos(radians);
		startX = nextX;
		startY = nextY;
		[checkPoints addObject:marker];
		NSLog(@"--- Marker[%d]: %f %f", i, marker.x, marker.y);
	}
}

- (void)dealloc
{
    [imgView release];
    [super dealloc];
}


@end
