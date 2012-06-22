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

- (void)awakeFromNib {
    pasteBoard = [NSPasteboard generalPasteboard];
}

-(IBAction)copyToClipboard:(id)sender {
    if ([[hashOutput stringValue] length] == 0) {
        return;
    }
    
    // Copy to clipboard
    [pasteBoard clearContents];
    [pasteBoard writeObjects:[NSArray arrayWithObject:[hashOutput stringValue]]];
    
    // Hide buttons
    [NSApp hide:sender];
    [window makeFirstResponder:addressBox];
    
    // Save to address list
    [sites addSite:[PwdHash extractDomainFromURL:[addressBox stringValue]]];
}

- (void)controlTextDidChange:(NSNotification *)notice {    
    NSString* hash = [PwdHash getHashedPasswordWithPasswordAndURL:[passwordField stringValue]
                                                              url:[addressBox stringValue]];
    [hashOutput setStringValue:hash];
}

@end
