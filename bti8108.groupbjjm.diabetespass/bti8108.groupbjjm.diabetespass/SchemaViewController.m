//
//  SchemaView.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SchemaViewController.h"
#import "SchemaViewDaySelection.h"
#import "SetSchemaViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SchemaViewController()


@property (nonatomic, strong) NSArray* matrixData;
@property (nonatomic, strong) NSArray* rowPositionsWeekdays;
@property (nonatomic, strong) NSArray* xLabel;

@end

@implementation SchemaViewController

@synthesize OverlayButton;


CGFloat const SchemaWeekDayLabelSize = 50.0;
CGFloat const SchemaCheckButtonWith = 50.0;
CGFloat const SchemaMatrixSpacing = 5.0;
CGFloat const SchemaFirstDataRowPosition = 150.0;

CGFloat const MondayRowX = 155;
CGFloat const TuesdayRowX = 183.5;
CGFloat const WednesdayRowX = 210;
CGFloat const ThurstdayRowX = 237;
CGFloat const FridayRowX = 265;
CGFloat const SaturdayRowX = 292;
CGFloat const SundayRowX = 319;

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self initFakeData];
    
    self.rowPositionsWeekdays =
        [NSArray arrayWithObjects:
         [NSNumber numberWithFloat:MondayRowX],
         [NSNumber numberWithFloat:TuesdayRowX],
         [NSNumber numberWithFloat:WednesdayRowX],
         [NSNumber numberWithFloat:ThurstdayRowX],
         [NSNumber numberWithFloat:FridayRowX],
         [NSNumber numberWithFloat:SaturdayRowX],
         [NSNumber numberWithFloat:SundayRowX], nil];
    
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    applicationFrame.origin.y +=60;
    
    //Set Schema Background
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:applicationFrame];
    UIImage *backgroundImage = [UIImage imageNamed:@"SchemaBackground@2x"];
    backgroundImageView.image = backgroundImage;
    [self.view addSubview:backgroundImageView];
    
    //Make the current Day visible with blue rectangle
    int weekday =[self getCurrentWeekday];
    float weekdayPosition = [[self.rowPositionsWeekdays objectAtIndex:weekday] floatValue];
    SchemaViewDaySelection *selectionView = [[SchemaViewDaySelection alloc] initWithFrame:CGRectMake(7,weekdayPosition,306,30)];
    selectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:selectionView];
    
    [self initButtonMatrix];
    
    
    OverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [OverlayButton setFrame:CGRectMake(0,20,applicationFrame.size.width,applicationFrame.size.height)];
    
    [OverlayButton setImage:[UIImage imageNamed:@"Schema"] forState:UIControlStateNormal];
    OverlayButton.adjustsImageWhenHighlighted = NO;
    [OverlayButton addTarget:self action:@selector(buttonPushed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:OverlayButton];
    OverlayButton.hidden = YES;
    
}

-(void)setProfileImage
{
    [self.navigationController.view addSubview:OverlayButton];
}

/**Overlay function - remove the overlay when the user clicks somewhere*/
- (void) buttonPushed:(id)sender
{
    OverlayButton.hidden = YES;
}


/**
 *  Adds Fake data - Remove when having a DB
 */
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

#pragma Buttonmatrix initialization

/**
 *  Set up the whole matrix and labling
 */
-(void) initButtonMatrix {
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"Mo", @"Di", @"Mi", @"Do", @"Fr", @"Sa", @"So", nil];
    NSArray *remainingDays = [NSArray arrayWithObjects:@"-3", @"-2", @"-1", nil];
    
    UIColor *markColor;
    int row =  SchemaFirstDataRowPosition;
    for (int i = 0; i < 7; i++) {
        if (i == [self getCurrentWeekday]) {
            markColor = [UIColor blackColor];
        } else {
            markColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        }
        
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(10.0, row, 50.0, 43.0) withText:weekdays[i] withColor:markColor];
        row += 27.0;
    }
    
    //label consult
    row = SchemaFirstDataRowPosition + 225;
    for (int i = 0; i < 3; i++) {
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(12.0, row, 50.0, 43.0) withText:remainingDays[i] withColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        row += 30.0;
    }
    
    //Restzeit bis Arztbesuchs
    UILabel *doctorConsultLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10.0, SchemaFirstDataRowPosition+195, 350.0, 43.0)];
    doctorConsultLabel.textAlignment =  NSTextAlignmentLeft;
    doctorConsultLabel.textColor = [UIColor blackColor];
    doctorConsultLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    doctorConsultLabel.text = @"Drei Tage bis zur nächsten Arztkonsultation";
    [self.view addSubview:doctorConsultLabel];
    
    
    NSMutableArray *buttonsArray2D = [NSMutableArray array];
    
    //Buttons matrix weekdays
    row = SchemaFirstDataRowPosition + 7;
    int column = 50;
    
    for (int rowId = 0; rowId < 10; rowId++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
        column = 50;
        for (int columnId=0; columnId < 10; columnId++) {
            UILabel *label = [ [UILabel alloc ] init];
            [weekdayArray addObject:label];
            [self addMark:label atColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        if (rowId == 4) { row += 3; } // HACK: using a picture not well aligned, make a lager spacing
        row += rowId < 7 ? 27.5 : 29; //the matrix for resting days to doctor visit has other spacing
        
        [buttonsArray2D addObject:weekdayArray];
        
        //When finished measuretimes for week, make a gap and set position for matrix for doctors visit
        if (rowId == 6) {
            row =SchemaFirstDataRowPosition + 235;
        }
    }
    
    self.xLabel = buttonsArray2D;
    
    [self addLegend];
    
        }

/**
 *  Adds the Legend for the images to the matrix
 */
-(void) addLegend {
    // Images before/after MEal for Legend below matrix
    UIImage *appleBig = [UIImage imageNamed:@"apfel_ganz"];
    UIImage *appleSmall = [UIImage imageNamed:@"apfel_biss"];
    
    UIImageView *morningPre= [[UIImageView alloc] initWithFrame:CGRectMake(10, SchemaFirstDataRowPosition + 325, 20,20)];
    morningPre.image = appleBig;
    [self.view addSubview:morningPre];
    
    UILabel *preMealLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(40, SchemaFirstDataRowPosition + 315, 350,43) ];
    preMealLabel.textAlignment =  NSTextAlignmentLeft;
    preMealLabel.textColor = [UIColor blackColor];
    preMealLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    preMealLabel.text = @"vor dem Essen";
    [self.view addSubview:preMealLabel];
    
    UIImageView *morningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(10, SchemaFirstDataRowPosition + 345, 20,20)];
    morningAfter.image = appleSmall;
    [self.view addSubview:morningAfter];
    
    UILabel *postMealLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(40, SchemaFirstDataRowPosition + 335, 350,43) ];
    postMealLabel.textAlignment =  NSTextAlignmentLeft;
    postMealLabel.textColor = [UIColor blackColor];
    postMealLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    postMealLabel.text = @"nach dem Essen";
    [self.view addSubview:postMealLabel];

}


/**
 *  Add Labeling for matrix
 *
 *  @param label  <#label description#>
 *  @param column <#column description#>
 *  @param row    <#row description#>
 *  @param pos    <#pos description#>
 */
-(void)addMark:(UILabel*)label atColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos{
   
    [label setFrame:pos];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(26.0)];
    label.text = @"x";
    [self.view addSubview:label];
}

/**
 *  Add Weekday labels
 *
 *  @param column <#column description#>
 *  @param row    <#row description#>
 *  @param pos    <#pos description#>
 *  @param text   <#text description#>
 *  @param color  <#color description#>
 */
-(void)addLabelAtColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos withText:(NSString*)text withColor:(UIColor*)color {
    UILabel *label09 = [ [UILabel alloc ] initWithFrame:pos ];
    label09.textAlignment =  NSTextAlignmentLeft;
    label09.textColor = color;
    label09.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label09.text = text;
    [self.view addSubview:label09];
}

//Gets the day of wek as integer value, straing with Monday = 0
-(int) getCurrentWeekday {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    return [comps weekday]-2;
}

#pragma Button Actions

//Handle a Save of Schema in the Schema Settings View
- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue
{
    SchemaViewController *source = [segue sourceViewController];
    self.matrixData = source.matrixData;
    
    for (int row = 0; row < self.matrixData.count ; row++) {
        for (int col = 0; col < [[self.matrixData objectAtIndex:row] count]; col++) {
            UILabel *label = [[self.xLabel objectAtIndex:row] objectAtIndex:col];
            if ([[[self.matrixData objectAtIndex:row] objectAtIndex:col] integerValue] == 1) {
                label.text = @"x";
            } else {
                label.text = @"";
            }
        }
    }
    
}

- (IBAction)showOverlay:(id)sender {
    OverlayButton.hidden = NO;
}


@end
