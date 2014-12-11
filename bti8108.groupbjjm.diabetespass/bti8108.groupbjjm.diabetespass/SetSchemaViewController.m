//
//  SetSchemaViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SetSchemaViewController.h"
#import "SettingsSchemaView.h"

@interface SetSchemaViewController()

@property (nonatomic, strong) NSArray* matrixData;

@end

@implementation SetSchemaViewController

@synthesize pickerDefaults=_pickerDefaults;


CGFloat const WeekDayLabelSize = 50.0;
CGFloat const CheckButtonWith = 50.0;
CGFloat const MatrixSpacing = 5.0;
CGFloat const FirstDataRowPosition = 90.0;

- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue
{
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    //else if did schema change? => store new data

}




-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self initFakeData];
    
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _pickerDefaults = @[@"wenig", @"häufig", @"viel"];
    
    self.defaultSchemePicker.dataSource = self;
    self.defaultSchemePicker.delegate = self;
    
    self.defaultSchemePicker.hidden = true;
    
    NSInteger row = [self.defaultSchemePicker selectedRowInComponent:0];
    NSString *itemName = [_pickerDefaults objectAtIndex:row];
    
    [self.changeSchema setTitle:itemName forState:UIControlStateNormal];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:applicationFrame];
    UIImage *backgroundImage = [UIImage imageNamed:@"SchemaBackground@2x"];
    backgroundImageView.image = backgroundImage;
    [self.schemaViewCell addSubview:backgroundImageView];
    
    [self initButtonMatrix];
}

-(void)initFakeData {
    
    NSMutableArray *matrix = [NSMutableArray array];
    for (int rows = 0; rows < 10 ; rows++) {
        NSMutableArray *columns = [NSMutableArray array];
        for (int col = 0; col < 7; col++) {
            [columns addObject:[NSNumber numberWithInt:1]];
        }
        [matrix addObject:columns];
    }
    
    self.matrixData = matrix;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.intervallCell) { // this is my date cell above the picker cell
        self.defaultPickerIsShowing = !self.defaultPickerIsShowing;
        if (self.defaultPickerIsShowing) {
            [self showPickerCell];
        } else {
            [self hidePickerCell];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
}

- (void)showPickerCell {
    
    // set the boolean to YES, to mark that the datepicker is shown
    self.defaultPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    // show the date picker and make an animation that if looks like the datepicker appears behind the cells
    self.defaultSchemePicker.hidden = NO;
    self.defaultSchemePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.defaultSchemePicker.alpha = 1.0f;
        
    }];
}

// method to hide the morning date picker cell
- (void)hidePickerCell {
    
    // set the boolean to NO, to mark that the morning datepicker is not shown
    self.defaultPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    // animation effect, that if looks like the morning date picker dissapear behind the cells after that set the midday date picker hidden
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.defaultSchemePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.defaultSchemePicker.hidden = YES;
                     }];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSString *itemName = [_pickerDefaults objectAtIndex:row];
    
    NSLog(itemName);
    
    //wenn geändert: speichern
    [self.changeSchema setTitle:itemName forState:UIControlStateNormal];
}

// store the index path of the date picker cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 1 && !self.defaultPickerIsShowing){
        return 0;
    }
    //else give back standard height defined
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:1]];
//    if (cell == nil) {
//        [cell.contentView addSubview:[SettingsSchemaView init]];
//    }
//    
//    return cell;
//}

-(void) initButtonMatrix {
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"Mo", @"Di", @"Mi", @"Do", @"Fr", @"Sa", @"So", nil];
    NSArray *remainingDays = [NSArray arrayWithObjects:@"-3", @"-2", @"-1", nil];
    
    
//    //Images daytime
//    
//    UIImageView *morningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 85, 30, 30)];
//    UIImage *morningImage = [UIImage imageNamed:@"morning@2x"];
//    morningImageView.image = morningImage;
//    [self.schemaViewCell addSubview:morningImageView];
//    
//    UIImageView *noonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 85, 30, 30)];
//    UIImage *noonImage = [UIImage imageNamed:@"noon@2x"];
//    noonImageView.image = noonImage;
//    [self.schemaViewCell addSubview:noonImageView];
//    
//    UIImageView *eveningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 85, 30, 30)];
//    UIImage *eveningImage = [UIImage imageNamed:@"evening@2x"];
//    eveningImageView.image = eveningImage;
//    [self.schemaViewCell addSubview:eveningImageView];
//    
//    UIImageView *nightImageViews = [[UIImageView alloc] initWithFrame:CGRectMake(280, 85, 30, 30)];
//    UIImage *nightImage = [UIImage imageNamed:@"night@2x"];
//    nightImageViews.image = nightImage;
//    [self.schemaViewCell addSubview:nightImageViews];
//    
//    
//    // Images before/after MEal
//    UIImage *appleBig = [UIImage imageNamed:@"apfel_ganz"];
//    UIImage *appleSmall = [UIImage imageNamed:@"apfel_biss"];
//    
//    UIImageView *morningPre= [[UIImageView alloc] initWithFrame:CGRectMake(55, 120, 30,30)];
//    morningPre.image = appleBig;
//    [self.schemaViewCell addSubview:morningPre];
//    
//    UIImageView *morningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(90, 120, 30,30)];
//    morningAfter.image = appleSmall;
//    [self.schemaViewCell addSubview:morningAfter];
//    
//    UIImageView *noonPre= [[UIImageView alloc] initWithFrame:CGRectMake(130, 120,30,30)];
//    noonPre.image = appleBig;
//    [self.schemaViewCell addSubview:noonPre];
//    
//    UIImageView *noonAfter= [[UIImageView alloc] initWithFrame:CGRectMake(165, 120, 30,30)];
//    noonAfter.image = appleSmall;
//    [self.schemaViewCell addSubview:noonAfter];
//    
//    UIImageView *eveningPre= [[UIImageView alloc] initWithFrame:CGRectMake(205, 120, 30,30)];
//    eveningPre.image = appleBig;
//    [self.schemaViewCell addSubview:eveningPre];
//    
//    UIImageView *eveningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(240, 120, 30,30)];
//    eveningAfter.image = appleSmall;
//    [self.schemaViewCell addSubview:eveningAfter];
    
    //label weekdays
    
    int row =  FirstDataRowPosition;
    
    for (int i = 0; i < 7; i++) {
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(10.0, row, 50.0, 43.0) withText:weekdays[i]];
        row += 27.0;
    }
    
    //label consult
    row = FirstDataRowPosition + 225;
    
    for (int i = 0; i < 3; i++) {
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(12.0, row, 50.0, 43.0) withText:remainingDays[i]];
        row += 30.0;
    }
    
    //Restzeit bis Arztbesuchs
    UILabel *doctorConsultLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10.0, FirstDataRowPosition+195, 350.0, 43.0) ];
    doctorConsultLabel.textAlignment =  NSTextAlignmentLeft;
    doctorConsultLabel.textColor = [UIColor blackColor];
    doctorConsultLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    doctorConsultLabel.text = @"Drei Tage bis zur nächsten Arztkonsultation";
    [self.schemaViewCell addSubview:doctorConsultLabel];
    
    //Buttons matrix weekdays
    row = FirstDataRowPosition + 9;
    int column = 50;
    for (int rowId = 0; rowId < 7; rowId++) {
        
        column = 50;
        
        for (int columnId=0; columnId < 7; columnId++) {
            [self addButtonAtColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        
        if (rowId == 4) { row += 3; } //HACK: Layout not fitting at 4th row
        
        row += 27.5;
        
    }
    
    row = FirstDataRowPosition + 237; // create matrix for resting days to doctor visit
    for (int rowId = 0; rowId < 3; rowId++) {
        
        column = 50;
        
        for (int columnId=0; columnId < 7; columnId++) {
            [self addButtonAtColumn:0 atRow:0 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        row += 29;
        
    }
}

-(void)addButtonAtColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    [button addTarget:self
               action:@selector(timeSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:pos];
    [button setTag:column+row];
    [self.schemaViewCell addSubview:button];
}

-(void)addLabelAtColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos withText:(NSString*)text {
    UILabel *label09 = [ [UILabel alloc ] initWithFrame:pos ];
    label09.textAlignment =  NSTextAlignmentLeft;
    label09.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label09.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label09.text = text;
    [self.schemaViewCell addSubview:label09];
}

-(void)timeSelected:(id)sender {
    UIButton *tempBtn=(UIButton *) sender;
    
    NSString * string = [NSString stringWithFormat:@"%d", tempBtn.tag];
    NSLog(string) ;
    
    int row = (tempBtn.tag / 10) % 10;
    int col = tempBtn.tag % 10;
    
    if ([[[self.matrixData objectAtIndex:row] objectAtIndex:col] integerValue] == 0) {
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
        [[self.matrixData objectAtIndex:row] setObject:[NSNumber numberWithInt:1] atIndex:col];
    } else {
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateNormal];
        [[self.matrixData objectAtIndex:row] setObject:[NSNumber numberWithInt:0] atIndex:col];
    }
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerDefaults.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerDefaults[row];
}


@end
