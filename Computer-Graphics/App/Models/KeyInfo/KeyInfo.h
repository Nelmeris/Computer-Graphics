//
//  KeyInfo.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface KeyInfo : NSObject {
    NSString* description;
}

@property (nonatomic, readonly) unsigned short code;
@property (nonatomic, readonly) bool commandIsClamped;
@property (nonatomic, readonly) bool shiftIsClamped;
@property (nonatomic, readonly) bool optionIsClamped;

- (instancetype)initWithEvent:(NSEvent*)event;
- (instancetype)initWithKeyCode:(unsigned short)keyCode modifiedFlags:(NSEventModifierFlags)modifierFlags;
- (instancetype)initWithKeyCode:(unsigned short)keyCode modifiedFlags:(NSEventModifierFlags)modifierFlags description:(NSString*)description;

@end
