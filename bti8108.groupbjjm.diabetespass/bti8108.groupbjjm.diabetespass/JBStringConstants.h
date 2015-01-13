//
//  JBStringConstants.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//
//  Source: https://github.com/Jawbone/JBChartView/tree/master/JBChartViewDemo
//  Edited by Johannes Gnägi on 08-12-2014

#define localize(key, default) NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], default, nil)

#pragma mark - Labels

#pragma mark - Labels (Bar Chart)

#define kJBStringLabel2012 localize(@"label.2012", @"2012")
#define kJBStringLabelAverageMonthlyTemperature localize(@"label.average.monthly.temperature", @"Average Monthly Temperature")
#define kJBStringLabelWorldwide2012 localize(@"label.worldwide.2013", @"Worldwide - 2012")
#define kJBStringLabelWorldwide2011 localize(@"label.worldwide.2013", @"Worldwide - 2011")
#define kJBStringLabelWorldwideAverage localize(@"label.worldwide.average", @"Worldwide Average")
#define kJBStringLabelDegreesFahrenheit localize(@"label.degrees.fahrenheit", @"%d%@F")
#define kJBStringLabelDegreeSymbol localize(@"label.degree.symbol", @"\u00B0")

#pragma mark - Labels (Line Chart)

#define kJBStringLabel2013 localize(@"label.2013", @"Blutzucker")
#define kJBStringLabelSanFrancisco2013 localize(@"label.san.francisco.2013", @"aktuelle Woche")
#define kJBStringLabelAverageDailyRainfall localize(@"label.average.daily.rainfall", @"Blutzuckerwerte")
#define kJBStringLabelMm localize(@"label.mmmol/L", @"mmol/L")
#define kJBStringLabelMetropolitanAverage localize(@"label.metropolitan.average", @"gemessener Wert am 28-11-2014")
#define kJBStringLabelNationalAverage localize(@"label.national.average", @"Grenzwert")

#pragma mark - Labels (Area Chart)

#define kJBStringLabel2011 localize(@"label.2011", @"2011")
#define kJBStringLabelSeattle2014 localize(@"label.seattle.2014", @"Seattle - 2014")
#define kJBStringLabelAverageShineHoursOfSunMoon localize(@"label.average.shine.hours.of.sun.moon", @"Average Shine Hours of Sun/Moon")
#define kJBStringLabelAverageShineHours localize(@"label.average.shine.hours", @"Average Shine Hours")
#define kJBStringLabelHours localize(@"label.hours", @"h")
#define kJBStringLabelMoon localize(@"label.moon", @"Moon")
#define kJBStringLabelSun localize(@"label.sun", @"Sun")
