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
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:applicationFrame];
    UIImage *backgroundImage = [UIImage imageNamed:@"SchemaBackground@2x"];
    backgroundImageView.image = backgroundImage;
    [self.view addSubview:backgroundImageView];
    
    int weekday =[self getCurrentWeekday];
    float weekdayPosition = [[self.rowPositionsWeekdays objectAtIndex:weekday] floatValue];
    SchemaViewDaySelection *selectionView = [[SchemaViewDaySelection alloc] initWithFrame:CGRectMake(7,weekdayPosition,306,30)];
    selectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:selectionView];
    
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

#pragma Buttonmatrix initialization

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
    
    
    NSMutableArray *labelArray2D = [NSMutableArray array];
    
    UIColor *markColor;
    int currentWeekDay = 0;
    int row =  SchemaFirstDataRowPosition;
    for (int i = 0; i < 7; i++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
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
    for (int rowId = 0; rowId < 7; rowId++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
        column = 50;
        
        for (int columnId=0; columnId < 7; columnId++) {
            UILabel *label = [ [UILabel alloc ] init];
            [weekdayArray addObject:label];
            [self addMark:label atColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        
        if (rowId == 4) { row += 3; } //HACK: Layout not fitting at 4th row add additional space
        row += 27.5;
        [buttonsArray2D addObject:weekdayArray];
        
    }
    
    row = SchemaFirstDataRowPosition + 235; // create matrix for resting days to doctor visit
    for (int rowId = 7; rowId < 10; rowId++) {
        NSMutableArray *weekdayArray = [NSMutableArray array];
        column = 50;
        
        for (int columnId=0; columnId < 7; columnId++) {
            UILabel *label = [ [UILabel alloc ] init];
            [weekdayArray addObject:label];
            [self addMark:label atColumn:columnId atRow:rowId*10 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        row += 29;
        [buttonsArray2D addObject:weekdayArray];
    }
    
    
    
    
    
    
    self.xLabel = buttonsArray2D;
    
        // Images before/after MEal
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

-(void)addMark:(UILabel*)label atColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos{
   
    [label setFrame:pos];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(26.0)];
    label.text = @"x";
    [self.view addSubview:label];
}

-(void)addLabelAtColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos withText:(NSString*)text withColor:(UIColor*)color {
    UILabel *label09 = [ [UILabel alloc ] initWithFrame:pos ];
    label09.textAlignment =  NSTextAlignmentLeft;
    label09.textColor = color;
    label09.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label09.text = text;
    [self.view addSubview:label09];
}

-(int) getCurrentWeekday {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    return [comps weekday]-2;
}


#pragma Button Actions
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


@end
