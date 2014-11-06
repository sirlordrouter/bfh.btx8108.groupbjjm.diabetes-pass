//
//  ch_bfh_bti8108_groupbjjmDetailViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 18.09.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "ch_bfh_bti8108_groupbjjmDetailViewController.h"

@interface ch_bfh_bti8108_groupbjjmDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ch_bfh_bti8108_groupbjjmDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
            _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
            self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
