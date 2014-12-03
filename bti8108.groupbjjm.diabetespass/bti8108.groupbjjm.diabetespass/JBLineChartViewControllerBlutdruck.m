//
//  CheckupPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "JBLineChartViewControllerBlutdruck.h"

// Views
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSolid,
    JBLineChartLineDashed,
    JBLineChartLineCount
};

@interface JBLineChartViewControllerBlutdruck () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *daysOfWeek;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data

@end


/**
 <#Description#>
 */
@implementation JBLineChartViewControllerBlutdruck

// Numerics
CGFloat const BlutdruckGraphHeight = 250.0f;
CGFloat const BlutdruckGraphPadding = 10.0f;
CGFloat const BlutdruckGraphHeaderHeight = 75.0f;
CGFloat const BlutdruckGraphHeaderPadding = 20.0f;
CGFloat const BlutdruckGraphFooterHeight = 20.0f;
CGFloat const BlutdruckGraphSolidLineWidth = 6.0f;
CGFloat const BlutdruckGraphDashedLineWidth = 2.0f;
NSInteger const BlutdruckGraphMaxNumChartPoints = 20;

#pragma mark - Alloc/Init


- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

#pragma mark - Data

/**
 *  Initializes Data for the Chart as no Data is Provided yet by a Database
 *
 */
- (void)initFakeData
{
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    
    //6 Linien: syst / diast je 3
    
    for (int lineIndex=0; lineIndex<6; lineIndex++)
    {
        
        //according to http://www.blutdruckdaten.de/blutdruckwerte-tabelle.html
        if (lineIndex == 0) { //upper bound sys
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:(120.0)]];
            }
            [mutableLineCharts addObject:mutableChartData];
        } else if(lineIndex == 1){ //sys line
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)*150 + 60]]; // random number between 160 and 60
            }
            [mutableLineCharts addObject:mutableChartData];
        } else if (lineIndex == 2) { //lower bound sys
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:(90.0)]];
            }
            [mutableLineCharts addObject:mutableChartData];
        } else if (lineIndex == 3) { // upper bound dia
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:(80.0)]];
            }
            [mutableLineCharts addObject:mutableChartData];
        } else if (lineIndex == 4) { //line dia
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)*70 + 20]]; // random number between 90 and 20
            }
            [mutableLineCharts addObject:mutableChartData];
        }else { //lower bound dia
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithFloat:(40.0)]];
            }
            [mutableLineCharts addObject:mutableChartData];
        }
        
        
    }
    _chartData = [NSArray arrayWithArray:mutableLineCharts];
    
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<BlutdruckGraphMaxNumChartPoints; i++)
    {
        NSString *s = [[NSString stringWithFormat:@"%d", i+1] stringByAppendingString:@"-11-2014"];
        [mutableChartData addObject:s ];  //Generate Dates for x-Axis from 1-11 to 20-11
        
    }
    
    _daysOfWeek = mutableChartData;
}

- (NSArray *)largestLineData
{
    NSArray *largestLineData = nil;
    for (NSArray *lineData in self.chartData)
    {
        if ([lineData count] > [largestLineData count])
        {
            largestLineData = lineData;
        }
    }
    return largestLineData;
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];
        
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(BlutdruckGraphPadding, BlutdruckGraphPadding, self.view.bounds.size.width - (BlutdruckGraphPadding * 2), BlutdruckGraphHeight);
    self.lineChartView.delegate = self; //Handler for Events and Configuration
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = BlutdruckGraphHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    /*
     Header view with chart title and description
     
     */
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(BlutdruckGraphPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(BlutdruckGraphHeaderHeight * 0.5), self.view.bounds.size.width - (BlutdruckGraphPadding * 2), BlutdruckGraphHeaderHeight)];
    headerView.titleLabel.text = @"Blutdruck";
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = @"aktuelle Woche";
    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    
    /*
     Footer View == x-Axis line
     */
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(BlutdruckGraphPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(BlutdruckGraphFooterHeight * 0.5), self.view.bounds.size.width - (BlutdruckGraphPadding * 2), BlutdruckGraphFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[self.daysOfWeek firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[self.daysOfWeek lastObject] uppercaseString];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = [[self largestLineData] count];
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    
    /*
     
     Information for each point below the chart
     */
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    [self.view addSubview:self.informationView];
    
    [self setLabel:(BlutdruckGraphMaxNumChartPoints-2)];
    [self.lineChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded];
}

-(void) setLabel:(NSUInteger)index {
    NSNumber *valueNumber = [[self.chartData objectAtIndex:0] objectAtIndex:index];
    
    [self setTooltipVisible:YES animated:YES];
    //[self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
    NSString *value = [NSString stringWithFormat:@"%.2f", [valueNumber floatValue]];
    [self.tooltipView setText:value];
}

#pragma mark - JBChartViewDataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return false;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return false;
}

#pragma mark - JBLineChartViewDelegate

// y-position (y-axis) of point at horizontalIndex (x-axis)
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.2f", [valueNumber floatValue]] unitText:@"mmHg"];

    NSString *s = [self.daysOfWeek objectAtIndex:horizontalIndex];
    [self.informationView setTitleText:lineIndex == JBLineChartLineSolid ? s : kJBStringLabelNationalAverage];
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    //[self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
    NSString *value = [NSString stringWithFormat:@"%.2f", [valueNumber floatValue]];
    [self.tooltipView setText:value];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    //[self.informationView setHidden:YES animated:YES];
    //[self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    
    if (lineIndex == 1) {
        return [UIColor greenColor];
    } else if(lineIndex == 4) {
        return [UIColor blueColor];
    }else {
        return kJBColorLineChartDefaultDashedLineColor;
    }
    return (lineIndex == 1 || lineIndex == 4) ? [UIColor clearColor] : kJBColorLineChartDefaultDashedLineColor;
    //[UIColor clearColor]
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 1) {
        return [UIColor greenColor];
    } else if(lineIndex == 4) {
        return [UIColor blueColor];
    }else {
        return kJBColorLineChartDefaultDashedLineColor;
    }
    return (lineIndex == 1 || lineIndex == 4) ? [UIColor clearColor] : kJBColorLineChartDefaultDashedLineColor;}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 1) {
        return [UIColor greenColor];
    } else if(lineIndex == 4) {
        return [UIColor blueColor];
    }else {
        return kJBColorLineChartDefaultDashedLineColor;
    }
    return (lineIndex == 1 || lineIndex == 4) ? [UIColor clearColor] : kJBColorLineChartDefaultDashedLineColor;
}


- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == 1 || lineIndex == 4) ? JBLineChartViewLineStyleDashed: JBLineChartViewLineStyleSolid;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 0.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? [UIColor clearColor]: kJBColorLineChartDefaultDashedSelectedLineColor; //only points for blutzucker graph
}



- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == 1 || lineIndex == 4) ? JBLineChartViewLineStyleDashed : JBLineChartViewLineStyleSolid;
}

#pragma mark - Buttons



#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}

@end
