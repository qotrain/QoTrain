//
//  LoginViewController.m
//  qotrain
//
//  Created by Joshua Newman on 3/31/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "LoginViewController.h"
#import "qotrainAppDelegate.h"

@interface LoginViewController ()
- (void)loginClicked:(id)sender;
- (IBAction)registerClicked:(id)sender;
- (IBAction)signUpClicked:(id)sender;
- (IBAction)checkboxButton:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (void)hideStartScreen;
@end

@implementation LoginViewController

@synthesize signUpView;
@synthesize lusernameField;
@synthesize lpasswordField;
@synthesize susernameField;
@synthesize spasswordField;
@synthesize loginButton;
@synthesize registerButton;
@synthesize signUpButton;
@synthesize navBar;
@synthesize rememberPassword;

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
    [signUpView release];
    [lusernameField release];
    [lpasswordField release];
    [susernameField release];
    [spasswordField release];
    [loginButton release];
    [registerButton release];
    [signUpButton release];
    [navBar release];
    [rememberPassword release];
    [super dealloc];
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
    [self performSelector:@selector(hideStartScreen) withObject:nil afterDelay:0.5];
    self.lusernameField.delegate = self;
    self.lpasswordField.delegate = self;
    self.spasswordField.delegate = self;
    self.susernameField.delegate = self;
    
    UINavigationItem *loginNavigationItem = [[[UINavigationItem alloc] initWithTitle:@"Welcome"] autorelease];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setImage:[UIImage imageNamed:@"Login_Orange.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    [loginNavigationItem setRightBarButtonItem:self.loginButton];
    [self.navBar setItems:[NSArray arrayWithObject:loginNavigationItem]];
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

# pragma mark -

- (void)hideStartScreen
{
    [(qotrainAppDelegate*)[[UIApplication sharedApplication] delegate] hideSplashScreen];
}

- (void)loginClicked:(id)sender
{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",lusernameField.text, lpasswordField.text];
    NSString *hostStr = @"http://qotrain.com/login.php?";
    hostStr = [hostStr stringByAppendingString:post];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:hostStr]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];

    if([serverOutput isEqualToString:@"Success"]){
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username or password. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        [alertsuccess release];
        self.lpasswordField.text = nil;
    }
}

- (IBAction)signUpClicked:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self view] cache:YES];
    [self.view addSubview:signUpView];
    [UIView commitAnimations];
}

- (IBAction)registerClicked:(id)sender
{
    if ([susernameField.text isEqualToString:@""] || [spasswordField.text isEqualToString:@""]) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter both username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        [alertsuccess release];
        return;
    }

    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",susernameField.text, spasswordField.text];
    NSString *hostStr = @"http://qotrain.com/create.php?";
    hostStr = [hostStr stringByAppendingString:post];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:hostStr]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    
    if([serverOutput isEqualToString:@"Success"]){
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username already exists. Please choose a different username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        [alertsuccess release];
    }
}

- (IBAction)checkboxButton:(id)sender{
    if (!self.rememberPassword.selected){
        [self.rememberPassword setSelected:YES];
    } else {
        [self.rememberPassword setSelected:NO];
    }
}

-(IBAction)backgroundClick:(id)sender
{
    [self.lpasswordField resignFirstResponder];
    [self.lusernameField resignFirstResponder];
}

# pragma mark - 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.lusernameField || textField == self.susernameField) {
        textField.returnKeyType = UIReturnKeyNext;
    } else if (textField == self.lpasswordField || textField == self.spasswordField) {
        textField.returnKeyType = UIReturnKeyGo;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.lpasswordField) {
        [self loginClicked:nil];
    } else {
        [self registerClicked:nil];
    }
    return YES;
}

@end
