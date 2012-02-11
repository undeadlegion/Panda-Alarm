//
//  AlarmViewController.m
//  PandaAlarm
//
//  Created by James Lubowich on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"
#import "AlarmDetailViewController.h"
#import "RepeatDetailViewController.h"
#import "NameDetailViewController.h"
#import "DatePickerViewController.h"

@implementation AlarmDetailViewController
@synthesize repeatIntervalSlider, repeatIntervalLabel, extraAlarmsSlider, numberOfAlarmsLabel;
@synthesize myTableView, currentAlarm;
@synthesize beginCell, endCell, numberCell, intervalCell;
@synthesize nameCell, soundCell, repeatCell;
@synthesize reminderCell, snoozeCell, pandaWakeupCell;

#pragma mark -
#pragma mark View and init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load options table
	[self.myTableView reloadData];	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //update cells
    [self updateViewWithCurrentAlarm];
    
    //reload cells
	[self.myTableView reloadData];
}


- (void)updateViewWithCurrentAlarm {
    //update cells
    repeatCell.detailTextLabel.text = [currentAlarm stringFromSelectedDaysOfTheWeek];
    soundCell.detailTextLabel.text = currentAlarm.sound;
    nameCell.detailTextLabel.text = currentAlarm.name;
    //update snooze cell on/off

    extraAlarmsSlider.value = currentAlarm.extraAlarms; 
    [extraAlarmsSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    repeatIntervalSlider.value = currentAlarm.repeatInterval;
    [repeatIntervalSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *timeText = [formatter stringFromDate:currentAlarm.date];
    beginCell.detailTextLabel.text = timeText;
}

- (id)init{
    self = [super init];
	//initialize alarm for this view
	currentAlarm = [[Alarm alloc] init];
    [self initCells];
	return self;
}

- (void)initCells {
	//convert date to string 
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	NSString *timeText = [formatter stringFromDate:currentAlarm.date];
    
    beginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    beginCell.textLabel.text = @"First Alarm";
    beginCell.detailTextLabel.text = timeText;
    beginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    endCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    endCell.textLabel.text = @"Last Alarm";
    endCell.detailTextLabel.text = timeText;
    endCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IntervalCell" owner:self options:nil];
    intervalCell = [topLevelObjects objectAtIndex:0];
    [(UILabel *)[intervalCell viewWithTag:1] setText:@"Interval"];
    repeatIntervalSlider = (UISlider *)[intervalCell viewWithTag:2];
    repeatIntervalLabel = (UILabel *)[intervalCell viewWithTag:3];
    
    repeatIntervalLabel.text = @"1 min";
    repeatIntervalSlider.maximumValue = 20;

    [repeatIntervalSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
   
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IntervalCell" owner:self options:nil];
    numberCell = [topLevelObjects objectAtIndex:0];
    [(UILabel *)[numberCell viewWithTag:1] setText:@"Number"];
    extraAlarmsSlider = (UISlider *)[numberCell viewWithTag:2];
    numberOfAlarmsLabel = (UILabel *)[numberCell viewWithTag:3];

    numberOfAlarmsLabel.text = @"0";
    extraAlarmsSlider.maximumValue = 10;
    extraAlarmsSlider.minimumValue = 0;
    extraAlarmsSlider.value = 0;


    [extraAlarmsSlider addTarget:self action:@selector(numberSliderChanged:) forControlEvents:UIControlEventValueChanged];

    nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    nameCell.textLabel.text = @"Name";
    nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    soundCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    soundCell.textLabel.text = @"Sound";
    soundCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    soundCell.selectionStyle = UITableViewCellSelectionStyleNone;

    repeatCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    repeatCell.textLabel.text = @"Repeat";
    repeatCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    reminderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    reminderCell.textLabel.text = @"Wakeup Reminder";
    reminderCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    reminderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    snoozeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    snoozeCell.textLabel.text = @"Snooze";
    snoozeCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    snoozeCell.selectionStyle = UITableViewCellSelectionStyleNone;

    pandaWakeupCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    pandaWakeupCell.textLabel.text = @"Panda Wakeup";
    pandaWakeupCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    pandaWakeupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)sliderChanged:(id)sender {
    repeatIntervalLabel.text = [NSString stringWithFormat:@"%d min", (int)repeatIntervalSlider.value];
    currentAlarm.repeatInterval = repeatIntervalSlider.value;
}

- (void)numberSliderChanged:(id)sender {
    numberOfAlarmsLabel.text = [NSString stringWithFormat:@"%d", (int)extraAlarmsSlider.value];
    currentAlarm.extraAlarms = extraAlarmsSlider.value;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController *viewController = nil;
	switch (indexPath.section) {
		case 0:
            viewController = [[DatePickerViewController alloc] initWithAlarm:currentAlarm];
            viewController.title = @"First Alarm";
			break;
		case 1:				
			return;
        case 2:
            if (indexPath.row == 0) {
                viewController = [[NameDetailViewController alloc] initWithAlarm:currentAlarm];
            } else if (indexPath.row == 2) {
                viewController = [[RepeatDetailViewController alloc] initWithAlarm:currentAlarm];
            }
            break;
		case 3:
			return;
	}
	
	//push new view onto the stack
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Time";
        case 1:
            return @"Extra Alarms";
        case 2:
            return @"Details";
        case 3:
            return @"Snooze";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 3;
        case 3:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
            if (indexPath.row == 0) {
                return beginCell;
            }
        case 1:
            if (indexPath.row == 0) {
                return numberCell;
            } else if (indexPath.row == 1) {
                return intervalCell;
            }        
        case 2:				
            if (indexPath.row == 0) {
                return nameCell;
            } else if (indexPath.row == 1) {
                return soundCell;
            } else {
                return repeatCell;
            }
            
		case 3:
            if (indexPath.row == 0) {
                return reminderCell;
            } else if (indexPath.row == 1) {
                return snoozeCell;
            } else {
                return pandaWakeupCell;
            }
            
        default:
            NSLog(@"Returning empty cell");
            return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

#pragma mark -
#pragma mark Target action

- (void)saveAlarmSettings {
    NSLog(@"[Saving Alarm Settings]");
    currentAlarm.sound = soundCell.detailTextLabel.text;
    currentAlarm.name = nameCell.detailTextLabel.text;
    currentAlarm.extraAlarms = (NSInteger)extraAlarmsSlider.value;
    currentAlarm.repeatInterval = (NSInteger)repeatIntervalSlider.value;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
