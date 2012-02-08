//
//  GameView.h
//  Panda Alarm
//
//  Created by James Lubowich on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UIView

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) NSInteger tapsLeft;

//- (void)screenTapped:(id)sender;
- (CGPoint)randomPoint;
- (void)setRandomCenter;
- (bool)containsPoint:(CGPoint)point;
@end
