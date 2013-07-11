//
//  KBSElementRef.m
//
//  Created by Keith Smiley on 7/10/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KBSElementRef.h"
#import "NSPasteboard+Save.h"

@implementation KBSElementRef

+ (instancetype)systemWideRef {
    static KBSElementRef *systemWideRef = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemWideRef = [[KBSElementRef alloc] initWithElementRef:AXUIElementCreateSystemWide()];
    });
    
    return systemWideRef;
}

+ (instancetype)focusedApplicationRef {
    return [[KBSElementRef systemWideRef] valueForAttribute:kAXFocusedApplicationAttribute];
}

- (id)initWithElementRef:(AXUIElementRef)ref {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.elementRef = CFRetain(ref);
    
    return self;
}

- (void)dealloc {
    CFRelease(self.elementRef);
}

#pragma mark - Getters

- (KBSElementRef *)application {
    KBSElementRef *ref = self;
    while (ref && ![[ref role] isEqualToString:(NSString *)kAXApplicationRole]) {
        ref = [ref parent];
    }
    
    return ref;
}

- (KBSElementRef *)menuBar {
    return [[self application] valueForAttribute:kAXMenuBarAttribute];
}

- (KBSElementRef *)editMenu {
    KBSElementRef *menuBar = [self menuBar];
    NSArray *children = [menuBar children];
    KBSElementRef *editMenu = [[[children objectAtIndex:3] children] lastObject];
    return editMenu;
}

- (KBSElementRef *)parent {
    return [self valueForAttribute:kAXParentAttribute];
}

- (KBSElementRef *)focusedElement {
    return [self valueForAttribute:kAXFocusedUIElementAttribute];
}

- (NSString *)title {
    return [self valueForAttribute:kAXTitleAttribute];
}

- (NSString *)role {
    return [self valueForAttribute:kAXRoleAttribute];
}

- (NSArray *)children {
    return [self valueForAttribute:kAXChildrenAttribute];
}

- (BOOL)enabled {
    return [[self valueForAttribute:kAXEnabledAttribute] boolValue];
}

- (BOOL)isFocused {
    return [[self valueForAttribute:kAXFocusedAttribute] boolValue];
}

- (id)valueForAttribute:(CFStringRef)attribute {
    id value = nil;
    CFTypeRef theValue = nil;
    AXError error = AXUIElementCopyAttributeValue(self.elementRef, attribute, &theValue);
    if (error != kAXErrorSuccess) {
        if ([[self role] isEqualToString:(NSString *)kAXMenuRole] && [(__bridge NSString *)attribute isEqualToString:(NSString *)kAXTitleAttribute]) {
            return nil;
        }
        NSLog(@"Value error for %@ code %d role: %@", attribute, error, [self role]);
        return nil;
    }

    if (CFGetTypeID(theValue) == CFBooleanGetTypeID()) {
        value = [NSNumber numberWithBool:theValue == kCFBooleanTrue];
    } else if (CFGetTypeID(theValue) == AXUIElementGetTypeID()) {
        value = [[KBSElementRef alloc] initWithElementRef:theValue];
    } else if (CFGetTypeID(theValue) == CFArrayGetTypeID()) {
        CFIndex count = CFArrayGetCount(theValue);
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
        for (CFIndex i = 0; i < count; i++) {
            AXUIElementRef elementRef = CFArrayGetValueAtIndex(theValue, i);
            KBSElementRef *ref = [[KBSElementRef alloc] initWithElementRef:elementRef];
            [array addObject:ref];
        }
        
        value = array;
    } else {
        value = [[(__bridge id)theValue description] copy];
    }
    
    CFRelease(theValue);
    return value;
}

- (BOOL)isTextField {
    NSString *role = [self role];
    if ([role isEqualToString:(NSString *)kAXTextAreaRole] || [role isEqualToString:(NSString *)kAXTextFieldRole]) {
        return true;
    }
    
    return false;
}

#pragma mark -

- (KBSElementRef *)menuItemWithName:(NSString *)name {
    KBSElementRef *editMenu = [self editMenu];
    return [self menuItemWithName:name inMenu:editMenu];
}

- (KBSElementRef *)menuItemWithName:(NSString *)name inMenu:(KBSElementRef *)menu {
    if ([[menu title] isEqualToString:name]) {
        return menu;
    }

    for (KBSElementRef *ref in [menu children]) {
        KBSElementRef *searched = [self menuItemWithName:name inMenu:ref];
        if (searched) {
            return searched;
        }
    }

    return nil;
}

#pragma mark -

- (BOOL)performSelectAll {
    KBSElementRef *selectAllMenuItem = [self menuItemWithName:@"Select All"];
    if ([selectAllMenuItem enabled]) {
        AXError error = 0;
        error = AXUIElementPerformAction(selectAllMenuItem.elementRef, kAXPressAction);
        if (error != kAXErrorSuccess) {
            NSLog(@"Error pressing Select All: %d", error);
        } else {
            return true;
        }
    }
    
    return false;
}

- (NSString *)performCopyWithItemNamed:(NSString *)name {
    if (!name) {
        name = @"Copy";
    }
    
    KBSElementRef *copyItem = [self menuItemWithName:name];
    if (copyItem) {
        NSPasteboard *pb = [NSPasteboard generalPasteboard];
        NSArray *pbContents = [pb saveContents];
        pbContents = nil;

        NSInteger change = [pb changeCount];
        if (AXUIElementPerformAction(copyItem.elementRef, kAXPressAction) == kAXErrorSuccess) {
            while ([pb changeCount] == change) {
                usleep(10000);
            }
        } else {
            NSLog(@"Error copying");
            if (pbContents) {
                [pb restoreContents:pbContents];
            }
            
            return @"";
        }
        
        NSString *text = [pb stringForType:NSPasteboardTypeString];
//        NSLog(@"T: %@", text);
        if (!text) {
            text = [pb stringForType:NSPasteboardTypeHTML];
            NSLog(@"Text was nil, got %@", text);
        }
        
        if (pbContents) {
            [pb restoreContents:pbContents];
        }
        
        return text;
    } else {
        NSLog(@"Copy item not enabled");
    }
    
    return @"";
}

@end
