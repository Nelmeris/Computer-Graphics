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

#import <Carbon/Carbon.h>

@implementation GraphicView

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        transform = [[TransformMatrix alloc]init];
        [transform makeUnit];
        figures = [[NSMutableArray alloc] init];
        paths = [[NSMutableArray alloc] init];
        defaultThickness = 2.5;
    }
    return self;
}

- (void)clearView {
    [paths removeAllObjects];
    [figures removeAllObjects];
    [transform makeUnit];
    [self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];

    [[NSColor whiteColor] setFill];
    [background fill];

    // Pass through all shapes
    for (NSInteger i = 0; i < figures.count; i++) {
        GraphicalObject *figure = [figures objectAtIndex: i];
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
    TransformVector* A = [CoreTransform makeVector:[figure getPoint:index]];
    // Multiplying a vector by a transformation matrix
    TransformVector* B = [CoreTransform multiMatVec: transform andB: A];
    // Return the converted point
    return [CoreTransform makePoint:B];
}

// Processing keys while holding Shift and Option keys
- (void)shuffleDependentOnTheShiftAndOptionKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            shiftIsClamped: (BOOL)shiftIsClamped
            OptionIsClamped: (BOOL)OptionIsClamped{
    if ((shiftIsClamped && OptionIsClamped)) { // The Shift & Option is clamped
        switch (key) {
            case kVK_ANSI_X: // Zoom in
                [CoreTransform scaleRefByC:1.5 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_Z: // Zoom out
                [CoreTransform scaleRefByC:(1 / 1.5) frame:self.frame matrix:transform];
                break;
        }
    } else { // The Shift & Option is not clamped at the same time
        [self shuffleDependentOnTheShiftKeys:key transformMatrix:transform shiftIsClamped:shiftIsClamped];
        [self shuffleDependentOnTheOptionKeys:key transformMatrix:transform OptionIsClamped:OptionIsClamped];
    }
}

// Processing keys while holding Shift key
- (void)shuffleDependentOnTheShiftKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            shiftIsClamped: (BOOL)shiftIsClamped {
    if (!shiftIsClamped) { // The Shift isn't clamped
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
                
            case kVK_ANSI_Q: // Rotate counterclockwise
                [CoreTransform rotate:-0.05 matrix:transform];
                break;
            case kVK_ANSI_E: // Rotate clockwise
                [CoreTransform rotate:0.05 matrix:transform];
                break;
                
            case kVK_ANSI_X: // Zoom in
                [CoreTransform scale:1.1 matrix:transform];
                break;
            case kVK_ANSI_Z: // Zoom out
                [CoreTransform scale:(1 / 1.1) matrix:transform];
                break;
        }
    } else { // The Shift isn't clamped
        switch (key) {
            case kVK_ANSI_O: // File Open
                [self openFile];
                return;
                
            case kVK_ANSI_W: // Fast move up
                [CoreTransform move:0 byY:10 matrix:transform];
                break;
            case kVK_ANSI_S: // Fast move down
                [CoreTransform move:0 byY:-10 matrix:transform];
                break;
            case kVK_ANSI_A: // Fast move left
                [CoreTransform move:-10 byY:0 matrix:transform];
                break;
            case kVK_ANSI_D: // Fast move right
                [CoreTransform move:10 byY:0 matrix:transform];
                break;
                
            case kVK_ANSI_Q: // Fast rotate counterclockwise
                [CoreTransform rotate:-0.25 matrix:transform];
                break;
            case kVK_ANSI_E: // Fast rotate clockwise
                [CoreTransform rotate:0.25 matrix:transform];
                break;
                
            case kVK_ANSI_X: // Fast zoom in
                [CoreTransform scale:1.5 matrix:transform];
                break;
            case kVK_ANSI_Z: // Fast zoom out
                [CoreTransform scale:1 / 1.5 matrix:transform];
                break;
        }
    }
}

// Processing keys while holding Option key
- (void)shuffleDependentOnTheOptionKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            OptionIsClamped: (BOOL)OptionIsClamped {
    if (!OptionIsClamped) { // The Option isn't clamped
    } else { // The Option is clamped
        switch (key) {
            case kVK_ANSI_X: // Zoom in
                [CoreTransform scaleRefByC:1.1 frame:self.frame matrix:transform];
                break;
            case kVK_ANSI_Z: // Zoom out
                [CoreTransform scaleRefByC:(1 / 1.1) frame:self.frame matrix:transform];
                break;
        }
    }
}

// Processing keys
- (void)shuffleKeys: (unsigned short)key
            transformMatrix: (TransformMatrix*)transform
            shiftIsClamped: (BOOL)shiftIsClamped
            OptionIsClamped: (BOOL)OptionIsClamped {
    
    switch (key) { // Universal keys
        case kVK_ANSI_U:
            [CoreTransform mirrorFrameRefByX:self.frame matrix:transform];
            return;
        case kVK_ANSI_J:
            [CoreTransform mirrorFrameRefByY:self.frame matrix:transform];
            return;
    }
    
    [self shuffleDependentOnTheShiftAndOptionKeys:key transformMatrix:transform shiftIsClamped:shiftIsClamped OptionIsClamped:OptionIsClamped];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyUp:(NSEvent *)theEvent {
    if ([theEvent keyCode] == kVK_Escape) {
        [self->transform makeUnit];
        [self setNeedsDisplay: YES];
        return;
    }
    
    TransformMatrix* timeTransform = [[TransformMatrix alloc] init];
    [timeTransform makeUnit];
    
    BOOL shiftIsClamped = ([theEvent modifierFlags] & NSEventModifierFlagShift) ? YES : NO;
    BOOL OptionIsClamped = ([theEvent modifierFlags] & NSEventModifierFlagOption) ? YES : NO;
    
    [self shuffleKeys:[theEvent keyCode]
           transformMatrix:timeTransform
           shiftIsClamped:shiftIsClamped
           OptionIsClamped:OptionIsClamped];
    
    if (![timeTransform isUnit]) {
        transform = [CoreTransform multi: timeTransform andB: transform];
        [self setNeedsDisplay: YES];
    }
}

- (void)openFile {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:@"txt", nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSModalResponseOK) {
        for (NSURL *url in [panel URLs]) {
            GraphicalObject *figure = [[GraphicalObject alloc]init];
            [figure loadFigure:url.relativePath];
            [figure setThickness:defaultThickness];
            [figures addObject:figure];
            [self setNeedsDisplay:YES];
        }
    }
}

@end
