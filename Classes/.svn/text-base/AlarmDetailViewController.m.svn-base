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

@implementation AlarmDetailViewController

@synthesize repeatCell, soundCell, snoozeCell, nameCell;  
@synthesize myTableView, datePicker, currentAlarm;


#pragma mark -
#pragma mark View and init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //load options table
	[self.myTableView reloadData];	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

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
    
    //update date picker
    [datePicker setDate:currentAlarm.date animated:NO];

}

- (id)init{
    [super init];
	//initialize alarm for this view
	currentAlarm = [[Alarm alloc] init];
    [self initCells];
	return self;
}

- (void)initCells {
    repeatCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    repeatCell.textLabel.text = @"Repeat";
    repeatCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    soundCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    soundCell.textLabel.text = @"Sound";
    soundCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    snoozeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    snoozeCell.textLabel.text = @"Snooze";
    snoozeCell.detailTextLabel.text = @"On/Off";
    snoozeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    nameCell.textLabel.text = @"Name";
    nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController *viewController = nil;
	switch (indexPath.row) {
		case 0:
            viewController = [[RepeatDetailViewController alloc] initWithAlarm:currentAlarm];
			break;
		case 1:				
			//viewController = [[SoundViewController alloc] init];
			break;
		case 3:
			viewController = [[NameDetailViewController alloc] initWithAlarm:currentAlarm];
			break;
	}
	
	//push new view onto the stack
	[self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark -
#pragma mark Table view data source


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			return repeatCell;
        case 1:				
			return soundCell;
		case 2:
			return snoozeCell;
		case 3:
			return nameCell;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

#pragma mark -
#pragma mark Target action

- (void)setDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
        
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                    |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *pickerComps = [calendar components:unitFlags fromDate:datePicker.date];
    currentAlarm.date = [calendar dateFromComponents:pickerComps];
}

- (void)updateAlarm {
    NSLog(@"[Updating Alarm]");
    currentAlarm.sound = soundCell.detailTextLabel.text;
    currentAlarm.name = nameCell.detailTextLabel.text;
    [self setDate];
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

- (void)dealloc {
    NSLog(@"Alarm Detail View Controller Dealloc Called");
    
    [currentAlarm release];
    [repeatCell release];
    [soundCell release];
    [snoozeCell release];
    [nameCell   release];
    
    [super dealloc];
}


/*
- (id)initWithAlarm:(Alarm *)alarm{
    [super init];
    
	currentAlarm = alarm;
	NSLog(@"current alarm %@", [self.currentAlarm time]);
	[self.datePicker setDate:alarm.time animated: NO];
	
	[self.myTableView reloadData];	

	//update alarm name label
	UILabel *name = (UILabel *)[nameCell viewWithTag:1];
	name.text = currentAlarm.name;
	
	UILabel *repeat = (UILabel *)[repeatCell viewWithTag:1];
	repeat.text = currentAlarm.repeat;
	
	self.soundCell.textLabel.text = @"Penis";//currentAlarm.sound;
	
	//UISwitch *onSwitch = (UISwitch *)[snoozeCell viewWithTag:2];
	//onSwitch.state = currentAlarm.snooze;
	
	self.nameCell.textLabel.text = currentAlarm.name;
	
	return self;
}
*/

@end
