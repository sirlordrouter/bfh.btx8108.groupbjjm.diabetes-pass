//
//  MainTabViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//  Main Frame for the app, provides the 4 tabs on the bottom of the app with home, diary, schema and settings

#import "MainTabViewController.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Give a reference to the application contex, used for navigation purposes from the home screem
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.tabbarViewController = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    return YES;
}

@end
