//
//  Class.m
//  qotrain
//
//  Created by Joshua Newman on 3/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "MyWorkoutTableViewController.h"
#import "WorkoutDetailViewController.h"
#import "qotrainAppDelegate.h"
#import "LoginViewController.h"

@interface MyWorkoutTableViewController ()
@property (nonatomic, retain) LoginViewController *loginViewController;
@end

@implementation MyWorkoutTableViewController

@synthesize workoutTableView;
@synthesize detailViewController=_detailViewController;
@synthesize loginViewController=_loginViewController;

- (void)dealloc
{
    [super dealloc];
    [_detailViewController release];
    _detailViewController=nil;
    [_loginViewController release];
    _loginViewController=nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"My Workout";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    _loginViewController = [[LoginViewController alloc] initWithNibName:[[LoginViewController class] description] bundle:nil];
    [self presentModalViewController:self.loginViewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Jogging";
            break;
        case 1:
            cell.textLabel.text = @"Cycling";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.detailViewController == nil) {
        WorkoutDetailViewController *viewController = [[[WorkoutDetailViewController alloc] initWithNibName:[[WorkoutDetailViewController class] description] bundle:nil] autorelease];
        self.detailViewController = viewController;
    }
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            self.detailViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [((qotrainAppDelegate*)[[UIApplication sharedApplication] delegate]).myWorkoutNavController pushViewController:self.detailViewController animated:YES];
            break;
        default:
            break;
    }
}

@end
