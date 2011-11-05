//
//  StringGameViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StringGameViewController : UIViewController {
    NSTimer *timer;
    NSTimer *vibrateTimer;
    NSUInteger level;
}

- (NSString *)genRandStringLength:(NSUInteger)len;
@property (nonatomic, retain) IBOutlet UILabel *alphaNumericLabel;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *levelLabel;
@property (nonatomic, retain) IBOutlet UIButton *giveUpButton;

- (IBAction)textTyped:(id)sender;
- (IBAction)nextWord:(id)sender;
- (void)startGame;
- (void)endGame;
- (void)scheduleNextTimer;
- (void)vibrateFire:(NSTimer *) theTimer;

@end
