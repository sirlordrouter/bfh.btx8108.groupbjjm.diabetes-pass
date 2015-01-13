//
//  BasePageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//  Base View holder class for the caroussell view, holding index and other properties used in all caroussel views

#import <UIKit/UIKit.h>

@interface BasePageViewController : UIViewController

@property NSUInteger pageIndex;
- (id) initWithIndex:(NSUInteger *)index;

@end
