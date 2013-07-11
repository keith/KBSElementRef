//
//  NSPasteboard+Save.m
//  Example
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "NSPasteboard+Save.h"

@implementation NSPasteboard (Save)

//- (NSDictionary *)saveContents {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    for (NSString *type in [self types]) {
//        NSData *data = [self dataForType:type];
//        if (data) {
//            [dict setObject:data forKey:type];
//        }
//    }
//    
//    return dict;
//}
//
//- (void)restoreContents:(NSDictionary *)dict {
//    [self clearContents];
//    for (NSString *type in dict) {
//        [self setData:[dict objectForKey:type] forType:type];
//    }
//}

- (NSArray *)saveContents {
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

- (void)restoreContents:(NSArray *)arr {
    [self clearContents];
    [self writeObjects:arr];
}

@end
