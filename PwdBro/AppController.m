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

-(IBAction)copyToClipboard:(id)sender {
    if ([[hashOutput stringValue] length] == 0) {
        return;
    }
    
    NSPasteboard* board = [NSPasteboard generalPasteboard];
    [board clearContents];
    [board writeObjects:[NSArray arrayWithObject:[hashOutput stringValue]]];
    
    [copyButton setEnabled:NO];
    [app hide:sender];
    [window makeFirstResponder:addressField];
}

- (void)controlTextDidChange:(NSNotification *)notice {
    [copyButton setEnabled:YES];
    NSString* hash = [PwdHash getHashedPasswordWithPasswordAndURL:[passwordField stringValue] url:[addressField stringValue]];
    [hashOutput setStringValue:hash];
}

@end
