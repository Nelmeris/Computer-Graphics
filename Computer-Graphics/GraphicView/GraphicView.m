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
    }
    return self;
}

- (void)clearView {
    [paths removeAllObjects];
    [figures removeAllObjects];
    [self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];

    [[NSColor whiteColor] setFill];
    [background fill];

    for (NSInteger i = 0; i < figures.count; i++) {
        GraphicalObject *figure = [figures objectAtIndex: i];
        
        NSBezierPath *figurePath = [NSBezierPath bezierPath];
        
        NSInteger pointsCount = [figure getPointsCount];
        if (pointsCount == 0) continue;
        
        // Черчение линии по всем точкам
        [figurePath moveToPoint: [self getTransformedPoint:figure index:pointsCount - 1]];
        for (NSInteger i = 0; i < pointsCount; i++)
            [figurePath lineToPoint: [self getTransformedPoint:figure index:i]];
        
        [figurePath setLineWidth: [figure getThickness]];
        [[NSColor blackColor] setStroke];
        
        [figurePath closePath];
        
        [figurePath stroke];
        [paths setObject:figurePath atIndexedSubscript:i];
    }
}

- (NSPoint)getTransformedPoint: (GraphicalObject*)figure index: (NSInteger)index {
    NSPoint point = [figure getPoint:index];
    
    TransformVector* A = [CoreTransform makeVector:point];
    
    TransformVector* B = [CoreTransform multiMatVec: transform andB: A];
    
    NSPoint newPoint = [CoreTransform makePoint:B];
    
    return newPoint;
}

- (void)shuffleKeys: (unsigned short)key andTransformMatrix: (TransformMatrix*)transform andShiftIsClamped: (BOOL)shiftIsClamped {
    switch (key) {
        case kVK_Escape:
            [self->transform makeUnit];
            return;
    }
    
    if (shiftIsClamped) { // Shift Down
        switch (key) {
            case kVK_ANSI_O: // File Open
                [self openFile];
                return;
                
            case kVK_ANSI_W: // Fast move up
                [CoreTransform move: 0 andTy: 10 andC: transform];
                break;
            case kVK_ANSI_S: // Fast move down
                [CoreTransform move: 0 andTy: -10 andC: transform];
                break;
            case kVK_ANSI_A: // Fast move left
                [CoreTransform move: -10 andTy: 0 andC: transform];
                break;
            case kVK_ANSI_D: // Fast move right
                [CoreTransform move: 10 andTy: 0 andC: transform];
                break;
                
            case kVK_ANSI_Q: // Fast rotate counterclockwise
                [CoreTransform rotate:-0.25 andC:transform];
                break;
            case kVK_ANSI_E: // Fast rotate clockwise
                [CoreTransform rotate:0.25 andC:transform];
                break;
                
            case kVK_ANSI_X: // Fast zoom in
                [CoreTransform scale:1.5 andC:transform];
                break;
            case kVK_ANSI_Z: // Fast zoom out
                [CoreTransform scale:1 / 1.5 andC:transform];
                break;
        }
    } else { // NaN Shift
        switch (key) {
            case kVK_ANSI_W: // Move up
                [CoreTransform move: 0 andTy: 1 andC: transform];
                break;
            case kVK_ANSI_S: // Move down
                [CoreTransform move: 0 andTy: -1 andC: transform];
                break;
            case kVK_ANSI_A: // Move left
                [CoreTransform move: -1 andTy: 0 andC: transform];
                break;
            case kVK_ANSI_D: // Move right
                [CoreTransform move: 1 andTy: 0 andC: transform];
                break;
                
            case kVK_ANSI_Q: // Rotate counterclockwise
                [CoreTransform rotate:-0.05 andC:transform];
                break;
            case kVK_ANSI_E: // Rotate clockwise
                [CoreTransform rotate:0.05 andC:transform];
                break;
                
            case kVK_ANSI_X: // Zoom in
                [CoreTransform scale:1.1 andC:transform];
                break;
            case kVK_ANSI_Z: // Zoom out
                [CoreTransform scale:(1 / 1.1) andC:transform];
                break;
        }
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyUp:(NSEvent *)theEvent {
    TransformMatrix* timeTransform = [[TransformMatrix alloc] init];
    [timeTransform makeUnit];
    
    BOOL shiftIsClamped = ([theEvent modifierFlags] & NSEventModifierFlagShift) ? YES : NO;
                           
    [self shuffleKeys:[theEvent keyCode]
            andTransformMatrix:timeTransform
            andShiftIsClamped:shiftIsClamped];
    
    if (![transform isEqual:timeTransform]) {
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
            GraphicalObject *figure = [[GraphicalObject alloc] init];
            [figure loadFigure: url.relativePath andBaseScaling: 10 andThickness: 2.5];
            [figures addObject: figure];
            [self setNeedsDisplay: YES];
        }
    }
}

@end
