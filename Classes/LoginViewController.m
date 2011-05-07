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
@synthesize loginConnection=_loginConnection;

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
    [_loginConnection release];_loginConnection=nil;
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
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",lusernameField.text, lpasswordField.text];
    NSString *hostStr = @"http://qotrain.com/login.php?";
    hostStr = [hostStr stringByAppendingString:post];
    NSURLRequest *loginRequest  = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:hostStr]] autorelease];
    _loginConnection = [[NSURLConnection alloc] initWithRequest:loginRequest delegate:self];
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

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *serverOutput = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    
    if([serverOutput isEqualToString:@"Success"]){
        if (self.rememberPassword.selected) {
            [[NSUserDefaults standardUserDefaults] setObject:self.lusernameField.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:self.lpasswordField.text forKey:@"password"];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        }
        [self.parentViewController dismissModalViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyWorkoutViewDismissedLoginView object:nil];
    } else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username or password. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        [alertsuccess release];
        self.lpasswordField.text = nil;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertsuccess show];
    [alertsuccess release];
}

@end
