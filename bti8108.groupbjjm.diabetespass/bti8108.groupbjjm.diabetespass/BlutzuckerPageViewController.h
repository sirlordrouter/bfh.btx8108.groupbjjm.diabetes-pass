//
//  BlutzuckerPageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//  View holder for the caroussell view, page glucose

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"

@interface BlutzuckerPageViewController : BasePageViewController

@property (strong, nonatomic) IBOutlet UIView *BlutzuckerView;
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property NSString *titleText;

@end
