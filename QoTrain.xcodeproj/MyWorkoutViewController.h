//
//  MyWorkoutViewController.h
//  QoTrain
//
//  Created by Joshua Newman on 5/5/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cocoafish.h"

extern NSString * const kMyWorkoutViewDismissedLoginView;

@class CCNetworkManager;

@interface MyWorkoutViewController : UIViewController <CCNetworkManagerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIButton *workoutButton;
@property (nonatomic, retain) IBOutlet UIButton *medalsButton;
@property (nonatomic, retain) IBOutlet UIButton *caloriesButton;
@property (nonatomic, retain) UILabel *workoutsLabel;
@property (nonatomic, retain) UILabel *medalsLabel;
@property (nonatomic, retain) UILabel *caloriesLabel;
@property (nonatomic, retain) CCNetworkManager *networkManager;

@end
