//
//  AppController.h
//  PwdBro
//
//  Created by Caleb Perkins on 1/21/12.
//  Copyright (c) 2012 Caleb Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteList.h"

@interface AppController : NSObject {
    IBOutlet NSSecureTextField* passwordField;
    IBOutlet NSTextField* hashOutput;
    IBOutlet NSComboBox* addressBox;
    IBOutlet NSButton* copyButton;
    IBOutlet NSWindow* window;
    IBOutlet SiteList* sites;
    
    @private
    NSPasteboard* pasteBoard;
}

-(IBAction)copyToClipboard:(id)sender;

@end
