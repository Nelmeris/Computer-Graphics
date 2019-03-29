//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransform.h"
#import "Shape.h"

#import "TransformMatrix.h"
#import "TransformVector.h"

#import "GraphicViewController.h"

#import <Carbon/Carbon.h>

#import "CoreTransformClip.h"
#import "KeyInfo.h"

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define NSColorFromHEX(hexValue) [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define BACKGROUND_COLOR 0xFFFFFF
#define CLIP_AREA_COLOR 0x000000
#define SHAPE_COLOR 0x000000

@interface GraphicView () {
    CoreTransform *transform;
    NSMutableArray *keys;
    GraphicViewController* controller;
    
    float left, right, top, bottom;
    
    float Wcx, Wcy, Wx, Wy;
    float Vcx, Vcy, Vx, Vy;
}

@end

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        transform = [[CoreTransform alloc]initWithView:self clipAreaMargin:15.0];
        
        keys = [NSMutableArray new];
        [keys addObjectsFromArray:
         @[
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
          ]
        ];
    }
    return self;
}

- (void)viewWillDraw {
    controller = (GraphicViewController*)self.window.contentViewController;
}

- (void)drawRect: (NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];

    [NSColorFromHEX(BACKGROUND_COLOR) setFill];
    [background fill];
    
    NSBezierPath *clipRectangle = [NSBezierPath bezierPath];
    [clipRectangle appendBezierPathWithRect:[transform makeClipRectangle]];
    
    [NSColorFromHEX(CLIP_AREA_COLOR) setStroke];
    [clipRectangle setLineWidth:5];
    [clipRectangle stroke];

    [NSColorFromHEX(SHAPE_COLOR) setStroke];
    // Pass through all shapes
    for (NSInteger i = 0; i < controller.shapes.count; i++) {
        Shape *shape = [controller.shapes objectAtIndex: i];
        [self autoScaling:shape];
        
        NSInteger linesCount = [shape getLinesCount];
        if (linesCount == 0) continue;
        
        // Drawing the transformed points
        NSMutableArray<Line *> *lines = [shape getLines];
        
        for (NSInteger i = 0; i < linesCount; i++)
        {
            Line *transformedLine = [transform transformLine:lines[i]];
            if ([transform clipLine:transformedLine]) {
                [transformedLine drawWithColor:NSColorFromHEX(SHAPE_COLOR) width:shape.thickness];
            }
        }
    }
}

- (Shape*)autoScaling: (Shape*)shape {
    CGFloat scalarX = (VIEW_WIDTH / 4) / [shape getWidth];
    CGFloat scalarY = (VIEW_HEIGHT / 4) / [shape getHeight];
    
    [shape scaling:(1 - scalarX > 1 - scalarY) ? scalarX : scalarY];
    return shape;
}

#pragma mark - Keys

- (void)keyUp:(NSEvent *)theEvent {
    KeyInfo* keyInfo = [[KeyInfo alloc] initWithEvent:theEvent];
    
    for (int i = 0; i < keys.count; i++)
    {
        if ([keyInfo isEqual:[keys objectAtIndex:i]])
        {
            [controller.keys addObject:(KeyInfo*)[keys objectAtIndex:i]];
            [controller.logTableView reloadData];
            if (keyInfo.code == kVK_Escape) { // Reset all transformations
                [self->transform reset];
                [self setNeedsDisplay: YES];
                return;
            }
            [self shuffleKeys:keyInfo];
            [self setNeedsDisplay: YES];
        }
    }
}

// Processing keys
- (void)shuffleKeys:(KeyInfo*)keyInfo {
    
    switch (keyInfo.code) { // Universal keys
        case kVK_ANSI_U: // Mirror frame relative to Ox
            [transform mirrorFrameRefByX];
            return;
        case kVK_ANSI_J: // Mirror frame relative to Oy
            [transform mirrorFrameRefByY];
            return;
    }
    
    [self shuffleDependentOnTheShiftAndOptionKeys:keyInfo];
}

// Processing keys while holding Shift & Option keys
- (void)shuffleDependentOnTheShiftAndOptionKeys:(KeyInfo*)keyInfo {
    if (keyInfo.shiftIsClamped && keyInfo.optionIsClamped) { // The Shift & Option keys is clamped
        switch (keyInfo.code) {
            case kVK_ANSI_X: // Rapid Increase frame
                [transform scaleFrame:1.5];
                break;
            case kVK_ANSI_Z: // Rapid Decrease frame
                [transform scaleFrame:1 / 1.5];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate frame counter-clockwise
                [transform rotateFrame:-0.25];
                break;
            case kVK_ANSI_E: // Rapid Rotate frame clockwise
                [transform rotateFrame:0.25];
                break;
        }
    } else { // The Shift & Option keys isn't clamped at the same time
        [self shuffleDependentOnTheShiftKeys:keyInfo];
        [self shuffleDependentOnTheOptionKeys:keyInfo];
    }
}

// Processing keys while holding Shift key
- (void)shuffleDependentOnTheShiftKeys:(KeyInfo*)keyInfo {
    if (!keyInfo.shiftIsClamped) { // The Shift key isn't clamped
        switch (keyInfo.code) {
            case kVK_ANSI_W: // Move up
                [transform move:0 byY:1];
                break;
            case kVK_ANSI_S: // Move down
                [transform move:0 byY:-1];
                break;
            case kVK_ANSI_A: // Move left
                [transform move:-1 byY:0];
                break;
            case kVK_ANSI_D: // Move right
                [transform move:1 byY:0];
                break;
                
            case kVK_ANSI_Q: // Rotate counter-clockwise
                [transform rotate:-0.05];
                break;
            case kVK_ANSI_E: // Rotate clockwise
                [transform rotate:0.05];
                break;
                
            case kVK_ANSI_X: // Increase
                [transform scale:1.1];
                break;
            case kVK_ANSI_Z: // Decrease
                [transform scale:(1 / 1.1)];
                break;
                
            case kVK_ANSI_I: // Increase relative to Ox
                [transform scaleFrameRefByX:1.1];
                break;
            case kVK_ANSI_O: // Decrease relative to Ox
                [transform scaleFrameRefByX:1 / 1.1];
                break;
            case kVK_ANSI_K: // Increase relative to Oy
                [transform scaleFrameRefByY:1.1];
                break;
            case kVK_ANSI_L: // Decrease relative to Oy
                [transform scaleFrameRefByY:1 / 1.1];
                break;
        }
    } else { // The Shift key is clamped
        switch (keyInfo.code) {
                
            case kVK_ANSI_W: // Rapid Move up
                [transform move:0 byY:10];
                break;
            case kVK_ANSI_S: // Rapid Move down
                [transform move:0 byY:-10];
                break;
            case kVK_ANSI_A: // Rapid Move left
                [transform move:-10 byY:0];
                break;
            case kVK_ANSI_D: // Rapid Move right
                [transform move:10 byY:0];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate counter-clockwise
                [transform rotate:-0.25];
                break;
            case kVK_ANSI_E: // Rapid Rotate clockwise
                [transform rotate:0.25];
                break;
                
            case kVK_ANSI_X: // Rapid Increase
                [transform scale:1.5];
                break;
            case kVK_ANSI_Z: // Rapid Decrease
                [transform scale:1 / 1.5];
                break;
                
            case kVK_ANSI_I: // Rapid Increase relative to Ox
                [transform scaleFrameRefByX:1.5];
                break;
            case kVK_ANSI_O: // Rapid Decrease relative to Ox
                [transform scaleFrameRefByX:1 / 1.5];
                break;
            case kVK_ANSI_K: // Rapid Increase relative to Oy
                [transform scaleFrameRefByY:1.5];
                break;
            case kVK_ANSI_L: // Rapid Decrease relative to Oy
                [transform scaleFrameRefByY:1 / 1.5];
                break;
        }
    }
}

// Processing keys while holding Option key
- (void)shuffleDependentOnTheOptionKeys:(KeyInfo*)keyInfo {
    if (!keyInfo.optionIsClamped) { // The Option isn't clamped
    } else { // The Option key is clamped
        switch (keyInfo.code) {
            case kVK_ANSI_X: // Increase frame
                [transform scaleFrame:1.1];
                break;
            case kVK_ANSI_Z: // Decrease frame
                [transform scaleFrame:(1 / 1.1)];
                break;
                
            case kVK_ANSI_Q: // Rotate frame counter-clockwise
                [transform rotateFrame:-0.05];
                break;
            case kVK_ANSI_E: // Rotate frame clockwise
                [transform rotateFrame:0.05];
                break;
        }
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    KeyInfo *keyInfo = [[KeyInfo alloc] initWithKeyCode:[event keyCode] modifiedFlags:[event modifierFlags]];
    for (int i = 0; i < keys.count; i++)
    {
        if ([keyInfo isEqual:[keys objectAtIndex:i]])
            return true;
    }
    return false;
}

@end
