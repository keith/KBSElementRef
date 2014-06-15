//
//  NSPasteboard+Save.m
//  Example
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "NSPasteboard+Save.h"

@implementation NSPasteboard (Save)

- (NSArray *)saveContents
{
    NSMutableArray *archive = [NSMutableArray array];
    for (NSPasteboardItem *item in [self pasteboardItems]) {
        NSPasteboardItem *archivedItem = [[NSPasteboardItem alloc] init];
        for (NSString *type in [item types]) {
            NSData *data = [item dataForType:type];
            if (data) {
                [archivedItem setData:data forType:type];
            }
        }
        [archive addObject:archivedItem];
    }

    return archive;
}

- (void)restoreContents:(NSArray *)array
{
    [self clearContents];
    [self writeObjects:array];
}

@end
