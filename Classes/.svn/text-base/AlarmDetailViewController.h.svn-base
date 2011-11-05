//
//  AlarmViewController.h
//  PandaAlarm
//
//  Created by James Lubowich on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface AlarmDetailViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	//options table
	UITableView *myTableView;
	
	//alarm time
	UIDatePicker *datePicker;
	
	//alarm being represented
	Alarm *currentAlarm;
    
	//alarm options
	UITableViewCell *repeatCell;
	UITableViewCell *soundCell;
	UITableViewCell *snoozeCell;
	UITableViewCell *nameCell;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) Alarm *currentAlarm;

//cells
@property (nonatomic, retain) UITableViewCell *repeatCell;
@property (nonatomic, retain) UITableViewCell *soundCell;
@property (nonatomic, retain) UITableViewCell *snoozeCell;
@property (nonatomic, retain) UITableViewCell *nameCell;


- (void) updateAlarm;
//- (id)initWithAlarm:(Alarm *)alarm;
- (id)init;
- (void)initCells;
- (void)updateViewWithCurrentAlarm;

@end
    
