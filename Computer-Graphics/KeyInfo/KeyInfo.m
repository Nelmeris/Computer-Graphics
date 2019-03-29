//
//  KeyInfo.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "KeyInfo.h"

@implementation KeyInfo

- (instancetype)initWithEvent:(NSEvent*)event {
    self = [super init];
    if (self) {
        _code = [event keyCode];
        _commandIsClamped = ([event modifierFlags] & NSEventModifierFlagCommand);
        _shiftIsClamped = ([event modifierFlags] & NSEventModifierFlagShift);
        _optionIsClamped = ([event modifierFlags] & NSEventModifierFlagOption);
    }
    return self;
}

- (instancetype)initWithKeyCode:(unsigned short)keyCode modifiedFlags:(NSEventModifierFlags)modifierFlags {
    self = [super init];
    if (self) {
        _code = keyCode;
        _commandIsClamped = (modifierFlags & NSEventModifierFlagCommand);
        _shiftIsClamped = (modifierFlags & NSEventModifierFlagShift);
        _optionIsClamped = (modifierFlags & NSEventModifierFlagOption);
    }
    return self;
}

- (instancetype)initWithKeyCode:(unsigned short)keyCode modifiedFlags:(NSEventModifierFlags)modifierFlags description:(NSString*)description {
    self = [super init];
    if (self) {
        _code = keyCode;
        _commandIsClamped = (modifierFlags & NSEventModifierFlagCommand);
        _shiftIsClamped = (modifierFlags & NSEventModifierFlagShift);
        _optionIsClamped = (modifierFlags & NSEventModifierFlagOption);
        self->description = description;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    KeyInfo *secondKeyInfo = (KeyInfo *)object;
    return _code == secondKeyInfo.code
            && _commandIsClamped == secondKeyInfo.commandIsClamped
            && _shiftIsClamped == secondKeyInfo.shiftIsClamped
            && _optionIsClamped == secondKeyInfo.optionIsClamped;
}

- (NSString *)description
{
    return description;
}

@end
