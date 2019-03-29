//
//  GraphicViewProcessingHotkeyInfoArray.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicViewProcessingHotKeys.h"
#import <Carbon/Carbon.h>
#import "KeyInfo.h"

#define MOVE_SPEED 1
#define RAPID_MOVE_SPEED 10
#define INCREASE_SPEED 1.1
#define RAPID_INCREASE_SPEED 1.5
#define ROTATE_ANGLE 0.05
#define RAPID_ROTATE_ANGLE 0.25

@implementation GraphicView (HotkeyInfoArray)

- (NSArray*)keyInfoArray {
    return [NSArray arrayWithObjects:
            [[KeyInfo alloc] initWithKeyCode:kVK_Escape modifiedFlags:0 description:@"Reset"],
            // Move
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_W modifiedFlags:0 description:@"Move up"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_W modifiedFlags:NSEventModifierFlagShift description:@"Rapid Move up"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_A modifiedFlags:0 description:@"Move left"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_A modifiedFlags:NSEventModifierFlagShift description:@"Rapid Move left"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_S modifiedFlags:0 description:@"Move down"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_S modifiedFlags:NSEventModifierFlagShift description:@"Rapid Move down"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_D modifiedFlags:0 description:@"Move right"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_D modifiedFlags:NSEventModifierFlagShift description:@"Rapid Move right"],
            // Mirror frame
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_U modifiedFlags:0 description:@"Mirror frame relative to Ox"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_J modifiedFlags:0 description:@"Mirror frame relative to Oy"],
            // Decrease
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Z modifiedFlags:0 description:@"Decrease"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Z modifiedFlags:NSEventModifierFlagShift description:@"Rapid Decrease"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Z modifiedFlags:NSEventModifierFlagOption description:@"Decrease frame"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Z modifiedFlags:NSEventModifierFlagShift+NSEventModifierFlagOption description:@"Rapid Decrease frame"],
            // Increase
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_X modifiedFlags:0 description:@"Increase"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_X modifiedFlags:NSEventModifierFlagShift description:@"Rapid Increase"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_X modifiedFlags:NSEventModifierFlagOption description:@"Increase frame"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_X modifiedFlags:NSEventModifierFlagShift+NSEventModifierFlagOption description:@"Rapid Increase frame"],
            // Rotate counter-clockwise
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Q modifiedFlags:0 description:@"Rotate counter-clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Q modifiedFlags:NSEventModifierFlagShift description:@"Rapid Rotate counter-clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Q modifiedFlags:NSEventModifierFlagOption description:@"Rotate frame counter-clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_Q modifiedFlags:NSEventModifierFlagShift+NSEventModifierFlagOption description:@"Rapid Rotate frame counter-clockwise"],
            // Rotate clockwise
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_E modifiedFlags:0 description:@"Rotate clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_E modifiedFlags:NSEventModifierFlagShift description:@"Rapid Rotate clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_E modifiedFlags:NSEventModifierFlagOption description:@"Rotate frame clockwise"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_E modifiedFlags:NSEventModifierFlagShift+NSEventModifierFlagOption description:@"Rapid Rotate frame clockwise"],
            // Increase relative to Ox
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_I modifiedFlags:0 description:@"Increase relative to Ox"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_I modifiedFlags:NSEventModifierFlagShift description:@"Rapid Increase relative to Ox"],
            // Increase relative to Oy
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_O modifiedFlags:0 description:@"Decrease relative to Ox"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_O modifiedFlags:NSEventModifierFlagShift description:@"Rapid Decrease relative to Ox"],
            // Decrease relative to Ox
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_K modifiedFlags:0 description:@"Increase relative to Oy"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_K modifiedFlags:NSEventModifierFlagShift description:@"Rapid Increase relative to Oy"],
            // Decrease relative to Oy
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_L modifiedFlags:0 description:@"Decrease relative to Oy"],
            [[KeyInfo alloc] initWithKeyCode:kVK_ANSI_L modifiedFlags:NSEventModifierFlagShift description:@"Rapid Decrease relative to Oy"],
            nil
            ];
}

- (void)keyUp:(NSEvent *)theEvent {
    KeyInfo* keyInfo = [[KeyInfo alloc] initWithEvent:theEvent];
    
    for (int i = 0; i < [self keyInfoArray].count; i++)
    {
        if ([keyInfo isEqual:[[self keyInfoArray] objectAtIndex:i]])
        {
            [controller.keys addObject:(KeyInfo*)[[self keyInfoArray] objectAtIndex:i]];
            [controller.logTableView reloadData];
            if (keyInfo.code == kVK_Escape) { // Reset all transformations
                [self->transform reset];
                [self setNeedsDisplay: YES];
                return;
            }
            [self shufflekeyInfoArray:keyInfo];
            [self setNeedsDisplay: YES];
        }
    }
}

// Processing keyInfoArray
- (void)shufflekeyInfoArray:(KeyInfo*)keyInfo {
    
    switch (keyInfo.code) { // Universal keyInfoArray
        case kVK_ANSI_U: // Mirror frame relative to Ox
            [transform mirrorFrameRefByX];
            return;
        case kVK_ANSI_J: // Mirror frame relative to Oy
            [transform mirrorFrameRefByY];
            return;
    }
    
    [self shuffleDependentOnTheShiftAndOptionkeyInfoArray:keyInfo];
}

// Processing keyInfoArray while holding Shift & Option keyInfoArray
- (void)shuffleDependentOnTheShiftAndOptionkeyInfoArray:(KeyInfo*)keyInfo {
    if (keyInfo.shiftIsClamped && keyInfo.optionIsClamped) { // The Shift & Option keyInfoArray is clamped
        switch (keyInfo.code) {
            case kVK_ANSI_X: // Rapid Increase frame
                [transform scaleFrame:RAPID_INCREASE_SPEED];
                break;
            case kVK_ANSI_Z: // Rapid Decrease frame
                [transform scaleFrame:1 / RAPID_INCREASE_SPEED];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate frame counter-clockwise
                [transform rotateFrame:-RAPID_ROTATE_ANGLE];
                break;
            case kVK_ANSI_E: // Rapid Rotate frame clockwise
                [transform rotateFrame:RAPID_ROTATE_ANGLE];
                break;
        }
    } else { // The Shift & Option keyInfoArray isn't clamped at the same time
        [self shuffleDependentOnTheShiftkeyInfoArray:keyInfo];
        [self shuffleDependentOnTheOptionkeyInfoArray:keyInfo];
    }
}

// Processing keyInfoArray while holding Shift key
- (void)shuffleDependentOnTheShiftkeyInfoArray:(KeyInfo*)keyInfo {
    if (!keyInfo.shiftIsClamped) { // The Shift key isn't clamped
        switch (keyInfo.code) {
            case kVK_ANSI_W: // Move up
                [transform move:0 byY:MOVE_SPEED];
                break;
            case kVK_ANSI_S: // Move down
                [transform move:0 byY:-MOVE_SPEED];
                break;
            case kVK_ANSI_A: // Move left
                [transform move:-MOVE_SPEED byY:0];
                break;
            case kVK_ANSI_D: // Move right
                [transform move:MOVE_SPEED byY:0];
                break;
                
            case kVK_ANSI_Q: // Rotate counter-clockwise
                [transform rotate:-ROTATE_ANGLE];
                break;
            case kVK_ANSI_E: // Rotate clockwise
                [transform rotate:ROTATE_ANGLE];
                break;
                
            case kVK_ANSI_X: // Increase
                [transform scale:INCREASE_SPEED];
                break;
            case kVK_ANSI_Z: // Decrease
                [transform scale:1 / INCREASE_SPEED];
                break;
                
            case kVK_ANSI_I: // Increase relative to Ox
                [transform scaleFrameRefByX:INCREASE_SPEED];
                break;
            case kVK_ANSI_O: // Decrease relative to Ox
                [transform scaleFrameRefByX:1 / INCREASE_SPEED];
                break;
            case kVK_ANSI_K: // Increase relative to Oy
                [transform scaleFrameRefByY:INCREASE_SPEED];
                break;
            case kVK_ANSI_L: // Decrease relative to Oy
                [transform scaleFrameRefByY:1 / INCREASE_SPEED];
                break;
        }
    } else { // The Shift key is clamped
        switch (keyInfo.code) {
                
            case kVK_ANSI_W: // Rapid Move up
                [transform move:0 byY:RAPID_MOVE_SPEED];
                break;
            case kVK_ANSI_S: // Rapid Move down
                [transform move:0 byY:-RAPID_MOVE_SPEED];
                break;
            case kVK_ANSI_A: // Rapid Move left
                [transform move:-RAPID_MOVE_SPEED byY:0];
                break;
            case kVK_ANSI_D: // Rapid Move right
                [transform move:RAPID_MOVE_SPEED byY:0];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate counter-clockwise
                [transform rotate:-RAPID_ROTATE_ANGLE];
                break;
            case kVK_ANSI_E: // Rapid Rotate clockwise
                [transform rotate:RAPID_ROTATE_ANGLE];
                break;
                
            case kVK_ANSI_X: // Rapid Increase
                [transform scale:RAPID_INCREASE_SPEED];
                break;
            case kVK_ANSI_Z: // Rapid Decrease
                [transform scale:1 / RAPID_INCREASE_SPEED];
                break;
                
            case kVK_ANSI_I: // Rapid Increase relative to Ox
                [transform scaleFrameRefByX:RAPID_INCREASE_SPEED];
                break;
            case kVK_ANSI_O: // Rapid Decrease relative to Ox
                [transform scaleFrameRefByX:1 / RAPID_INCREASE_SPEED];
                break;
            case kVK_ANSI_K: // Rapid Increase relative to Oy
                [transform scaleFrameRefByY:RAPID_INCREASE_SPEED];
                break;
            case kVK_ANSI_L: // Rapid Decrease relative to Oy
                [transform scaleFrameRefByY:1 / RAPID_INCREASE_SPEED];
                break;
        }
    }
}

// Processing keyInfoArray while holding Option key
- (void)shuffleDependentOnTheOptionkeyInfoArray:(KeyInfo*)keyInfo {
    if (!keyInfo.optionIsClamped) { // The Option isn't clamped
    } else { // The Option key is clamped
        switch (keyInfo.code) {
            case kVK_ANSI_X: // Increase frame
                [transform scaleFrame:INCREASE_SPEED];
                break;
            case kVK_ANSI_Z: // Decrease frame
                [transform scaleFrame:1 / INCREASE_SPEED];
                break;
                
            case kVK_ANSI_Q: // Rotate frame counter-clockwise
                [transform rotateFrame:-ROTATE_ANGLE];
                break;
            case kVK_ANSI_E: // Rotate frame clockwise
                [transform rotateFrame:ROTATE_ANGLE];
                break;
        }
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    KeyInfo *keyInfo = [[KeyInfo alloc] initWithKeyCode:[event keyCode] modifiedFlags:[event modifierFlags]];
    for (int i = 0; i < [self keyInfoArray].count; i++)
    {
        if ([keyInfo isEqual:[[self keyInfoArray] objectAtIndex:i]])
            return true;
    }
    return false;
}

@end