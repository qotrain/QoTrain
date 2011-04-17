//
//  LoginViewController.h
//  qotrain
//
//  Created by Joshua Newman on 3/31/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    
}
@property (nonatomic, retain) IBOutlet UIView *signUpView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITextField *lusernameField;
@property (nonatomic, retain) IBOutlet UITextField *lpasswordField;
@property (nonatomic, retain) IBOutlet UITextField *susernameField;
@property (nonatomic, retain) IBOutlet UITextField *spasswordField;
@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton;
@property (nonatomic, retain) IBOutlet UIButton *rememberPassword;

@end
