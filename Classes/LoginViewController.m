//
//  LoginViewController.m
//  qotrain
//
//  Created by Joshua Newman on 3/31/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "LoginViewController.h"
#import "QoTrainAppDelegate.h"
#import "MyWorkoutViewController.h"

@interface LoginViewController ()
@property (nonatomic, assign) BOOL registerScreenShowing;
- (void)loginClicked:(id)sender;
- (void)backButtonClicked:(id)sender;
- (IBAction)registerClicked:(id)sender;
- (IBAction)signUpClicked:(id)sender;
- (IBAction)checkboxButton:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (void)hideStartScreen;
- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;
- (void)textFieldDidChange:(NSNotification*)aNotification;
@end

@implementation LoginViewController

@synthesize signUpView;
@synthesize lscrollView;
@synthesize sscrollView;
@synthesize lusernameField;
@synthesize lpasswordField;
@synthesize susernameField;
@synthesize spasswordField;
@synthesize srepasswordField;
@synthesize semailField;
@synthesize loginButton;
@synthesize backButton;
@synthesize registerButton;
@synthesize signUpButton;
@synthesize loginNavBar;
@synthesize registerNavBar;
@synthesize rememberPassword;
@synthesize registerScreenShowing;
@synthesize networkManager = _networkManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (_networkManager == nil) {
            _networkManager = [[CCNetworkManager alloc] initWithDelegate:self];
        }
    }
    return self;
}

- (void)dealloc
{
    [signUpView release];
    [lscrollView release];
    [sscrollView release];
    [lusernameField release];
    [lpasswordField release];
    [susernameField release];
    [spasswordField release];
    [srepasswordField release];
    [semailField release];
    [loginButton release];
    [registerButton release];
    [signUpButton release];
    [loginNavBar release];
    [registerNavBar release];
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

- (void)viewWillAppear:(BOOL)animated
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if (username && password) {
        self.lusernameField.text = username;
        self.lpasswordField.text = password;
        self.rememberPassword.selected = YES;
        self.loginButton.enabled = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(hideStartScreen) withObject:nil afterDelay:0.5];
    self.lusernameField.delegate = self;
    self.lpasswordField.delegate = self;
    self.spasswordField.delegate = self;
    self.susernameField.delegate = self;
    self.srepasswordField.delegate = self;
    self.semailField.delegate = self;
    
    self.lscrollView.contentSize = CGSizeMake(320, 416);
    self.sscrollView.contentSize = self.lscrollView.contentSize;
    
    UINavigationItem *loginNavigationItem = [[[UINavigationItem alloc] initWithTitle:@"Welcome"] autorelease];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setImage:[UIImage imageNamed:@"Login_Orange.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    [loginNavigationItem setRightBarButtonItem:self.loginButton];
    [self.loginNavBar setItems:[NSArray arrayWithObject:loginNavigationItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    self.loginButton.enabled = NO;
    self.registerButton.enabled = NO;
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
    [self.networkManager login:self.lusernameField.text password:self.lpasswordField.text];
}

- (IBAction)signUpClicked:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self view] cache:YES];
    [self.lusernameField resignFirstResponder];
    [self.lpasswordField resignFirstResponder];
    [self.view addSubview:signUpView];
    [UIView commitAnimations];
    
    UINavigationItem *regNavigationItem = [[[UINavigationItem alloc] initWithTitle:@"Create Account"] autorelease];
    UIBarButtonItem *backToLoginButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked:)] autorelease];
    [regNavigationItem setLeftBarButtonItem:backToLoginButton];
    [self.registerNavBar setItems:[NSArray arrayWithObject:regNavigationItem]];
    
    self.registerScreenShowing = YES;
}

- (IBAction)registerClicked:(id)sender
{
    if ([susernameField.text isEqualToString:@""] || [spasswordField.text isEqualToString:@""]) {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter both username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        [alertsuccess release];
        return;
    }

    // create a mutable user object
    CCMutableUser *newUser = [[[CCMutableUser alloc] init] autorelease];
    newUser.email = self.semailField.text;
    newUser.username = self.susernameField.text;
    
    // register the user
    [self.networkManager registerUser:newUser password:self.spasswordField.text passwordConfirmation:self.srepasswordField.text];
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
    if (registerScreenShowing) {
        [self.susernameField resignFirstResponder];
        [self.spasswordField resignFirstResponder];
        [self.srepasswordField resignFirstResponder];
        [self.semailField resignFirstResponder];
    } else {
        [self.lpasswordField resignFirstResponder];
        [self.lusernameField resignFirstResponder];
    }
}

- (void)backButtonClicked:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];
    [signUpView removeFromSuperview];
    [UIView commitAnimations];
    
    self.registerScreenShowing = NO;
}

# pragma mark - 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.enablesReturnKeyAutomatically = YES;
    BOOL passwordEqual;

    if (registerScreenShowing) {
        if (((textField == self.susernameField && ![self.spasswordField.text isEqualToString:@""] &&
             ![self.srepasswordField.text isEqualToString:@""] && ![self.semailField.text isEqualToString:@""]) || 
            (textField == self.spasswordField && ![self.susernameField.text isEqualToString:@""] &&
             ![self.srepasswordField.text isEqualToString:@""] && ![self.semailField.text isEqualToString:@""]) ||
            (textField == self.srepasswordField && ![self.susernameField.text isEqualToString:@""] &&
             ![self.spasswordField.text isEqualToString:@""] && ![self.semailField.text isEqualToString:@""]) ||
            (textField == self.semailField && ![self.susernameField.text isEqualToString:@""] &&
             ![self.spasswordField.text isEqualToString:@""] && ![self.srepasswordField.text isEqualToString:@""]))
            && passwordEqual) {
            textField.returnKeyType = UIReturnKeyGo;
        } else {
            textField.returnKeyType = UIReturnKeyNext;
        }
    } else {
        if ((textField == self.lusernameField && ![self.lpasswordField.text isEqualToString:@""]) || 
            textField == self.lpasswordField && ![self.lusernameField.text isEqualToString:@""]) {
            textField.returnKeyType = UIReturnKeyGo;
        } else {
            textField.returnKeyType = UIReturnKeyNext;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        if (registerScreenShowing) {
            if ([self.spasswordField.text isEqualToString:self.srepasswordField.text]) {
                [self registerClicked:nil];
            } else {
                UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords do not match. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertsuccess show];
                [alertsuccess release];
            }
        } else {
            [self loginClicked:nil];
        }
    } else {
        if (registerScreenShowing) {
            if (![self.susernameField.text isEqualToString:@""] && ![self.spasswordField.text isEqualToString:@""] && ![self.srepasswordField.text isEqualToString:@""] && ![self.semailField.text isEqualToString:@""]) {
                [self.srepasswordField becomeFirstResponder];
            } else if ([self.susernameField.text isEqualToString:@""]) {
                [self.susernameField becomeFirstResponder];
            } else if ([self.spasswordField.text isEqualToString:@""]) {
                [self.spasswordField becomeFirstResponder];
            } else if ([self.srepasswordField.text isEqualToString:@""]) {
                [self.srepasswordField becomeFirstResponder];
            } else {
                [self.semailField becomeFirstResponder];
            }
        } else {
            if ([self.lusernameField.text isEqualToString:@""]) {
                [self.lusernameField becomeFirstResponder];
            } else {
                [self.lpasswordField becomeFirstResponder];
            }
        }
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    CGRect scrollViewFrame;
    if (registerScreenShowing) {
        scrollViewFrame = self.sscrollView.frame;
    } else {
        scrollViewFrame = self.lscrollView.frame;
    }
    scrollViewFrame.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (registerScreenShowing) {
        [self.sscrollView setFrame:scrollViewFrame];
    } else {
        [self.lscrollView setFrame:scrollViewFrame];
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    CGRect scrollViewFrame;
    if (registerScreenShowing) {
        scrollViewFrame = self.sscrollView.frame;
    } else {
        scrollViewFrame = self.lscrollView.frame;
    }
    scrollViewFrame.size.height += keyboardSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (registerScreenShowing) {
        [self.sscrollView setFrame:scrollViewFrame];
    } else {
        [self.lscrollView setFrame:scrollViewFrame];
    }
    [UIView commitAnimations];
}

- (void)textFieldDidChange:(NSNotification*)aNotification {
    if (registerScreenShowing) {
        if ([self.spasswordField.text isEqualToString:self.srepasswordField.text]) {
            self.srepasswordField.textColor = [UIColor blackColor];
        } else {
            self.srepasswordField.textColor = [UIColor redColor];
        }
        if ([self.susernameField.text isEqualToString:@""] || [self.spasswordField.text isEqualToString:@""]
               || [self.srepasswordField.text isEqualToString:@""] || [self.semailField.text isEqualToString:@""]) {
            self.registerButton.enabled = NO;
        } else {
            if (self.spasswordField.text == self.srepasswordField.text) {
                self.registerButton.enabled = YES;
            }
        }
    } else {
        while ([self.lusernameField.text isEqualToString:@""] || [self.lpasswordField.text isEqualToString:@""]) {
            self.loginButton.enabled = NO;
            return;
        }
        self.loginButton.enabled = YES;
    }
}

# pragma mark - 

-(void)networkManager:(CCNetworkManager *)networkManager didCreate:(NSArray *)objectArray objectType:(Class)objectType {
    if (objectType == [CCUser class]) {
        CCUser *user = [objectArray objectAtIndex:0];
        NSLog(@"didRegisterUser %@", user);
        [self.parentViewController dismissModalViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyWorkoutViewDismissedLoginView object:nil];
    }
}

-(void)networkManager:(CCNetworkManager *)networkManager didLogin:(CCUser *)user
{
    if (self.rememberPassword.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:self.lusernameField.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.lpasswordField.text forKey:@"password"];
    }
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyWorkoutViewDismissedLoginView object:nil];
}

-(void)networkManager:(CCNetworkManager *)networkManager didFailWithError:(NSError *)error
{
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    [alertsuccess release];
}

@end
