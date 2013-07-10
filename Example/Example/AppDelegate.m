//
//  AppDelegate.m
//  Example
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "AppDelegate.h"
#import "KBSElementRef.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(test) userInfo:nil repeats:true];
}

- (void)test {
    KBSElementRef *app = [KBSElementRef focusedApplicationRef];
    [app performSelectAll];
}

@end
