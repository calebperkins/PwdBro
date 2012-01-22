//
//  AppController.h
//  PwdBro
//
//  Created by Caleb Perkins on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject {
    IBOutlet NSMenu* statusMenu;
    IBOutlet NSSecureTextField* passwordField;
    IBOutlet NSTextField* hashOutput;
    IBOutlet NSTextField* addressField;
    IBOutlet NSButton* copyButton;
    
    NSStatusItem* statusItem;
    NSImage* statusImage;
    NSImage* statusHighlightImage;
}

-(IBAction)copyToClipboard:(id)sender;

@end
