//
//  SettingsWithingsViewController.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 03.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsWithingsViewController : UIViewController<UIWebViewDelegate> {
    
    NSString *userId;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;
@property (readonly, getter=getUserId) NSString *withingsUserId;

@end
