//
//  CPAppDelegate.m
//  PwdBro
//
//  Created by Caleb Perkins on 1/17/12.
//  Copyright (c) 2012 Caleb Perkins. All rights reserved.
//

#import "CPAppDelegate.h"

@implementation CPAppDelegate

@synthesize window = _window;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
