//
//  GameView.h
//  Panda Alarm
//
//  Created by James Lubowich on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameView : UIView {
    NSInteger radius;
    CGPoint center;
    UITapGestureRecognizer *singleTap;
    CGRect bounds;
    NSInteger tapsLeft;
}
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger radius;
//- (void)screenTapped:(id)sender;
- (CGPoint)randomPoint;
- (void)setRandomCenter;
- (bool)containsPoint:(CGPoint)point;
@end
