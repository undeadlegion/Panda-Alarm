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
//	UIDatePicker *datePicker;
	
	//alarm being represented
	Alarm *currentAlarm;
    
    UISlider *repeatIntervalSlider;
    UILabel *repeatIntervalLabel;
    
    UISlider *numberOfAlarmsSlider;
    UILabel *numberOfAlarmsLabel;
    
	//alarm options
    UITableViewCell *beginCell;
    UITableViewCell *endCell;
    UITableViewCell *numberCell;
    UITableViewCell *intervalCell;    
    
    UITableViewCell *nameCell;
	UITableViewCell *soundCell;
	UITableViewCell *repeatCell;
    
    UITableViewCell *reminderCell;
	UITableViewCell *snoozeCell;
    UITableViewCell *pandaWakeupCell;
}

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
//@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) Alarm *currentAlarm;

//cells
@property (nonatomic, strong) UITableViewCell *beginCell;
@property (nonatomic, strong) UITableViewCell *endCell;
@property (nonatomic, strong) UITableViewCell *intervalCell;

@property (nonatomic, strong) UITableViewCell *nameCell;
@property (nonatomic, strong) UITableViewCell *soundCell;
@property (nonatomic, strong) UITableViewCell *repeatCell;

@property (nonatomic, strong) UITableViewCell *reminderCell;
@property (nonatomic, strong) UITableViewCell *snoozeCell;
@property (nonatomic, strong) UITableViewCell *pandaWakeupCell;



//- (void) saveAlarmSettings;
- (void)sliderChanged:(id)sender;
- (void)numberSliderChanged:(id)sender;

//- (id)initWithAlarm:(Alarm *)alarm;
- (id)init;
- (void)initCells;
- (void)updateViewWithCurrentAlarm;
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
    
