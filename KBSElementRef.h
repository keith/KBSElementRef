//
//  KBSElementRef.h
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBSElementRef : NSObject

@property (assign) AXUIElementRef elementRef;

+ (instancetype)systemWideRef;
+ (instancetype)focusedApplicationRef;

- (id)initWithElementRef:(AXUIElementRef)ref;

- (BOOL)performSelectAll;
- (NSString *)performCopyWithItemNamed:(NSString *)name;

@end
