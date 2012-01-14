//
//  RepeatDetailViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 8/9/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface RepeatDetailViewController : UITableViewController {

    Alarm *currentAlarm;
}


- (id)initWithAlarm:(Alarm *)alarm;

@end