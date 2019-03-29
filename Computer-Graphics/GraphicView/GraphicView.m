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

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

@interface GraphicView () {
    NSMutableArray *paths;
    TransformMatrix *transform;
}

@end

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        transform = [TransformMatrix new];
        [transform makeUnit];
        paths = [NSMutableArray new];
    }
    return self;
}

- (void)clearView {
    [paths removeAllObjects];
    [((GraphicViewController*)self.window.contentViewController).shapes removeAllObjects];
    [transform makeUnit];
    [self setNeedsDisplay: YES];
}

- (void)drawRect: (NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];

    [[NSColor whiteColor] setFill];
    [background fill];

    // Pass through all shapes
    for (NSInteger i = 0; i < ((GraphicViewController*)self.window.contentViewController).shapes.count; i++) {
        Shape *shape = [((GraphicViewController*)self.window.contentViewController).shapes objectAtIndex: i];
        [self autoScaling:shape];
        
        NSInteger linesCount = [shape getLinesCount];
        if (linesCount == 0) continue;
        
        // Drawing the transformed points
        NSMutableArray<Line *> *lines = [shape getLines];
        for (NSInteger i = 0; i < pointsCount; i++)
            [figurePath lineToPoint: [self getTransformedPoint:figure index:i]];
        
        for (NSInteger i = 0; i < linesCount; i++)
        {
            Line *transformedLine = [self getTransformedLine:lines[i]];
        
                [self drawLine:transformedLine width:shape.thickness];
        
        }
    }
}

- (void)drawLine: (Line *)line width: (CGFloat)width {
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    [linePath moveToPoint:line.from];
    [linePath lineToPoint:line.to];
    [linePath closePath];
    [linePath setLineWidth:width];
    [linePath stroke];
    [paths setObject:line atIndexedSubscript:paths.count];
}

- (Shape*)autoScaling: (Shape*)shape {
    CGFloat scalarX = (VIEW_WIDTH / 4) / [shape getWidth];
    CGFloat scalarY = (VIEW_HEIGHT / 4) / [shape getHeight];
    
    [shape scaling:(1 - scalarX > 1 - scalarY) ? scalarX : scalarY];
    return shape;
}

// Transforming a line
- (Line *)getTransformedLine: (Line *)line {
    // Convert point to vector
    TransformVector* vectorFrom = [[TransformVector alloc]initWithPoint:line.from];
    TransformVector* vectorTo = [[TransformVector alloc]initWithPoint:line.to];
    // Multiplying a vector by a transformation matrix
    TransformVector* newVectorFrom = [transform multiVec:vectorFrom];
    TransformVector* newVectorTo = [transform multiVec:vectorTo];
    // Return the converted line
    return [[Line alloc] initWithFromPoint:[newVectorFrom makePoint] toPoint:[newVectorTo makePoint]];
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
    
    TransformMatrix* timeTransform = [TransformMatrix new];
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
