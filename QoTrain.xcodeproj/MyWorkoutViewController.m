//
//  MyWorkoutViewController.m
//  QoTrain
//
//  Created by Joshua Newman on 5/5/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "MyWorkoutViewController.h"
#import "LoginViewController.h"
#import "QoTrainAppDelegate.h"

NSString * const kMyWorkoutViewDismissedLoginView = @"kMyWorkoutViewDismissedLoginView";

@interface MyWorkoutViewController ()
- (void)showButtons:(NSNotification*)aNotification;
- (void)logoutClicked:(id)sender;
@end

@implementation MyWorkoutViewController

@synthesize workoutButton;
@synthesize medalsButton;
@synthesize caloriesButton;
@synthesize workoutsLabel;
@synthesize medalsLabel;
@synthesize caloriesLabel;
@synthesize networkManager = _networkManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"My Workout";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showButtons:) name:kMyWorkoutViewDismissedLoginView object:nil];
    
    UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutClicked:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyWorkoutViewDismissedLoginView object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.workoutButton.alpha = 0.0;
    self.caloriesButton.alpha = 0.0;
    self.medalsButton.alpha = 0.0;

    [(qotrainAppDelegate*)[[UIApplication sharedApplication] delegate] performSelector:@selector(hideSplashScreen) withObject:nil afterDelay:0.2];
    
    CCUser *currentUser = [[Cocoafish defaultCocoafish] getCurrentUser];

    if (!currentUser) {
        LoginViewController *loginViewController = [[[LoginViewController alloc] initWithNibName:[[LoginViewController class] description] bundle:nil] autorelease];
        [self presentModalViewController:loginViewController animated:NO];
    }
    
    UIImageView *workoutButtonImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Road.png"]] autorelease];
    [self.workoutButton addSubview:workoutButtonImage];
    UIImageView *medalsButtonImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Clock.png"]] autorelease];
    [self.medalsButton addSubview:medalsButtonImage];
    UIImageView *caloriesButtonImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fire.png"]] autorelease];
    [self.caloriesButton addSubview:caloriesButtonImage];
    
    self.workoutsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 65)] autorelease];
    self.workoutsLabel.backgroundColor = [UIColor clearColor];
    self.workoutsLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:60];
    self.workoutsLabel.textColor = [UIColor whiteColor];
    self.workoutsLabel.text = @"0";
    self.workoutsLabel.textAlignment = UITextAlignmentRight;
    UILabel *workoutsDescription = [[[UILabel alloc] initWithFrame:CGRectMake(205, 20, 80, 65)] autorelease];
    workoutsDescription.backgroundColor = [UIColor clearColor];
    workoutsDescription.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    workoutsDescription.textColor = [UIColor whiteColor];
    workoutsDescription.text = @"workouts";
    [self.workoutButton addSubview:self.workoutsLabel];
    [self.workoutButton addSubview:workoutsDescription];

    self.medalsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 65)] autorelease];
    self.medalsLabel.backgroundColor = [UIColor clearColor];
    self.medalsLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:60];
    self.medalsLabel.textColor = [UIColor whiteColor];
    self.medalsLabel.text = @"0";
    self.medalsLabel.textAlignment = UITextAlignmentRight;
    UILabel *medalsDescription = [[[UILabel alloc] initWithFrame:CGRectMake(205, 20, 80, 65)] autorelease];
    medalsDescription.backgroundColor = [UIColor clearColor];
    medalsDescription.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    medalsDescription.textColor = [UIColor whiteColor];
    medalsDescription.text = @"medals";
    [self.medalsButton addSubview:self.medalsLabel];
    [self.medalsButton addSubview:medalsDescription];

    self.caloriesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 65)] autorelease];
    self.caloriesLabel.backgroundColor = [UIColor clearColor];
    self.caloriesLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:60];
    self.caloriesLabel.textColor = [UIColor whiteColor];
    self.caloriesLabel.text = @"0";
    self.caloriesLabel.textAlignment = UITextAlignmentRight;
    UILabel *caloriesDescription = [[[UILabel alloc] initWithFrame:CGRectMake(205, 20, 80, 65)] autorelease];
    caloriesDescription.backgroundColor = [UIColor clearColor];
    caloriesDescription.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    caloriesDescription.textColor = [UIColor whiteColor];
    caloriesDescription.text = @"calories";
    [self.caloriesButton addSubview:self.caloriesLabel];
    [self.caloriesButton addSubview:caloriesDescription];
    
    if (_networkManager == nil) {
		_networkManager = [[CCNetworkManager alloc] initWithDelegate:self];
	}
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

- (void)showButtons:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        [self.workoutButton setAlpha:1.0];
        [self.medalsButton setAlpha:1.0];
        [self.caloriesButton setAlpha:1.0];
    } completion:nil];
}

- (void)logoutClicked:(id)sender {
    [self.networkManager logout];
}

#pragma mark -

- (void)didLogout:(CCNetworkManager *)networkManager
{	
	// show login window
	LoginViewController *loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
	[self presentModalViewController:loginViewController animated:YES];	
}

- (void)networkManager:(CCNetworkManager *)networkManager didFailWithError:(NSError *)error
{
	NSString *msg = [NSString stringWithFormat:@"%@.",[error localizedDescription]];
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Error" 
						  message:msg
						  delegate:self 
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
