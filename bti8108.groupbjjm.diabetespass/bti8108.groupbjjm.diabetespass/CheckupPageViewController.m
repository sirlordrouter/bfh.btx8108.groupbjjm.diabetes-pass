//
//  CheckupPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "CheckupPageViewController.h"

@interface CheckupPageViewController ()

@end

@implementation CheckupPageViewController

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
@end
