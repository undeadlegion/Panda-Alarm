//
//  RootViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 8/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;
@class AlarmDetailViewController;

@interface RootViewController : UITableViewController {

    //list of alarm objects
    NSMutableArray * alarmsList;
    
    //alarm selected from tableview
    Alarm *modifiedAlarm;
    
    //copy of selected alarm
    Alarm *originalAlarm;
    
    AlarmDetailViewController * alarmDetailViewController;
}

@property (nonatomic, strong) NSMutableArray *alarmsList;
@property (nonatomic, strong) Alarm *modifiedAlarm;
@property (nonatomic, strong) Alarm *originalAlarm;


- (void)populateCell:(UITableViewCell *)cell withAlarm:(Alarm *)alarm;
- (void)createNewAlarm:(id)sender;
- (void)editSelectedAlarm:(Alarm *)selectedAlarm;
- (IBAction)toggleOnSwitch:(id)sender;
- (void)cancelFromAlarmDetailViewController:(id)sender;
- (void)saveFromAlarmDetailViewController:(id)sender;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

