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
@property (strong, nonatomic) NSDateFormatter *morningDateFormatter;
@property (strong, nonatomic) NSDate *selectedMorningTime;

@property IBOutlet UITableViewCell *middayCell;
@property IBOutlet UIDatePicker *middayDatePicker;
@property IBOutlet UITableViewCell *middayDatePickerCell;
@property (strong, nonatomic) NSDateFormatter *middayDateFormatter;
@property (strong, nonatomic) NSDate *selectedMiddayTime;

@property IBOutlet UITableViewCell *eveningCell;
@property IBOutlet UIDatePicker *eveningDatePicker;
@property IBOutlet UITableViewCell *eveningDatePickerCell;
@property (strong, nonatomic) NSDateFormatter *eveningDateFormatter;
@property (strong, nonatomic) NSDate *selectedEveningTime;

@property IBOutlet UITableViewCell *nightCell;
@property IBOutlet UIDatePicker *nightDatePicker;
@property IBOutlet UITableViewCell *nightDatePickerCell;
@property (strong, nonatomic) NSDateFormatter *nightDateFormatter;
@property (strong, nonatomic) NSDate *selectedNightTime;

@property (assign) BOOL datePickerIsShowing;

@property (nonatomic, assign, getter=isMorningDateOpen) BOOL morningDateOpen;
@property (nonatomic, assign, getter=isMiddayDateOpen) BOOL middayDateOpen;
@property (nonatomic, assign, getter=isEveningDateOpen) BOOL eveningDateOpen;
@property (nonatomic, assign, getter=isNightDateOpen) BOOL nightDateOpen;

@property IBOutlet UILabel *typLabel;
@property IBOutlet UILabel *therapieLabel;
@property IBOutlet UILabel *morningtimeLabel;
@property IBOutlet UILabel *middaytimeLabel;
@property IBOutlet UILabel *eveningtimeLabel;
@property IBOutlet UILabel *nighttimeLabel;



@end
