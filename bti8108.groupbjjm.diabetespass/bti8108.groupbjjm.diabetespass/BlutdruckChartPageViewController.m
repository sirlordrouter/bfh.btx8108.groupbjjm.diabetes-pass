//
//  BlutdruckChartPageViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 20.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "BlutdruckChartPageViewController.h"
#import "JBBarChartView.h"
#import "JBChartInformationView.h"

// Numerics
//CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
//CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
//CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
//CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
//CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
//CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
//NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;
//CGFloat const kJBBarChartViewControllerBarPadding = 1.0f;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
//NSInteger const kJBBarChartViewControllerMinBarHeight = 5;



@interface BlutdruckChartPageViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *monthlySymbols;


@end



@implementation BlutdruckChartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.dataSource = self;
    self.barChartView.delegate = self;
    [self.view addSubview:self.barChartView];
    
    self.barChartView.frame = CGRectMake(10.0f, 10.0f, self.view.bounds.size.width - (10.0f * 2), 250.0f);
    [self.barChartView reloadData];
    
}

- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerNumBars), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];
        
    }
    _chartData = [NSArray arrayWithArray:mutableChartData];
    _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return 6; // number of bars in chart
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    return [[self.chartData objectAtIndex:index] floatValue];
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 10.0f;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
