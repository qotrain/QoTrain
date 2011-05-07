//
//  MyWorkoutViewController.h
//  QoTrain
//
//  Created by Joshua Newman on 5/5/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMyWorkoutViewDismissedLoginView;

@interface MyWorkoutViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UIButton *workoutButton;
@property (nonatomic, retain) IBOutlet UIButton *medalsButton;
@property (nonatomic, retain) IBOutlet UIButton *caloriesButton;
@property (nonatomic, retain) UILabel *workoutsLabel;
@property (nonatomic, retain) UILabel *medalsLabel;
@property (nonatomic, retain) UILabel *caloriesLabel;

@end
