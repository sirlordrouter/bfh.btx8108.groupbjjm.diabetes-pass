//
//  SettingsPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Saskia Basler on 15/11/14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SettingsPageViewController.h"
#import "SettingsTypPageViewController.h"
#import "SettingsTherapyPageViewController.h"

#define kDatePickerIndex 2
#define kDatePickerCellHeight 164


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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupMorningLabel];
    [self setupMiddayLabel];
    [self setupEveningLabel];
    [self setupNightLabel];
    
    [self.morningDatePicker setHidden:(YES)];
    [self.middayDatePicker setHidden:(YES)];
    [self.eveningDatePicker setHidden:(YES)];
    [self.nightDatePicker setHidden:(YES)];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)setupMorningLabel {
    
    self.morningDateFormatter = [[NSDateFormatter alloc] init];
    [self.morningDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.morningDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.morningDateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *defaultDate = [NSDate date];
    
    //    self.morningtimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.morningtimeLabel.textColor = [self.tableView tintColor];
    
    self.selectedMorningTime = defaultDate;
}

- (void)setupMiddayLabel {
    
    self.middayDateFormatter = [[NSDateFormatter alloc] init];
    [self.middayDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.middayDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.middayDateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *defaultDate = [NSDate date];
    
    //    self.morningtimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.middaytimeLabel.textColor = [self.tableView tintColor];
    
    self.selectedMiddayTime = defaultDate;
}

- (void)setupEveningLabel {
    
    self.eveningDateFormatter = [[NSDateFormatter alloc] init];
    [self.eveningDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.eveningDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.eveningDateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *defaultDate = [NSDate date];
    
    //    self.morningtimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.eveningtimeLabel.textColor = [self.tableView tintColor];
    
    self.selectedEveningTime = defaultDate;
}

- (void)setupNightLabel {
    
    self.nightDateFormatter = [[NSDateFormatter alloc] init];
    [self.nightDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.nightDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.nightDateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *defaultDate = [NSDate date];
    
    //    self.morningtimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.nighttimeLabel.textColor = [self.tableView tintColor];
    
    self.selectedNightTime = defaultDate;
}



#pragma mark - Table view methods

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
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == morningCell){
        self.morningDateOpen = !self.isMorningDateOpen;
        
        if (self.datePickerIsShowing){
            
            [self hideMorningDatePickerCell];
            
        }else {
            
            
            [self showMorningDatePickerCell];
        }
    }
    
    else if (cell == middayCell){
        self.middayDateOpen = !self.isMiddayDateOpen;
        
        if (self.datePickerIsShowing){
            
            [self hideMiddayDatePickerCell];
            
        }else {
            
            
            [self showMiddayDatePickerCell];
        }
    }
    
    else if (cell == eveningCell){
        self.eveningDateOpen = !self.isEveningDateOpen;
        
        if (self.datePickerIsShowing){
            
            [self hideEveningDatePickerCell];
            
        }else {
            
            
            [self showEveningDatePickerCell];
        }
    }
    
    else if (cell == nightCell){
        self.nightDateOpen = !self.isNightDateOpen;
        
        if (self.datePickerIsShowing){
            
            [self hideNightDatePickerCell];
            
        }else {
            
            
            [self showNightDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showMorningDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.morningDatePicker.hidden = NO;
    self.morningDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.morningDatePicker.alpha = 1.0f;
        
    }];
}

- (void)hideMorningDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.morningDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.morningDatePicker.hidden = YES;
                     }];
}

- (void)showMiddayDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.middayDatePicker.hidden = NO;
    self.middayDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.middayDatePicker.alpha = 2.0f;
        
    }];
}

- (void)hideMiddayDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.middayDatePicker.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.middayDatePicker.hidden = YES;
                     }];
}

- (void)showEveningDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.eveningDatePicker.hidden = NO;
    self.eveningDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.eveningDatePicker.alpha = 1.0f;
        
    }];
}

- (void)hideEveningDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.eveningDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.eveningDatePicker.hidden = YES;
                     }];
}

- (void)showNightDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.nightDatePicker.hidden = NO;
    self.nightDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.nightDatePicker.alpha = 1.0f;
        
    }];
}

- (void)hideNightDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
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

- (IBAction)pickerMorningDateChanged:(UIDatePicker *)sender {
    
    self.morningtimeLabel.text =  [self.morningDateFormatter stringFromDate:sender.date];
    
    self.selectedMorningTime = sender.date;
}

- (IBAction)pickerMiddayDateChanged:(UIDatePicker *)sender {
    
    self.middaytimeLabel.text =  [self.middayDateFormatter stringFromDate:sender.date];
    
    self.selectedMiddayTime = sender.date;
}

- (IBAction)pickerEveningDateChanged:(UIDatePicker *)sender {
    
    self.eveningtimeLabel.text =  [self.eveningDateFormatter stringFromDate:sender.date];
    
    self.selectedEveningTime = sender.date;
}

- (IBAction)pickerNightDateChanged:(UIDatePicker *)sender {
    
    self.nighttimeLabel.text =  [self.nightDateFormatter stringFromDate:sender.date];
    
    self.selectedNightTime = sender.date;
}


@end




/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
