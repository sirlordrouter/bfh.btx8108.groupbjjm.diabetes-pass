//
//  CheckupPageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"

@interface CheckupPageViewController : BasePageViewController

@property (strong, nonatomic) IBOutlet UIView *CheckupView;
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property NSString *titleText;

@end
