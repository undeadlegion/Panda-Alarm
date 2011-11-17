//
//  NameDetailViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 8/18/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "NameDetailViewController.h"
#import "Alarm.h"

@implementation NameDetailViewController

//@synthesize textField;

- (id) initWithAlarm:(Alarm *)alarm{
    self = [super initWithNibName:@"NameDetailViewController" bundle:nil];
    currentAlarm = alarm;
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    textField.text = currentAlarm.name;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

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


- (IBAction)setName:(id)sender{
    currentAlarm.name = textField.text;
//    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}




@end
