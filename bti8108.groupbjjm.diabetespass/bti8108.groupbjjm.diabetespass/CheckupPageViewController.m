//
//  CheckupPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//  Controller for main view on the start screen with overview of the different, latest values

#import "CheckupPageViewController.h"
#import "CheckupViewController.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"

@interface CheckupPageViewController ()

@end

@implementation CheckupPageViewController

//@synthesize checkupViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _OverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _OverlayButton.frame = CGRectMake(00.0, 00.0, 320.0, 600.0);
    [_OverlayButton setFrame:CGRectMake(0,20,applicationFrame.size.width,applicationFrame.size.height)];
    [_OverlayButton setImage:[UIImage imageNamed:@"Homeansicht"] forState:UIControlStateNormal];
    _OverlayButton.adjustsImageWhenHighlighted = NO;
    [_OverlayButton addTarget:self action:@selector(buttonPushed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OverlayButton];
    _OverlayButton.hidden = YES;
    
   // ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
   // self.checkupViewController = delegate.checkupViewController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**Overlay function - remove the overlay when the user clicks somewhere*/
- (void) buttonPushed:(id)sender
{
    _OverlayButton.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showOverlay:(id)sender {
    _OverlayButton.hidden = NO;
}


- (IBAction)goToTargetValues:(id)sender {
    
    
}


- (IBAction)goToGlucosePre:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    BasePageViewController *startingViewController = [delegate.checkupViewController.controllers objectAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    
    [delegate.checkupViewController.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (IBAction)goToGlucosePost:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    BasePageViewController *startingViewController = [delegate.checkupViewController.controllers objectAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    
    [delegate.checkupViewController.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)goToPressure:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    BasePageViewController *startingViewController = [delegate.checkupViewController.controllers objectAtIndex:2];
    NSArray *viewControllers = @[startingViewController];
    
    [delegate.checkupViewController.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (IBAction)goToWeight:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    BasePageViewController *startingViewController = [delegate.checkupViewController.controllers objectAtIndex:4];
    NSArray *viewControllers = @[startingViewController];
    
    [delegate.checkupViewController.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (IBAction)goToPulse:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    BasePageViewController *startingViewController = [delegate.checkupViewController.controllers objectAtIndex:3];
    NSArray *viewControllers = @[startingViewController];
    
    [delegate.checkupViewController.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}
- (IBAction)addDiaryEntry:(id)sender {
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.navigationFromCheckupView = TRUE;
    [delegate.tabbarViewController setSelectedIndex:1];

}

- (IBAction)addNewDiaryEntry:(id)sender {
    
}


@end
