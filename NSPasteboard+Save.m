//
//  NSPasteboard+Save.m
//  Example
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "NSPasteboard+Save.h"

@implementation NSPasteboard (Save)

- (NSDictionary *)saveContents {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *type in [self types]) {
        NSData *data = [self dataForType:type];
        if (data) {
            [dict setObject:data forKey:type];
        }
    }
    
    return dict;
}

- (void)restoreContents:(NSDictionary *)dict {
    [self clearContents];
    for (NSString *type in dict) {
        [self setData:[dict objectForKey:type] forType:type];
    }
}

@end
