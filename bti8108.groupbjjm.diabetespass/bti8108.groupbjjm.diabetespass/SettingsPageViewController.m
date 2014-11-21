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


@interface SettingsPageViewController ()


@end

@implementation SettingsPageViewController
@synthesize morningCell;
@synthesize morningDatePicker;
@synthesize morningDatePickerCell;
@synthesize typLabel;
@synthesize therapieLabel;

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
    [morningDatePicker setHidden:(YES)];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // This is the index path of the date picker cell in the static table
    if (indexPath.section == 1 && indexPath.row == 1 && !self.isDateOpen){
        return 0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    
    if (cell == self.morningCell){
        self.dateOpen = !self.isDateOpen;
        [morningDatePicker setHidden:(NO)];

    }

  
    [self.tableView endUpdates];
}

//-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    [tableView beginUpdates];
//    
//    if (cell == self.morningCell){
//        self.dateOpen = !self.isDateOpen;
//        [morningDatePicker setHidden:(YES)];
//
//        
//    }
//    
//      [self.tableView endUpdates];
//}



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

@end
