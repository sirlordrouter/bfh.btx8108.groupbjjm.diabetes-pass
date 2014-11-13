//
//  CheckupViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckupPageViewController.h"
#import "BlutzuckerPageViewController.h"
#import "BlutdruckPageViewController.h"
#import "PulsPageViewController.h"
#import "GewichtPageViewController.h"

@interface CheckupViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *controllers;
@end
