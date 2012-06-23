//
//  SiteList.h
//  PwdBro
//
//  Created by Caleb Perkins on 1/27/12.
//  Copyright (c) 2012 Caleb Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteList : NSObject {
    @private
    NSMutableOrderedSet* sites;
    NSUserDefaults* defaults;
}

extern NSString* const DomainsKey;
- (void)addSite:(NSString*)site;

@end
