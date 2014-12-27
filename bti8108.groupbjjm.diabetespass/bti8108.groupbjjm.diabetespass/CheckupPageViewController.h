//
//  CheckupPageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "CheckupViewController.h"

@interface CheckupPageViewController : BasePageViewController

//@property (nonatomic, strong) CheckupViewController *checkupViewController;

@property (strong, nonatomic) IBOutlet UIView *CheckupView;
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property NSString *titleText;

@property IBOutlet UIButton *OverlayButton;
- (IBAction)showOverlay:(id)sender;

- (IBAction)goToTargetValues:(id)sender;

- (IBAction)goToGlucosePre:(id)sender;
- (IBAction)goToGlucosePost:(id)sender;
- (IBAction)goToPressure:(id)sender;
- (IBAction)goToWeight:(id)sender;
- (IBAction)goToPulse:(id)sender;

- (IBAction)addNewDiaryEntry:(id)sender;






@end
