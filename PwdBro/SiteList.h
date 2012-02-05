//
//  SiteList.h
//  PwdBro
//
//  Created by Caleb Perkins on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteList : NSObject {
    @private
    NSMutableOrderedSet* sites;
}

- (void)addSite:(NSString*)site;

@end
