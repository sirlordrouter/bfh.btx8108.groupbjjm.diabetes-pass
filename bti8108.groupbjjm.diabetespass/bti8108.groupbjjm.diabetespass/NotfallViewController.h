//
//  ViewController.h
//  NotfallPass2
//
//  Created by Jan Wiebe van der Sluis on 13/11/14.
//  Copyright (c) 2014 Jan Wiebe van der Sluis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotfallViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIView *NotFallView;
//Text aus dem Textfeld kopieren und in der zwischenablage ablegen.
- (IBAction)copyTextFromTextField:(id)sender;
//Open IOS NotfallApp ist nicht möglich bis auf weiteres...
- (IBAction)openNotfallApp:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *myTextField;

@property (getter=isPersistent, nonatomic) UIPasteboard *generalPasteboard;
@property(nonatomic, copy) NSString *myCopiedstring;


@end

