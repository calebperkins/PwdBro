//
//  AppController.h
//  PwdBro
//
//  Created by Caleb Perkins on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject {
    IBOutlet NSSecureTextField* passwordField;
    IBOutlet NSTextField* hashOutput;
    IBOutlet NSTextField* addressField;
    IBOutlet NSButton* copyButton;
    IBOutlet NSApplication* app;
    IBOutlet NSWindow* window;
}

-(IBAction)copyToClipboard:(id)sender;

@end
