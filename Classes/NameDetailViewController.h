//
//  NameDetailViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 8/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface NameDetailViewController : UIViewController

@property (nonatomic, strong) Alarm *currentAlarm;
@property (nonatomic, strong) IBOutlet UITextField *textField;

- (id)initWithAlarm:(Alarm *)alarm;
- (IBAction)setName:(id)sender;

@end
