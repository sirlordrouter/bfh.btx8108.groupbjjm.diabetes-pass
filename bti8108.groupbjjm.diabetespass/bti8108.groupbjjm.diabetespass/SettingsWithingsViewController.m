//
//  SettingsWithingsViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 03.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
// Ideas from: integratingwithings.blogspot.in/2014/05/withings-api-declassified-ios.html
//

#import "SettingsWithingsViewController.h"
#import "OAuth1Controller.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"

@interface SettingsWithingsViewController()

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;


@end


@implementation SettingsWithingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.withingsController = self;
    
    
    [self.oauth1Controller loginWithWebView:self.webView completion:^(NSDictionary *oauthTokens, NSError *error) {
        
        if (!error) {
            
            // Store your tokens for authenticating your later requests, consider storing the tokens in the Keychain
            NSLog(@"self.oauthToken=%@,self.oauthTokenSecret",oauthTokens);
            self.oauthToken = oauthTokens[@"oauth_token"];
            self.oauthTokenSecret = oauthTokens[@"oauth_token_secret"];
            userId=oauthTokens[@"userid"];

            
            
        }
        else
        {
            NSLog(@"Error authenticating: %@", error.localizedDescription);
        }
        [self dismissViewControllerAnimated:YES completion: ^{
            self.oauth1Controller = nil;
        }];
    
    }];
}
    

- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

