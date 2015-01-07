//
//  TagebucheintraegePageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Meryam M on 27.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagebucheintraegePageViewController.h"

/// Weight default value.
#define WEIGHT_DEFAULT_VALUE @"75.0"

@interface TagebucheintraegePageViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@end

@interface UITapGestureRecognizer ()

@end


@implementation TagebucheintraegePageViewController
@synthesize DatumCell;
@synthesize DatumDatePicker;
@synthesize DatumDatePickerCell;
@synthesize DatumDateLabel;

@synthesize GewichtCell;
@synthesize GewichtPickerView;
@synthesize GewichtPickerViewCell;

@synthesize GlucoseField;
@synthesize BlutzuckerField;
@synthesize HbA1cField;
@synthesize GewichtLabel;

@synthesize glucoseIsBeforeMeal;
@synthesize glucoseIsBeforeMealBool;



    - (void)viewDidLoad {
        
        [super viewDidLoad];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self setupDatumLabel];
        
        [self.DatumDatePicker setHidden:(YES)];
        
        self.GewichtPickerView = [[WeightPickerView alloc] init];
        [self.GewichtPickerViewCell addSubview:self.GewichtPickerView];
        
        self.GewichtPickerView.textField = GewichtLabel;
        
        [self.GewichtPickerView setValue:74.0];
        
        [self.GewichtPickerView setHidden:YES];
        
        glucoseIsBeforeMealBool = true;
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupDatumLabel];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)setupDatumLabel {
    
    self.DatumDateFormatter = [[NSDateFormatter alloc] init];
    [self.DatumDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.DatumDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.DatumDateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSDate *defaultDate = [NSDate date];
    
    //    self.DatumDateLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.DatumDateLabel.textColor = [self.tableView tintColor];
    
    self.selectedDatumDate = defaultDate;
    self.DatumDateLabel.text = [self.DatumDateFormatter stringFromDate:defaultDate];;
}



#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  This is the index path of the date picker cell in the static table
    if (indexPath.section == 0 && indexPath.row == 1 && !self.isDatumDateOpen){
        return 0;
    }
    if (indexPath.section == 1 && indexPath.row == 3 && !self.GewichtPickerView.isShown){
        return 0;
    }
    CGFloat height =[super tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == DatumCell){
        self.DatumDateOpen = !self.isDatumDateOpen;
        
        self.DatumDateLabel.text =  [self.DatumDateFormatter stringFromDate:DatumDatePicker.date];
        
        self.selectedDatumDate = DatumDatePicker.date;
        
        if (self.datePickerIsShowing){
            
            [self hideDatumDatePickerCell];
            
        }else {
            
            
            [self showDatumDatePickerCell];
        }
    }
    
    if (cell == GewichtCell) {
        
        if (!self.GewichtPickerView.isShown) {
            [self.GewichtPickerView show];
            
        } else {
            [self.GewichtPickerView hide];
        }
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}




- (void)showDatumDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.DatumDatePicker.hidden = NO;
    self.DatumDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.DatumDatePicker.alpha = 1.0f;
        
    }];
}


- (void)hideDatumDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.DatumDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.DatumDatePicker.hidden = YES;
                     }];
}

- (IBAction)pickerDatumDateChanged:(UIDatePicker *)sender {
    
    self.DatumDateLabel.text =  [self.DatumDateFormatter stringFromDate:sender.date];
    
    self.selectedDatumDate = sender.date;
}


-(void)dismissKeyboard
{
    UITextField *activeTextField = nil;
    if ([GlucoseField isEditing]) activeTextField = GlucoseField;
    else if ([BlutzuckerField isEditing]) activeTextField = BlutzuckerField;
    else if ([HbA1cField isEditing]) activeTextField = HbA1cField;
    if (activeTextField) [activeTextField resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if (!glucoseIsBeforeMeal.selectedSegmentIndex == 0) {
        glucoseIsBeforeMealBool = false;
    }
    
    if (sender != self.saveButton) return;
    //else if did schema change? => store new data
    
}



@end