//
//  qotrainAppDelegate.h
//  qotrain
//
//  Created by Joshua Newman on 3/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qotrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIImageView *_splashScreen;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UINavigationController *myWorkoutNavController;

@property (nonatomic, retain) IBOutlet UINavigationController *communityNavController;

@property (nonatomic, retain) UIImageView *splashScreen;

- (void)hideSplashScreen;

@end
