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
    Alarm *selectedAlarm;
    
    //copy of selected alarm
    Alarm *backedUpAlarm;
    
    AlarmDetailViewController * alarmDetailViewController;
}

@property (nonatomic, strong) NSMutableArray *alarmsList;
@property (nonatomic, strong) Alarm *selectedAlarm;
@property (nonatomic, copy) Alarm *backedUpAlarm;


- (void)populateCell:(UITableViewCell *)cell withAlarm:(Alarm *)alarm;
- (void)createNewAlarm:(id)sender;
- (void)editSelectedAlarm;
- (IBAction)toggleOnSwitch:(id)sender;
- (void)cancelFromAlarmDetailViewController:(id)sender;
- (void)saveFromAlarmDetailViewController:(id)sender;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

