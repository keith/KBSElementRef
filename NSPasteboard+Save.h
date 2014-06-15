//
//  NSPasteboard+Save.h
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

@interface NSPasteboard (Save)

- (NSArray *)saveContents;
- (void)restoreContents:(NSArray *)array;

@end
