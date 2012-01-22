//
//  AppController.m
//  PwdBro
//
//  Created by Caleb Perkins on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "PwdHash.h"

@implementation AppController

-(void) awakeFromNib {
    return;
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    NSBundle* bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"lock-icon"]];
    statusHighlightImage = statusImage;
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"PwdBro"];
    [statusItem setHighlightMode:YES];
}

-(IBAction)copyToClipboard:(id)sender {
    NSPasteboard* board = [NSPasteboard generalPasteboard];
    [board clearContents];
    [board writeObjects:[NSArray arrayWithObject:[hashOutput stringValue]]];
}

- (void)controlTextDidChange:(NSNotification *)notice {
    NSString* hash = [PwdHash getHashedPasswordWithPasswordAndURL:[passwordField stringValue] url:[addressField stringValue]];
    [hashOutput setStringValue:hash];
}

@end
