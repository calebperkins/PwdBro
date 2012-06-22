//
//  SiteList.m
//  PwdBro
//
//  Created by Caleb Perkins on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SiteList.h"

@implementation SiteList

- (void)awakeFromNib {
    sites = [NSMutableOrderedSet new];
    [self addSite:@"apple.com"];
    [self addSite:@"google.com"];
    [self addSite:@"battle.net"];
}

- (void)addSite:(NSString*)site {
    [sites addObject:site];
}

#pragma mark Data Source

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString {
    for (NSString* site in sites) {
        if ([site hasPrefix:uncompletedString]) {
            return site;
        };
    }
    return nil;
}

// Returns the index of the combo box item matching the specified string.
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)aString {
    NSUInteger index = 0;
    for (NSString* site in sites) {
        if ([site isEqualToString:aString]) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

// Returns the object that corresponds to the item at the specified index in the combo box.
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return [sites objectAtIndex:index];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [sites count];
}

@end
