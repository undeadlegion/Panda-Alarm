//
//  RepeatDetailViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 8/9/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "RepeatDetailViewController.h"
#import "Alarm.h"

@implementation RepeatDetailViewController
@synthesize currentAlarm;

#pragma mark -
#pragma mark View and init

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(id)initWithAlarm:(Alarm *)alarm {
    self = [super initWithNibName:@"RepeatDetailViewController" bundle:nil];
    currentAlarm = alarm;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch(indexPath.row){
        case 0:
            cell.textLabel.text = @"Monday";
            break;
        case 1:
            cell.textLabel.text = @"Tuesday";
            break;
        case 2:
            cell.textLabel.text = @"Wednesday";
            break;
        case 3:
            cell.textLabel.text = @"Thursday";
            break;
        case 4:
            cell.textLabel.text = @"Friday";
            break;
        case 5:
            cell.textLabel.text = @"Saturday";
            break;
        case 6:
            cell.textLabel.text = @"Sunday";
            break;
    }
    
    //dictionary keys are the first 3 letters of the day
    NSString *key = [cell.textLabel.text substringToIndex:3];
    
    //update checkmark based on model
    if([[currentAlarm.selectedDaysOfTheWeek valueForKey:key] boolValue] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //unhighlight selection
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //selected cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //not selected
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        //check alarm and update model
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [currentAlarm.selectedDaysOfTheWeek setValue:[NSNumber numberWithBool:YES] forKey:[cell.textLabel.text substringToIndex:3]];
    }
    //selected
    else{
        //uncheck alarm and update model
        cell.accessoryType = UITableViewCellAccessoryNone;
        [currentAlarm.selectedDaysOfTheWeek setValue:[NSNumber numberWithBool:NO] forKey:[cell.textLabel.text substringToIndex:3]];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

