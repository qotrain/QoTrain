//
//  LoginViewController.h
//  qotrain
//
//  Created by Joshua Newman on 3/31/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {
    NSURLConnection *_loginConnection;
}
@property (nonatomic, retain) IBOutlet UIView *signUpView;
@property (nonatomic, retain) IBOutlet UIScrollView *lscrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *sscrollView;
@property (nonatomic, retain) IBOutlet UINavigationBar *loginNavBar;
@property (nonatomic, retain) IBOutlet UINavigationBar *registerNavBar;
@property (nonatomic, retain) IBOutlet UITextField *lusernameField;
@property (nonatomic, retain) IBOutlet UITextField *lpasswordField;
@property (nonatomic, retain) IBOutlet UITextField *susernameField;
@property (nonatomic, retain) IBOutlet UITextField *spasswordField;
@property (nonatomic, retain) IBOutlet UITextField *srepasswordField;
@property (nonatomic, retain) IBOutlet UITextField *semailField;
@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton;
@property (nonatomic, retain) IBOutlet UIButton *rememberPassword;
@property (nonatomic, retain) NSURLConnection *loginConnection;

@end
