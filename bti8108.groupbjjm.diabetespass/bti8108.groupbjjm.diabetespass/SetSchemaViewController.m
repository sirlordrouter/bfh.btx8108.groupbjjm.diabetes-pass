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

@property (nonatomic, strong) NSArray* buttonPics;
@property (nonatomic, strong) NSArray* matrixData;
@property (nonatomic, strong) NSArray* buttons;
@property (nonatomic, strong) NSString* selectedSchema;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSArray* fewDataMatrix;
@property (nonatomic, strong) NSArray* oftenDataMatrix;
@property (nonatomic, strong) NSArray* numerousDataMatrix;

@end

@implementation SetSchemaViewController

@synthesize pickerDefaults=_pickerDefaults;

NSInteger const MeasureTimes = 7;
NSInteger const WeekDayMeasureRows = 10;
CGFloat const CheckButtonWith = 50.0;
CGFloat const WeekDayLabelSize = 50.0;
CGFloat const MatrixSpacing = 5.0;
CGFloat const FirstDataRowPosition = 90.0;


#pragma Button Actions


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    //else if did schema change? => store new data

}


#pragma initialization
-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _pickerDefaults = @[@"wenig", @"häufig", @"viel", @"individuell"];
    _buttonPics = @[@"off@2x",@"on@2x"];
    
    self.defaultSchemePicker.dataSource = self;
    self.defaultSchemePicker.delegate = self;
    
    self.defaultSchemePicker.hidden = true;
    
    NSInteger row = [self.defaultSchemePicker selectedRowInComponent:0]; //schema mit zuletzt gespeichertem item füllen
    NSString *itemName = [_pickerDefaults objectAtIndex:row];

    
    [self.changeSchema setTitle:itemName forState:UIControlStateNormal];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:applicationFrame];
    UIImage *backgroundImage = [UIImage imageNamed:@"SchemaBackground@2x"];
    backgroundImageView.image = backgroundImage;
    [self.schemaViewCell addSubview:backgroundImageView];

    [self initButtonMatrix];
    [self pickerView:self.defaultSchemePicker didSelectRow:0 inComponent:0];
}

-(void)initData {
    
    self.fewDataMatrix = @[
                           @[@1,@1,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@1,@1,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@1,@1,@0],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@1,@1,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@1,@1,@0,@0,@0]
  ];
    
    self.oftenDataMatrix = @[
                           @[@1,@1,@0,@0,@0,@0,@1],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@1,@1,@0,@0,@1],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@1,@1,@1],
                           @[@0,@0,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@1],
                           @[@1,@1,@0,@0,@0,@0,@0],
                           @[@0,@0,@0,@0,@0,@0,@1],
                           @[@0,@0,@1,@1,@0,@0,@0]
                           ];
    
    self.numerousDataMatrix = @[
                           @[@1,@1,@0,@0,@0,@0,@0],
                           @[@1,@0,@0,@0,@0,@0,@0],
                           @[@1,@0,@1,@1,@0,@0,@0],
                           @[@1,@0,@0,@0,@0,@0,@0],
                           @[@1,@0,@0,@0,@1,@1,@0],
                           @[@1,@0,@0,@0,@0,@0,@0],
                           @[@1,@0,@0,@0,@0,@0,@0],
                           @[@1,@1,@0,@0,@0,@0,@0],
                           @[@1,@0,@0,@0,@0,@0,@0],
                           @[@1,@0,@1,@1,@0,@0,@0]
                           ];
    
    
    NSMutableArray *matrix = [NSMutableArray array];
    for (int rows = 0; rows < WeekDayMeasureRows ; rows++) {
        NSMutableArray *columns = [NSMutableArray array];
        for (int col = 0; col < MeasureTimes; col++) {
            [columns addObject:[NSNumber numberWithInt:1]];
        }
        [matrix addObject:columns];
    }
    
    self.matrixData = matrix;
}


#pragma Picker
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
#pragma picker delegates
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

#pragma table delegates
/**
 *  When a picker with schema default is selected and a new value selected, this event is fired.
 *
 *  @param pickerView picker with 3 default schemes
 *  @param row        the row that has been selected
 *  @param component  betroffene Komponente
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSString *itemName = [_pickerDefaults objectAtIndex:row];
    
    //Attention here, just reference to array => must be copied as user can edit data
    switch (row) {
        case 0:
            [self setUpMatrixFromPredefinedSchema:_fewDataMatrix];
            break;
        case 1:
            [self setUpMatrixFromPredefinedSchema:_oftenDataMatrix];
            break;
        case 2:
            [self setUpMatrixFromPredefinedSchema:_numerousDataMatrix];
            break;
        case 3:
            [self setUpMatrixFromPredefinedSchema:_fewDataMatrix];
            break;
    }

    //wenn geändert: speichern
    [self.changeSchema setTitle:itemName forState:UIControlStateNormal];
}

-(void)setUpMatrixFromPredefinedSchema:(NSArray*)array {
    for (int row = 0; row < WeekDayMeasureRows; row++) {
        for (int col = 0; col < MeasureTimes; col++) {
            UIButton *currentButton = [[self.buttons objectAtIndex:row] objectAtIndex:col];
            
            NSInteger value = [[[array objectAtIndex:row] objectAtIndex:col] integerValue];
            [currentButton setBackgroundImage:[UIImage imageNamed:[_buttonPics objectAtIndex:value]] forState:UIControlStateNormal];
            [[self.matrixData objectAtIndex:row] setObject:[NSNumber numberWithInteger:[self toggleButtonValue:value]] atIndex:col];
        }
    }
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

// store the index path of the date picker cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 1 && !self.defaultPickerIsShowing){
        return 0;
    }
    //else give back standard height defined
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma Buttonmatrix initialization

-(void) initButtonMatrix {
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"Mo", @"Di", @"Mi", @"Do", @"Fr", @"Sa", @"So", nil];
    NSArray *remainingDays = [NSArray arrayWithObjects:@"-3", @"-2", @"-1", nil];

    
    //label weekdays
    
    int row =  FirstDataRowPosition;
    
    for (int i = 0; i < MeasureTimes; i++) {
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
    
    NSMutableArray *buttonsArray2D = [NSMutableArray array];
    
    
    //Buttons matrix weekdays
    row = FirstDataRowPosition + 9;
    int column = 50;
    for (int rowId = 0; rowId < MeasureTimes; rowId++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
        column = 50;
        for (int columnId=0; columnId < MeasureTimes; columnId++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [weekdayArray addObject:button];
            [self addButton:button atColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        
        if (rowId == 4) { row += 3; } //HACK: Layout not fitting at 4th row add additional space
        
        row += 27.5;
        [buttonsArray2D addObject:weekdayArray];
    }
    
    row = FirstDataRowPosition + 237; // create matrix for resting days to doctor visit
    for (int rowId = MeasureTimes; rowId < WeekDayMeasureRows; rowId++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
        column = 50;
        for (int columnId=0; columnId < MeasureTimes; columnId++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [weekdayArray addObject:button];
            [self addButton:button atColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        row += 29;
        [buttonsArray2D addObject:weekdayArray];
    }
    
    self.buttons = buttonsArray2D;
}

-(void)addButton:(UIButton*)button atColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos {
    [button setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
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
    
    NSInteger value = [[[self.matrixData objectAtIndex:row] objectAtIndex:col] integerValue];
    [tempBtn setBackgroundImage:[UIImage imageNamed:[_buttonPics objectAtIndex:value]] forState:UIControlStateNormal];
    [[self.matrixData objectAtIndex:row] setObject:[NSNumber numberWithInteger:[self toggleButtonValue:value]] atIndex:col];
    
    NSInteger schema = [self arrayEqualToPredefinedScheme:self.matrixData];
    [_defaultSchemePicker selectRow:schema inComponent:0 animated:TRUE];
    [self.changeSchema setTitle:[self.pickerDefaults objectAtIndex:schema] forState:UIControlStateNormal];
}


-(NSInteger)toggleButtonValue:(NSInteger)value {
    return value == 1 ? 0 : 1;
}

-(NSInteger)arrayEqualToPredefinedScheme:(NSArray*)array {
    
    if ([array isEqualToArray:_fewDataMatrix]) {
        return 0;
    } else if([array isEqualToArray:_oftenDataMatrix]) {
        return 1;
    }else if([array isEqualToArray:_numerousDataMatrix]){
        return 2;
    } else {
        return 3;
    }
}






@end
