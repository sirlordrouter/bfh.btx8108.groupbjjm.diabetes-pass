//
//  SettingsPageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Saskia Basler on 15/11/14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsPageViewController : UITableViewController


@property IBOutlet UITableViewCell *morningCell;
@property IBOutlet UIDatePicker *morningDatePicker;
@property IBOutlet UITableViewCell *morningDatePickerCell;

@property (nonatomic, assign, getter=isDateOpen) BOOL dateOpen;

@property IBOutlet UILabel *typLabel;
@property IBOutlet UILabel *therapieLabel;



@end
