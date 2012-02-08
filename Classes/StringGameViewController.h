//
//  StringGameViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringGameViewController : UIViewController

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *vibrateTimer;
@property (nonatomic, assign) NSUInteger level;

@property (nonatomic, strong) IBOutlet UILabel *alphaNumericLabel;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) IBOutlet UIButton *giveUpButton;

- (NSString *)genRandStringLength:(NSUInteger)len;
- (IBAction)textTyped:(id)sender;
- (IBAction)nextWord:(id)sender;
- (void)startGame;
- (void)endGame;
- (void)scheduleNextTimer;
- (void)vibrateFire:(NSTimer *) theTimer;

@end
