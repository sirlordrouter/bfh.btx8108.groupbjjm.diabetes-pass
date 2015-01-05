//
//  WeightPickerView.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 05.01.15.
//  Copyright (c) 2015 Berner Fachhochschule. All rights reserved.
//  https://github.com/microsoft-hsg/HealthVault-Mobile-iOS-Library
//

#import <UIKit/UIKit.h>

@interface WeightPickerView : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate> {
    /// Displays current weight value.
    UILabel *_textField;
    int _value;
    int _partOfValue;
    /// Indicates that picker is shown.
    BOOL _isShown;
}

/// Gets or sets textfield which accepts selected value from picker view.
@property(retain) UILabel *textField;
/// Indicates that picker view is shown.
@property(assign, readonly) BOOL isShown;
/// Shows picker with animation.
- (void)show;
/// Hides picker with animation.
- (void)hide;
/// Sets picker's value.
/// @param value - value of weight in pounds.
- (void)setValue: (double)value;

@end
