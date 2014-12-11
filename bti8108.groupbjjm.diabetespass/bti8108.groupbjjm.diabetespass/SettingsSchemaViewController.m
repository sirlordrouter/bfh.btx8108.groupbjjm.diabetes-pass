//
//  SchemaViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 08.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SettingsSchemaViewController.h"


@implementation SettingsSchemaViewController
@synthesize schemaView=_schemaView;


CGFloat const WeekDayLabelSize = 50.0;
CGFloat const CheckButtonWith = 50.0;
CGFloat const MatrixSpacing = 5.0;
                                                                                //                          NEXT
CGFloat Column0StartingPoint = MatrixSpacing;                                   //5 + 50Label + 5 spacing  => 60
CGFloat Column1StartingPoint = MatrixSpacing + CheckButtonWith + MatrixSpacing; //60 + 55                  => 115
CGFloat Column2StartingPoint = MatrixSpacing + 50 + CheckButtonWith;            //115 + 55                 => 170
CGFloat Column3StartingPoint = MatrixSpacing + 50 + CheckButtonWith;            //170 + 55      => 225
CGFloat Column4StartingPoint = MatrixSpacing + 50 + CheckButtonWith; //225 + 55 => 280
CGFloat Column5StartingPoint = MatrixSpacing + 50 + CheckButtonWith; //280 + 55 => 335
CGFloat Column6StartingPoint = MatrixSpacing + 50 + CheckButtonWith; //335 + 55 => 390
CGFloat Column7StartingPoint = MatrixSpacing + 50 + CheckButtonWith; //390 + 55 => 445
CGFloat Column8StartingPoint = MatrixSpacing + 50 + CheckButtonWith; //445 + 55 => 500 nxt


-(void) viewDidLoad {
    [super viewDidLoad];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:applicationFrame];
    UIImage *backgroundImage = [UIImage imageNamed:@"SchemaBackground@2x"];
    backgroundImageView.image = backgroundImage;
    [self.view addSubview:backgroundImageView];
    
    [self initButtonMatrix];
}

-(void) initButtonMatrix {
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"Mo", @"Di", @"Mi", @"Do", @"Fr", @"Sa", @"So", nil];
    NSArray *remainingDays = [NSArray arrayWithObjects:@"-3", @"-2", @"-1", nil];
    
    
    //Images daytime
    
    UIImageView *morningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 85, 30, 30)];
    UIImage *morningImage = [UIImage imageNamed:@"morning@2x"];
    morningImageView.image = morningImage;
    [self.view addSubview:morningImageView];
    
    UIImageView *noonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 85, 30, 30)];
    UIImage *noonImage = [UIImage imageNamed:@"noon@2x"];
    noonImageView.image = noonImage;
    [self.view addSubview:noonImageView];
    
    UIImageView *eveningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 85, 30, 30)];
    UIImage *eveningImage = [UIImage imageNamed:@"evening@2x"];
    eveningImageView.image = eveningImage;
    [self.view addSubview:eveningImageView];
    
    UIImageView *nightImageViews = [[UIImageView alloc] initWithFrame:CGRectMake(280, 85, 30, 30)];
    UIImage *nightImage = [UIImage imageNamed:@"night@2x"];
    nightImageViews.image = nightImage;
    [self.view addSubview:nightImageViews];
    
    
    // Images before/after MEal
    UIImage *appleBig = [UIImage imageNamed:@"apfel_ganz"];
    UIImage *appleSmall = [UIImage imageNamed:@"apfel_biss"];
    
    UIImageView *morningPre= [[UIImageView alloc] initWithFrame:CGRectMake(55, 120, 30,30)];
    morningPre.image = appleBig;
    [self.view addSubview:morningPre];

    UIImageView *morningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(90, 120, 30,30)];
    morningAfter.image = appleSmall;
    [self.view addSubview:morningAfter];
    
    UIImageView *noonPre= [[UIImageView alloc] initWithFrame:CGRectMake(130, 120,30,30)];
    noonPre.image = appleBig;
    [self.view addSubview:noonPre];
    
    UIImageView *noonAfter= [[UIImageView alloc] initWithFrame:CGRectMake(165, 120, 30,30)];
    noonAfter.image = appleSmall;
    [self.view addSubview:noonAfter];
    
    UIImageView *eveningPre= [[UIImageView alloc] initWithFrame:CGRectMake(205, 120, 30,30)];
    eveningPre.image = appleBig;
    [self.view addSubview:eveningPre];
    
    UIImageView *eveningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(240, 120, 30,30)];
    eveningAfter.image = appleSmall;
    [self.view addSubview:eveningAfter];
    
    //label weekdays
    
    int row = 150;
    
    for (int i = 0; i < 7; i++) {
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(10.0, row, 50.0, 43.0) withText:weekdays[i]];
        row += 27.0;
    }
    
    //label consult
    row = 395;
    
    for (int i = 0; i < 3; i++) {
        [self addLabelAtColumn:0 atRow:0 atPosition:CGRectMake(12.0, row, 50.0, 43.0) withText:remainingDays[i]];
        row += 30.0;
    }
    
    //Restzeit bis Arztbesuchs
    UILabel *doctorConsultLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 350.0, 350.0, 43.0) ];
    doctorConsultLabel.textAlignment =  NSTextAlignmentLeft;
    doctorConsultLabel.textColor = [UIColor blackColor];
    doctorConsultLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    doctorConsultLabel.text = @"Drei Tage bis zur nächsten Arztkonsultation";
    [self.view addSubview:doctorConsultLabel];
    
    //Buttons matrix weekdays
    row = 159;
    int column = 50;
    for (int rowId = 0; rowId < 7; rowId++) {
        
        column = 50;
        
        for (int columnId=0; columnId < 7; columnId++) {
            [self addButtonAtColumn:0 atRow:0 atPosition:CGRectMake(column, row, 23.0, 23.0)];
            column += 39;
        }
        
        if (rowId == 4) { row += 3; } //HACK: Layout not fitting at 4th row
        
        row += 27.5;
        
    }
    
    row = 405; // create matrix for resting days to doctor visit
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
    [self.view addSubview:button];
}

-(void)addLabelAtColumn:(NSInteger)column atRow:(NSInteger)row atPosition:(CGRect)pos withText:(NSString*)text {
    UILabel *label09 = [ [UILabel alloc ] initWithFrame:pos ];
    label09.textAlignment =  NSTextAlignmentLeft;
    label09.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label09.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label09.text = text;
    [self.view addSubview:label09];
}

-(void)timeSelected:(id)sender {
    UIButton *tempBtn=(UIButton *) sender;
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateNormal];
    NSString * string = [NSString stringWithFormat:@"%d", tempBtn.tag];
    NSLog(string) ;
}


@end
