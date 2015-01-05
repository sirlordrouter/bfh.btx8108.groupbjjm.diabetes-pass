//
//  WeightPickerView.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 05.01.15.
//  Copyright (c) 2015 Berner Fachhochschule. All rights reserved.
//

#import "WeightPickerView.h"


/// Maximum value for picker view.
#define WEIGHT_PICKER_MAX_VALUE 300
/// Count of fraction for value.
#define WEIGHT_PICKER_FRACTION_VALUES_COUNT 10
/// Width for "Value" component.
#define VALUE_COMPONENT_WIDTH 120
/// Width for "Value Fractional" component.
#define VALUE_FRACTIONAL_COMPONENT_WIDTH 70
/// Width for "Title" component.
#define TITLE_COMPONENT_WIDTH 100
/// Caption for "Title" component.
#define TITLE_COMPONENT_CAPTION @"kg"

/// Picker components.
enum {
    /// Shows value in pounds.
    ValueComponent,
    /// Shows fractional part of pound.
    ValueFractionalComponent,
    /// Contains title.
    TitleComponent,
    /// Components count in picker.
    ComponentsCount
};

@implementation WeightPickerView

@synthesize textField = _textField;
@synthesize isShown = _isShown;

- (id)init {
    if (self = [super init]) {
        self.dataSource = self;
        self.delegate = self;
        self.showsSelectionIndicator = YES;
        _isShown = NO;
        [self reloadAllComponents];
    }
    return self;
}


/// Shows picker with animation.
- (void)show {
    _isShown = YES;
    
    
    self.hidden = NO;
    //self.alpha = 0.0f;
    // Moves picker to bottom of superview.

    // Shows with animation picker.
    [UIView beginAnimations: nil
                    context: nil];
    [UIView setAnimationDuration: 1];

    [UIView commitAnimations];
}

/// Hides picker with animation.
- (void)hide {
    _isShown = NO;
    
    self.hidden = YES;
    //self.alpha = 0.0f;
    // Moves picker to bottom of superview with animation.
    [UIView beginAnimations: nil
                    context: nil];
    [UIView setAnimationDuration: 1];

    [UIView commitAnimations];
}

/// Sets picker's value.
/// @param value - value of weight
- (void)setValue: (double)value {
    _value = (int) value;
    _partOfValue = round((value - _value) * 10);
    [self selectRow: _value inComponent: ValueComponent animated: YES];
    [self selectRow: _partOfValue inComponent: ValueFractionalComponent animated: YES];
}
#pragma mark Picker Events
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)thePickerView {
    return ComponentsCount;
}
- (CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent: (NSInteger)component {
    switch (component) {
        case ValueComponent:
            return VALUE_COMPONENT_WIDTH;
        case ValueFractionalComponent:
            return VALUE_FRACTIONAL_COMPONENT_WIDTH;
    }
    return TITLE_COMPONENT_WIDTH;
}
- (NSInteger)pickerView: (UIPickerView *)thePickerView numberOfRowsInComponent: (NSInteger)component {
    switch (component) {
        case ValueComponent:
            return WEIGHT_PICKER_MAX_VALUE;
        case ValueFractionalComponent:
            return WEIGHT_PICKER_FRACTION_VALUES_COUNT;
    }
    // Returns default value. Title section contains one row.
    return 1;
}
- (UIView *)pickerView: (UIPickerView *)pickerView
            viewForRow: (NSInteger)row
          forComponent: (NSInteger)component
           reusingView: (UIView *)view {
    // custom label.
    UILabel *captionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 145, 45)];
    captionLabel.textAlignment = NSTextAlignmentCenter;
    captionLabel.opaque = NO;
    captionLabel.backgroundColor = [UIColor clearColor];
    captionLabel.textColor = [UIColor blackColor];
    captionLabel.font = [UIFont boldSystemFontOfSize: 20];
    switch (component) {
        case ValueComponent:
            captionLabel.text = [NSString stringWithFormat: @"%d", row];
            break;
        case ValueFractionalComponent:
            captionLabel.text = [NSString stringWithFormat: @".%d", row];
            break;
        case TitleComponent:
            captionLabel.text = TITLE_COMPONENT_CAPTION;
            break;
    }
    return captionLabel;
}
- (void)pickerView: (UIPickerView *)thePickerView
      didSelectRow: (NSInteger)row
       inComponent: (NSInteger)component {
    switch (component) {
        case ValueComponent:
            _value = row;
            break;
        case ValueFractionalComponent:
            _partOfValue = row;
            break;
    }
    // Sets value for text field.
    self.textField.text = [NSString stringWithFormat: @"%d.%d", _value, _partOfValue];
}
#pragma mark Picker Events End


@end
