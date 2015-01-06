//
//  TagebucheintraegePageViewController.h
//  bti8108.groupbjjm.diabetespass
//
//  Created by Meryam M on 27.11.14.
//  Edited by Johannes Gnägi on 05-01-2015
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#ifndef bti8108_groupbjjm_diabetespass_TagebucheintraegePageViewController_h
#define bti8108_groupbjjm_diabetespass_TagebucheintraegePageViewController_h


#endif

#import <UIKit/UIKit.h>
#import "WeightPickerView.h"

@interface TagebucheintraegePageViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>



@property (strong, nonatomic) NSDateFormatter *DatumDateFormatter;
@property (strong, nonatomic) NSDate *selectedDatumDate;

@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL PickerViewIsShowing;

@property (nonatomic, assign, getter=isDatumDateOpen) BOOL DatumDateOpen;
@property(nonatomic, readonly, getter=isEditing) BOOL editing;

@property IBOutlet UITableViewCell *GewichtCell;
@property IBOutlet WeightPickerView *GewichtPickerView;
@property IBOutlet UITableViewCell *GewichtPickerViewCell;

@property IBOutlet UILabel *DatumDateLabel;
@property IBOutlet UILabel *GewichtLabel;
@property IBOutlet UITextField *GlucoseField;
@property IBOutlet UITextField *BlutzuckerField;
@property IBOutlet UITextField *HbA1cField;
@property IBOutlet UITableViewCell *DatumCell;
@property IBOutlet UIDatePicker *DatumDatePicker;
@property IBOutlet UITableViewCell *DatumDatePickerCell;
@property (weak, nonatomic) IBOutlet UITextField *PulsLabel;

@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *glucoseIsBeforeMeal;

@property BOOL glucoseIsBeforeMealBool;


@end