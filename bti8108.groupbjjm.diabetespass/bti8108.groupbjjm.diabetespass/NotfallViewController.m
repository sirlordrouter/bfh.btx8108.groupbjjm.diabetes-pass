//
//  ViewController.m
//  NotfallPass2
//
//  Created by Jan Wiebe van der Sluis on 13/11/14.
//  Copyright (c) 2014 Jan Wiebe van der Sluis. All rights reserved.
//

#import "NotfallViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface NotfallViewController ()


@end

@implementation NotfallViewController
@synthesize myTextField;

//Standardtekst um den UITextView zu füllen. Beim Laden des Views wird die Tekst neu gesetzt.
NSString *standardNotFallTekst = @"Falls ich bewusstlos bin, geben Sie mir nichts und rufen Sie sofort einen Arzt oder Notfalldienst! \n\nFalls ich mich ungewöhnlich Verhalte und den Eindruck erwecke, als wäre ich betrunken, kann dies ein Zeichen einer Unterzuckerung sein.\n\nBitte geben Sie mir 20g Zucker, z.B als 2 dl gesüsstes Getränk (nicht light Varianten) oder mind. 4 Stück Traubenzucker oder Würfelzucker. Verbessert sich mein Zustand nicht inner 10 Minuten, rufen Sie einen Arzt oder Notfalldienst.";


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)copyText:(id)sender {
    //Popup View anzeigen mit Buttons
    UIAlertView *message = [[UIAlertView alloc]
                            initWithTitle:@"Infotekst wurde in der Zwischenablage kopiiert"
                            message:@"Sie können wenn Sie möchten direkt in den Notfallpass wechseln"
                            delegate:nil
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:@"Notfallpass", nil];
    
    [message show];
    
    //Tekst aus Textfeld kopieren.
    NSString *textFromTextField = myTextField.text;
    
    //Kontrolle ob text kopiert wurde. Ausgabe in NSLog
    // NSLog(textFromTextField);
    _myCopiedstring = textFromTextField;
    NSLog(_myCopiedstring);
    
    //Calling the systems pasteboard
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString *text = _myCopiedstring;
    //Setting the PasteboardItem to the Copied String from the textfield
    [pb setValue:text forPasteboardType:(NSString *)kUTTypeText];
    
    //Presenting the Result in the Log.
    NSLog(@"%@", [pb items]);
}

- (IBAction)openNotfallApp:(id)sender{
  
    }
@end
