//
//  GameView.m
//  Panda Alarm
//
//  Created by James Lubowich on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"


@implementation GameView
@synthesize center, radius;

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"Init GameView with Frame");
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"Init GameView with Coder");
    if(self = [super initWithCoder:aDecoder]){
        radius = 200;
        tapsLeft = 5;
        CGRect frame = [self frame];
        center = CGPointMake(frame.size.width * 3/4, frame.size.height*3/4);
//        center = CGPointMake(100, 
//        NSLog(@"Frame: %@", frame.origin);
//        NSLog(@"Size: (%f, %f)", frame.size.width, frame.size.height);
//        NSLog(@"Center: (%f, %f)", center.x, center.y);

    }
    return self;
}

- (void)setRandomCenter{
    center = [self randomPoint];
}

- (CGPoint)randomPoint {
    CGRect frame = [self frame];
//    NSLog(@"Frame.origin: %@", frame.origin);
    int x = arc4random()% (int)(frame.origin.x + frame.size.width - radius);
    int y = arc4random()% (int)(frame.origin.y + frame.size.height - radius);
    x += radius;
    y += radius;
    
//    NSLog(@"Frame bounds O:(%f,%f) S:%fx%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//    NSLog(@"Rand %d, %d", x, y);
    CGPoint point = {x,y};
    return point;
}

- (bool)containsPoint:(CGPoint)point{
    return CGRectContainsPoint(bounds, point);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	UIColor* currentColor = [UIColor redColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
    bounds = CGRectMake(center.x - radius, center.y - radius,radius,radius);
    //Set the width of the "pen" that will be used for drawing
	CGContextSetLineWidth(context,4);
    //Set the color of the pen to be used
    CGContextSetFillColorWithColor(context, currentColor.CGColor);
    CGContextFillEllipseInRect(context, bounds);
    
}



@end
