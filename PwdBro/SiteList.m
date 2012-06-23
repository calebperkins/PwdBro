//
//  SiteList.m
//  PwdBro
//
//  Created by Caleb Perkins on 1/27/12.
//  Copyright (c) 2012 Caleb Perkins. All rights reserved.
//

#import "SiteList.h"

@implementation SiteList

NSString* const DomainsKey = @"domains";

- (void)awakeFromNib {
    defaults = [NSUserDefaults standardUserDefaults];
    sites = [[defaults arrayForKey:DomainsKey] mutableCopy];
    if (!sites) {
        sites = [NSMutableArray new];
    }
}

- (void)addSite:(NSString*)site {
    [sites addObject:site];
    [defaults setObject:sites forKey:DomainsKey];
    [defaults synchronize];
}

#pragma mark Data Source

// Autocomplete domain
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString {    
    NSUInteger index = [sites indexOfObjectPassingTest:^BOOL(id site, NSUInteger idx, BOOL *stop) {
        return [site hasPrefix:uncompletedString];
    }];
    return (index == NSNotFound) ? nil : [sites objectAtIndex:index];
}

// Returns the index of the combo box item matching the specified string.
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)aString {
    return[sites indexOfObjectPassingTest:^BOOL(id site, NSUInteger idx, BOOL *stop) {
        return [site isEqualToString:aString];
    }];
}

// Returns the object that corresponds to the item at the specified index in the combo box.
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return [sites objectAtIndex:index];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [sites count];
}

@end
