//
//  ch_bfh_bti8108_groupbjjmAppDelegate.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 18.09.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsWithingsViewController.h"
#import "CheckupViewController.h"

@interface ch_bfh_bti8108_groupbjjmAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SettingsWithingsViewController *withingsController;
@property (nonatomic, strong) CheckupViewController *checkupViewController;
@end
