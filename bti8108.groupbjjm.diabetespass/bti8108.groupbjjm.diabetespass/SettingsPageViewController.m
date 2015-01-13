//
//  SettingsPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Saskia Basler on 15/11/14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//
//  VCDetailsTableViewController.m
//  InlineDatePicker
//  Created by Vasilica Costescu on 24/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//


// import the view controllers
#import "SettingsPageViewController.h"
#import "SettingsTypPageViewController.h"
#import "SettingsTherapyPageViewController.h"

@interface SettingsPageViewController ()

@end

@implementation SettingsPageViewController
@synthesize morningCell;
@synthesize morningDatePicker;
@synthesize morningDatePickerCell;
@synthesize typLabel;
@synthesize therapieLabel;
@synthesize middayCell;
@synthesize eveningCell;
@synthesize nightCell;

 #pragma mark - Navigation

// find out which cell is selected in the SettingsTypView and write this into the label on the main SettingsView
- (IBAction)unwindToEinstellungen1:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[SettingsTypPageViewController class]])
    {
        
        NSLog(@"Diabetes Typ 1");
        typLabel.text = @"Diabetes Typ 1";
    }
    else if ([sourceViewController isKindOfClass:[SettingsTherapyPageViewController class]])
    {
        NSLog(@"ICT");
        therapieLabel.text = @"ICT";
    }
    
}

// find out which cell is selected in the SettingsTherapyView and write this into the label on the main SettingsView
- (IBAction)unwindToEinstellungen2:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[SettingsTypPageViewController class]])
    {
        
        NSLog(@"Diabetes Typ 2");
        typLabel.text = @"Diabetes Typ 2";
    }
    else if ([sourceViewController isKindOfClass:[SettingsTherapyPageViewController class]])
    {
        NSLog(@"konventionelle Therapieform");
        therapieLabel.text = @"konventionell";
    }
    
    
}

// when the SettingsView will be loaded,
- (void)viewDidLoad {
    
    [super viewDidLoad];

// the Labels should be built with the corresponding method
    [self setupMorningLabel];
    [self setupMiddayLabel];
    [self setupEveningLabel];
    [self setupNightLabel];

// Also the DatePickers should be setHidden:YES otherwise there are all visible.
    [self.morningDatePicker setHidden:(YES)];
    [self.middayDatePicker setHidden:(YES)];
    [self.eveningDatePicker setHidden:(YES)];
    [self.nightDatePicker setHidden:(YES)];
    
}

// didn't change anything in this method
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

// method to build the morningLabel
- (void)setupMorningLabel {
    
// and tell them, that it should only show the time and not the date and that the format is HH.mm
    self.morningDateFormatter = [[NSDateFormatter alloc] init];
    [self.morningDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.morningDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.morningDateFormatter setDateFormat:@"HH:mm"];
    
// make an date object and tell that it is an NSDate
    NSDate *defaultDate = [NSDate date];
    
// set the created defaultDate to the selected MorningTime.
    self.selectedMorningTime = defaultDate;
}


// method to build the middayLabel
- (void)setupMiddayLabel {

// and tell them, that it should only show the time and not the date and that the format is HH.mm
    self.middayDateFormatter = [[NSDateFormatter alloc] init];
    [self.middayDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.middayDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.middayDateFormatter setDateFormat:@"HH:mm"];

// make an date object and tell that it is an NSDate
    NSDate *defaultDate = [NSDate date];
    
// set the created defaultDate to the selected MiddayTime.
    self.selectedMiddayTime = defaultDate;
}


// method to build the eveningLabel
- (void)setupEveningLabel {
  
// and tell them, that it should only show the time and not the date and that the format is HH.mm
    self.eveningDateFormatter = [[NSDateFormatter alloc] init];
    [self.eveningDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.eveningDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.eveningDateFormatter setDateFormat:@"HH:mm"];

// make an date object and tell that it is an NSDate
    NSDate *defaultDate = [NSDate date];
    
 // set the created defaultDate to the selected EveningTime.
    self.selectedEveningTime = defaultDate;
}


// method to build the nightLabel
- (void)setupNightLabel {
 
// and tell them, that it should only show the time and not the date and that the format is HH.mm
    self.nightDateFormatter = [[NSDateFormatter alloc] init];
    [self.nightDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.nightDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.nightDateFormatter setDateFormat:@"HH:mm"];

// make an date object and tell that it is an NSDate
    NSDate *defaultDate = [NSDate date];

// set the created defaultDate to the selected NightTime.
    self.selectedNightTime = defaultDate;
}



#pragma mark - Table view methods
// store the index path of the date picker cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  This is the index path of the date picker cell in the static table
    if (indexPath.section == 1 && indexPath.row == 1 && !self.isMorningDateOpen){
        return 0;
    }
    if (indexPath.section == 1 && indexPath.row == 3 && !self.isMiddayDateOpen){
        return 0;
    }
    else if (indexPath.section == 1 && indexPath.row == 5 && !self.isEveningDateOpen){
        return 0;
    }
    else if (indexPath.section == 1 && indexPath.row == 7 && !self.isNightDateOpen){
        return 0;
    }
// give the index path back
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

// method to find out wich row is selected in the index path
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
// when the selected cell is the morning cell
    if (cell == morningCell){
        
// set the morningDateOpen to is not open
        self.morningDateOpen = !self.isMorningDateOpen;

// when the morning date picker is already shown do the method hideMorningDatePickerCell
        if (self.MorningdatePickerIsShowing){
            
            [self hideMorningDatePickerCell];
            
        }else {
            
// otherwise do the method showMorningDatePickerCell
            [self showMorningDatePickerCell];
        }
    }
 
// when the selected cell is the midday cell
    else if (cell == middayCell){
    
// set the middayDateOpen to is not open
        self.middayDateOpen = !self.isMiddayDateOpen;

// when the midday date picker is already shown do the method hideMiddayDatePickerCell
        if (self.MiddaydatePickerIsShowing){
            
            [self hideMiddayDatePickerCell];

// otherwise do the method showMiddayDatePickerCell
        }else {
            
            
            [self showMiddayDatePickerCell];
        }
    }

// when the selected cell is the evening cell
    else if (cell == eveningCell){
        
// set the eveningDateOpen to is not open
        self.eveningDateOpen = !self.isEveningDateOpen;

// when the evening date picker is already shown do the method hideEveningDatePickerCell
        if (self.EveningdatePickerIsShowing){
            
            [self hideEveningDatePickerCell];
  
// otherwise do the method showEveningDatePickerCell
        }else {
            
            
            [self showEveningDatePickerCell];
        }
    }

// when the selected cell is the night cell
    else if (cell == nightCell){
        
// set the nightDateOpen to is not open
        self.nightDateOpen = !self.isNightDateOpen;
 
// when the night date picker is already shown do the method hideNightDatePickerCell
        if (self.NightdatePickerIsShowing){
            
            [self hideNightDatePickerCell];

// otherwise do the method showNightDatePickerCell
        }else {
            
            
            [self showNightDatePickerCell];
        }
    }
   
// close the cell when they are deselected
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// method to show the morning date picker cell
- (void)showMorningDatePickerCell {
    
// set the boolean to YES, to mark that the datepicker is shown
    self.MorningdatePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];

// show the date picker and make an animation that if looks like the datepicker appears behind the cells
    self.morningDatePicker.hidden = NO;
    self.morningDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.morningDatePicker.alpha = 1.0f;
        
    }];
}

// method to hide the morning date picker cell
- (void)hideMorningDatePickerCell {
 
// set the boolean to NO, to mark that the morning datepicker is not shown
    self.MorningdatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
 
// animation effect, that if looks like the morning date picker dissapear behind the cells after that set the midday date picker hidden
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.morningDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.morningDatePicker.hidden = YES;
                     }];
}

// method to show the midday date picker cell
- (void)showMiddayDatePickerCell {
 
// set the boolean to XES, to mark that the midday datepicker is shown
    self.MiddaydatePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
 
// show the date picker and make an animation that if looks like the datepicker appears behind the cells
    self.middayDatePicker.hidden = NO;
    self.middayDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.middayDatePicker.alpha = 2.0f;
        
    }];
}

// method to hide the midday date picker cell
- (void)hideMiddayDatePickerCell {
    
// set the boolean to NO, to mark that the midday datepicker is not shown
    self.MiddaydatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

// animation effect, that if looks like the midday date picker dissapear behind the cells after that set the midday date picker hidden
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.middayDatePicker.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.middayDatePicker.hidden = YES;
                     }];
}

// method to show the evening date picker cell
- (void)showEveningDatePickerCell {
    
// set the boolean to YES, to mark that the devening atepicker is shown
    self.EveningdatePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
 
// show the date picker and make an animation that if looks like the datepicker appears behind the cells
    self.eveningDatePicker.hidden = NO;
    self.eveningDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.eveningDatePicker.alpha = 1.0f;
        
    }];
}

// method to hide the evening date picker cell
- (void)hideEveningDatePickerCell {

// set the boolean to NO, to mark that the evening datepicker is not shown
    self.EveningdatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
 
// animation effect, that if looks like the evening date picker dissapear behind the cells after that set the evening date picker hidden
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.eveningDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.eveningDatePicker.hidden = YES;
                     }];
}

// method to show the night date picker cell
- (void)showNightDatePickerCell {
 
// set the boolean to YES, to mark that the night datepicker is shown
    self.NightdatePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
 
// show the date picker and make an animation that if looks like the datepicker appears behind the cells
    self.nightDatePicker.hidden = NO;
    self.nightDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.nightDatePicker.alpha = 1.0f;
        
    }];
}

// method to hide the night date picker cell
- (void)hideNightDatePickerCell {
    
// set the boolean to NO, to mark that the night datepicker is not shown
    self.NightdatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
  
// animation effect, that if looks like the night date picker dissapear behind the cells after that set the night date picker hidden
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.nightDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.nightDatePicker.hidden = YES;
                     }];
}

#pragma mark - UITextFieldDelegate methods


#pragma mark - Action methods

// method to change the time in the morning label when the time in the date picker changes
- (IBAction)pickerMorningDateChanged:(UIDatePicker *)sender {
    
    self.morningtimeLabel.text =  [self.morningDateFormatter stringFromDate:sender.date];
    
    self.selectedMorningTime = sender.date;
}

// method to change the time in the midday label when the time in the date picker changes
- (IBAction)pickerMiddayDateChanged:(UIDatePicker *)sender {
    
    self.middaytimeLabel.text =  [self.middayDateFormatter stringFromDate:sender.date];
    
    self.selectedMiddayTime = sender.date;
}

// method to change the time in the evening label when the time in the date picker changes
- (IBAction)pickerEveningDateChanged:(UIDatePicker *)sender {
    
    self.eveningtimeLabel.text =  [self.eveningDateFormatter stringFromDate:sender.date];
    
    self.selectedEveningTime = sender.date;
}

// method to change the time in the night label when the time in the date picker changes
- (IBAction)pickerNightDateChanged:(UIDatePicker *)sender {
    
    self.nighttimeLabel.text =  [self.nightDateFormatter stringFromDate:sender.date];
    
    self.selectedNightTime = sender.date;
}


@end
