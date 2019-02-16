//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransform.h"
#import "GraphicalObject.h"

#import "TransformMatrix.h"
#import "TransformVector.h"

#import "GraphicViewController.h"

#import <Carbon/Carbon.h>

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        transform = [[TransformMatrix alloc] init];
        [transform makeUnit];
        paths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clearView {
    [paths removeAllObjects];
    [((GraphicViewController*)self.window.contentViewController).figures removeAllObjects];
    [transform makeUnit];
    [self setNeedsDisplay: YES];
}

- (void)drawRect: (NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];

    [[NSColor whiteColor] setFill];
    [background fill];

    // Pass through all shapes
    for (NSInteger i = 0; i < ((GraphicViewController*)self.window.contentViewController).figures.count; i++) {
        GraphicalObject *figure = [((GraphicViewController*)self.window.contentViewController).figures objectAtIndex: i];
        [self autoScaling:figure];
        NSBezierPath *figurePath = [NSBezierPath bezierPath];
        
        NSInteger pointsCount = [figure getPointsCount];
        if (pointsCount == 0) continue;
        
        // Drawing the transformed points
        [figurePath moveToPoint: [self getTransformedPoint:figure index:pointsCount - 1]];
        for (NSInteger i = 0; i < pointsCount; i++)
            [figurePath lineToPoint: [self getTransformedPoint:figure index:i]];
        
        // Figure settings
        [figurePath setLineWidth: [figure getThickness]];
        [[NSColor blackColor] setStroke];
        
        [figurePath closePath];
        
        // Drawing a shape and saving a path
        [figurePath stroke];
        [paths setObject:figurePath atIndexedSubscript:i];
    }
}

- (GraphicalObject*)autoScaling: (GraphicalObject*)figure {
    CGFloat scalarX = (self.frame.size.width / 4) / [figure getWidth];
    CGFloat scalarY = (self.frame.size.height / 4) / [figure getHeight];
    
    [figure scaling:(1 - scalarX > 1 - scalarY) ? scalarX : scalarY];
    return figure;
}

// Transforming a point
- (NSPoint)getTransformedPoint: (GraphicalObject*)figure index: (NSInteger)index {
    // Convert point to vector
    TransformVector* vector = [[TransformVector alloc]init:[figure getPoint:index]];
    // Multiplying a vector by a transformation matrix
    TransformVector* newVector = [transform multiVec:vector];
    // Return the converted point
    return [newVector makePoint];
}

// Processing keys while holding Shift & Option keys
- (void)shuffleDependentOnTheShiftAndOptionKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            shiftIsClamped: (BOOL)shiftIsClamped
            optionIsClamped: (BOOL)optionIsClamped{
    if ((shiftIsClamped && optionIsClamped)) { // The Shift & Option keys is clamped
        switch (key) {
            case kVK_ANSI_X: // Rapid Increase frame
                [CoreTransform scaleFrame:1.5 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_Z: // Rapid Decrease frame
                [CoreTransform scaleFrame:(1 / 1.5) frame:self.frame matrix:transform];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate frame counter-clockwise
                [CoreTransform rotateFrame:-0.25 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_E: // Rapid Rotate frame clockwise
                [CoreTransform rotateFrame:0.25 frame:self.frame matrix:transform];
                break;
        }
    } else { // The Shift & Option keys isn't clamped at the same time
        [self shuffleDependentOnTheShiftKeys:key transformMatrix:transform shiftIsClamped:shiftIsClamped];
        [self shuffleDependentOnTheOptionKeys:key transformMatrix:transform optionIsClamped:optionIsClamped];
    }
}

// Processing keys while holding Shift key
- (void)shuffleDependentOnTheShiftKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            shiftIsClamped: (BOOL)shiftIsClamped {
    if (!shiftIsClamped) { // The Shift key isn't clamped
        switch (key) {
            case kVK_ANSI_W: // Move up
                [CoreTransform move:0 byY:1 matrix:transform];
                break;
            case kVK_ANSI_S: // Move down
                [CoreTransform move:0 byY:-1 matrix:transform];
                break;
            case kVK_ANSI_A: // Move left
                [CoreTransform move:-1 byY:0 matrix:transform];
                break;
            case kVK_ANSI_D: // Move right
                [CoreTransform move:1 byY:0 matrix:transform];
                break;
                
            case kVK_ANSI_Q: // Rotate counter-clockwise
                [CoreTransform rotate:-0.05 matrix:transform];
                break;
            case kVK_ANSI_E: // Rotate clockwise
                [CoreTransform rotate:0.05 matrix:transform];
                break;
                
            case kVK_ANSI_X: // Increase
                [CoreTransform scale:1.1 matrix:transform];
                break;
            case kVK_ANSI_Z: // Decrease
                [CoreTransform scale:(1 / 1.1) matrix:transform];
                break;
                
            case kVK_ANSI_I: // Increase relative to Ox
                [CoreTransform scaleFrameRefByX:1.1 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_O: // Decrease relative to Ox
                [CoreTransform scaleFrameRefByX:1 / 1.1 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_K: // Increase relative to Oy
                [CoreTransform scaleFrameRefByY:1.1 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_L: // Decrease relative to Oy
                [CoreTransform scaleFrameRefByY:1 / 1.1 frame:self.frame matrix:transform];
                break;
        }
    } else { // The Shift key is clamped
        switch (key) {
                
            case kVK_ANSI_W: // Rapid Move up
                [CoreTransform move:0 byY:10 matrix:transform];
                break;
            case kVK_ANSI_S: // Rapid Move down
                [CoreTransform move:0 byY:-10 matrix:transform];
                break;
            case kVK_ANSI_A: // Rapid Move left
                [CoreTransform move:-10 byY:0 matrix:transform];
                break;
            case kVK_ANSI_D: // Rapid Move right
                [CoreTransform move:10 byY:0 matrix:transform];
                break;
                
            case kVK_ANSI_Q: // Rapid Rotate counter-clockwise
                [CoreTransform rotate:-0.25 matrix:transform];
                break;
            case kVK_ANSI_E: // Rapid Rotate clockwise
                [CoreTransform rotate:0.25 matrix:transform];
                break;
                
            case kVK_ANSI_X: // Rapid Increase
                [CoreTransform scale:1.5 matrix:transform];
                break;
            case kVK_ANSI_Z: // Rapid Decrease
                [CoreTransform scale:1 / 1.5 matrix:transform];
                break;
                
            case kVK_ANSI_I: // Rapid Increase relative to Ox
                [CoreTransform scaleFrameRefByX:1.5 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_O: // Rapid Decrease relative to Ox
                [CoreTransform scaleFrameRefByX:1 / 1.5 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_K: // Rapid Increase relative to Oy
                [CoreTransform scaleFrameRefByY:1.5 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_L: // Rapid Decrease relative to Oy
                [CoreTransform scaleFrameRefByY:1 / 1.5 frame:self.frame matrix:transform];
                break;
        }
    }
}

// Processing keys while holding Option key
- (void)shuffleDependentOnTheOptionKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            optionIsClamped: (BOOL)optionIsClamped {
    if (!optionIsClamped) { // The Option isn't clamped
    } else { // The Option key is clamped
        switch (key) {
            case kVK_ANSI_X: // Increase frame
                [CoreTransform scaleFrame:1.1 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_Z: // Decrease frame
                [CoreTransform scaleFrame:(1 / 1.1) frame:self.frame matrix:transform];
                break;
                
            case kVK_ANSI_Q: // Rotate frame counter-clockwise
                [CoreTransform rotateFrame:-0.05 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_E: // Rotate frame clockwise
                [CoreTransform rotateFrame:0.05 frame:self.frame matrix:transform];
                break;
        }
    }
}

// Processing keys
- (void)shuffleKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            modifierFlags: (NSEventModifierFlags) modifierFlags {
    
    switch (key) { // Universal keys
        case kVK_ANSI_U: // Mirror frame relative to Ox
            [CoreTransform mirrorFrameRefByX:self.frame matrix:transform];
            return;
        case kVK_ANSI_J: // Mirror frame relative to Oy
            [CoreTransform mirrorFrameRefByY:self.frame matrix:transform];
            return;
    }
    
    [self shuffleDependentOnTheShiftAndOptionKeys:key
            transformMatrix:transform
            shiftIsClamped:((modifierFlags & NSEventModifierFlagShift) ? YES : NO)
            optionIsClamped:((modifierFlags & NSEventModifierFlagOption) ? YES : NO)];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    unsigned short key = [event keyCode];
    BOOL commandIsClamped = [event modifierFlags] & NSEventModifierFlagCommand;
    return (commandIsClamped && key == kVK_ANSI_O) ||
            key == kVK_ANSI_W || key == kVK_ANSI_S || key == kVK_ANSI_A || key == kVK_ANSI_D || key == kVK_ANSI_Z || key == kVK_ANSI_X || key == kVK_ANSI_U || key == kVK_ANSI_J || key == kVK_ANSI_I || key == kVK_ANSI_K || key == kVK_ANSI_O || key == kVK_ANSI_L || key == kVK_ANSI_Q || key == kVK_ANSI_E;
}

- (void)keyUp:(NSEvent *)theEvent {
    if ([theEvent keyCode] == kVK_Escape) { // Reset all transformations
        [self->transform makeUnit];
        [self setNeedsDisplay: YES];
        return;
    }
    
    TransformMatrix* timeTransform = [[TransformMatrix alloc] init];
    [timeTransform makeUnit];
    
    [self shuffleKeys:[theEvent keyCode]
           transformMatrix:timeTransform
           modifierFlags:[theEvent modifierFlags]];
    
    if (![timeTransform isUnit]) {
        transform = [timeTransform multi:transform];
        [self setNeedsDisplay: YES];
    }
}

@end
