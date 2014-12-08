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
    
    //CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    [self initButtonMatrix];
}

-(void) initButtonMatrix {
    
    //Images daytime
    
    UIImageView *morningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 60, 44, 44)];
    UIImage *morningImage = [UIImage imageNamed:@"morning@2x"];
    morningImageView.image = morningImage;
    [self.view addSubview:morningImageView];
    
    UIImageView *noonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 60, 44, 44)];
    UIImage *noonImage = [UIImage imageNamed:@"noon@2x"];
    noonImageView.image = noonImage;
    [self.view addSubview:noonImageView];
    
    UIImageView *eveningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 60, 44, 44)];
    UIImage *eveningImage = [UIImage imageNamed:@"evening@2x"];
    eveningImageView.image = eveningImage;
    [self.view addSubview:eveningImageView];
    
    UIImageView *nightImageViews = [[UIImageView alloc] initWithFrame:CGRectMake(270, 60, 44, 44)];
    UIImage *nightImage = [UIImage imageNamed:@"night@2x"];
    nightImageViews.image = nightImage;
    [self.view addSubview:nightImageViews];
    
    
    // Images before/after MEal
    UIImage *appleBig = [UIImage imageNamed:@"apfel_ganz"];
    UIImage *appleSmall = [UIImage imageNamed:@"apfel_biss"];
    
    UIImageView *morningPre= [[UIImageView alloc] initWithFrame:CGRectMake(55, 105, 30,30)];
    morningPre.image = appleBig;
    [self.view addSubview:morningPre];

    UIImageView *morningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(90, 105, 30,30)];
    morningAfter.image = appleSmall;
    [self.view addSubview:morningAfter];
    
    UIImageView *noonPre= [[UIImageView alloc] initWithFrame:CGRectMake(130, 105,30,30)];
    noonPre.image = appleBig;
    [self.view addSubview:noonPre];
    
    UIImageView *noonAfter= [[UIImageView alloc] initWithFrame:CGRectMake(170, 105, 30,30)];
    noonAfter.image = appleSmall;
    [self.view addSubview:noonAfter];
    
    UIImageView *eveningPre= [[UIImageView alloc] initWithFrame:CGRectMake(210, 105, 30,30)];
    eveningPre.image = appleBig;
    [self.view addSubview:eveningPre];
    
    UIImageView *eveningAfter= [[UIImageView alloc] initWithFrame:CGRectMake(250, 105, 30,30)];
    eveningAfter.image = appleSmall;
    [self.view addSubview:eveningAfter];
    
    //label weekdays
    
    UILabel *label00 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 130.0, 50.0, 43.0) ];
    label00.textAlignment =  NSTextAlignmentLeft;
    label00.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label00.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label00.text = @"Mo";
    [self.view addSubview:label00];
    
    UILabel *label01 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 160.0, 50.0, 43.0) ];
    label01.textAlignment =  NSTextAlignmentLeft;
    label01.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label01.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label01.text = @"Di";
    [self.view addSubview:label01];
    
    UILabel *label02 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 190.0, 50.0, 43.0) ];
    label02.textAlignment =  NSTextAlignmentLeft;
    label02.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label02.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label02.text = @"Mi";
    [self.view addSubview:label02];
    
    UILabel *label03 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 220.0, 50.0, 43.0) ];
    label03.textAlignment =  NSTextAlignmentLeft;
    label03.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label03.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label03.text = @"Do";
    [self.view addSubview:label03];
    
    UILabel *label04 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 250.0, 50.0, 43.0) ];
    label04.textAlignment =  NSTextAlignmentLeft;
    label04.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label04.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label04.text = @"Fr";
    [self.view addSubview:label04];
    
    UILabel *label05 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 280.0, 50.0, 43.0) ];
    label05.textAlignment =  NSTextAlignmentLeft;
    label05.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label05.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label05.text = @"Sa";
    [self.view addSubview:label05];
    
    UILabel *label06 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 310.0, 50.0, 43.0) ];
    label06.textAlignment =  NSTextAlignmentLeft;
    label06.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label06.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label06.text = @"So";
    [self.view addSubview:label06];
    
    //Restzeit bis Arztbesuchs
    UILabel *doctorConsultLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 350.0, 350.0, 43.0) ];
    doctorConsultLabel.textAlignment =  NSTextAlignmentLeft;
    doctorConsultLabel.textColor = [UIColor blackColor];
    doctorConsultLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    doctorConsultLabel.text = @"Drei Tage vor der nächsten Arztkonsultation";
    [self.view addSubview:doctorConsultLabel];
    
    UILabel *label07 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 410.0, 50.0, 43.0) ];
    label07.textAlignment =  NSTextAlignmentLeft;
    label07.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label07.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label07.text = @"-3";
    [self.view addSubview:label07];
    
    UILabel *label08 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 440.0, 50.0, 43.0) ];
    label08.textAlignment =  NSTextAlignmentLeft;
    label08.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label08.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label08.text = @"-2";
    [self.view addSubview:label08];
    
    UILabel *label09 = [ [UILabel alloc ] initWithFrame:CGRectMake(5.0, 470.0, 50.0, 43.0) ];
    label09.textAlignment =  NSTextAlignmentLeft;
    label09.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    label09.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
    label09.text = @"-1";
    [self.view addSubview:label09];

    [self addButtonAtColumn:0 atRow:0 atPosition:[CGRectMake(55.0, 135.0, 30.0, 30.0)]];
    UIButton *button00 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button00 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button00 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
        //[button00 addTarget:self
        //           action:@selector(aMethod:)
        // forControlEvents:UIControlEventTouchUpInside];
    [button00 setFrame:];
    [self.view addSubview:button00];
    
    UIButton *button01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button01 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button01 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    //[button00 addTarget:self
    //           action:@selector(aMethod:)
    // forControlEvents:UIControlEventTouchUpInside];
    [button01 setFrame:CGRectMake(90.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button01];
    
    UIButton *button02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button02 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button02 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    //[button00 addTarget:self
    //           action:@selector(aMethod:)
    // forControlEvents:UIControlEventTouchUpInside];
    [button02 setFrame:CGRectMake(130.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button02];
    
    UIButton *button03 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button03 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button03 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    //[button00 addTarget:self
    //           action:@selector(aMethod:)
    // forControlEvents:UIControlEventTouchUpInside];
    [button03 setFrame:CGRectMake(170.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button03];
    
    UIButton *button04 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button04 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button04 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    //[button00 addTarget:self
    //           action:@selector(aMethod:)
    // forControlEvents:UIControlEventTouchUpInside];
    [button04 setFrame:CGRectMake(210.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button04];
    
    UIButton *button05 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button05 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button05 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    //[button00 addTarget:self
    //           action:@selector(aMethod:)
    // forControlEvents:UIControlEventTouchUpInside];
    [button05 setFrame:CGRectMake(250.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button05];
    
    UIButton *button06 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button06 setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    [button06 setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateSelected];
    [button00 addTarget:self
                 action:@selector(timeSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    [button06 setFrame:CGRectMake(290.0, 135.0, 30.0, 30.0)];
    [self.view addSubview:button06];
    
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

-(void)timeSelected:(id)sender {
    UIButton *tempBtn=(UIButton *) sender;
    NSString * string = [NSString stringWithFormat:@"%d", tempBtn.tag];
    NSLog(string) ;
}


@end
