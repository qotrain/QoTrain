//
//  Class.h
//  qotrain
//
//  Created by Joshua Newman on 3/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkoutDetailViewController;
@class LoginViewController;

@interface MyWorkoutTableViewController : UITableViewController {
    IBOutlet UITableView *workoutTableView;
    WorkoutDetailViewController *_detailViewController;
    LoginViewController *_loginViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *workoutTableView;
@property (nonatomic, retain) WorkoutDetailViewController *detailViewController;
@end
