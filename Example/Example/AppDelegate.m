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
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(test) userInfo:nil repeats:false];
}

- (void)test {
    KBSElementRef *app = [KBSElementRef focusedApplicationRef];
    [app performSelectAll];
    NSString *text = [app performCopyWithItemNamed:nil];
    if (text.length > 0) {
        NSLog(@"Y: %@", text);
    } else {
        NSLog(@"NO text");
    }
}

@end
