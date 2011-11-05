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

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) Alarm *currentAlarm;

//cells
@property (nonatomic, strong) UITableViewCell *repeatCell;
@property (nonatomic, strong) UITableViewCell *soundCell;
@property (nonatomic, strong) UITableViewCell *snoozeCell;
@property (nonatomic, strong) UITableViewCell *nameCell;


- (void) updateAlarm;
//- (id)initWithAlarm:(Alarm *)alarm;
- (id)init;
- (void)initCells;
- (void)updateViewWithCurrentAlarm;

@end
    
