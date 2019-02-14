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

@implementation GraphicView

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [CoreTransform unit:transform];
        figures = [[NSMutableArray alloc] init];
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

    for (NSInteger i = paths.count; i < figures.count; i++) {
        GraphicalObject *figure = [figures objectAtIndex: i];
        NSBezierPath *figurePath = [NSBezierPath bezierPath];
        
        NSInteger pointsCount = [figure getPointsCount];
        if (pointsCount != 0) {
            NSPoint point = [figure getPoint:pointsCount - 1];
            
            Vector A;
            [CoreTransform point2vec: point andB: A];
            
            Vector B;
            [CoreTransform timesMatVec: transform andB: A andC: B];
            
            NSPoint newPoint = NSMakePoint(0, 0);
            [CoreTransform vec2point: B andB: &newPoint];
            
            [figurePath moveToPoint: newPoint];
            
            // Черчение линии по всем точкам
            for (NSInteger i = 0; i < pointsCount; i++) {
                NSPoint point = [figure getPoint:i];
                
                Vector A;
                [CoreTransform point2vec: point andB: A];
                
                Vector B;
                [CoreTransform timesMatVec: transform andB: A andC: B];
                
                NSPoint newPoint = NSMakePoint(0, 0);
                [CoreTransform vec2point: B andB: &newPoint];
                
                [figurePath lineToPoint: newPoint];
            }
        }
        
        [figurePath setLineWidth: [figure getThickness]];
        
        [[NSColor blackColor] setStroke];
        
        [figurePath closePath];
        
        [figurePath stroke];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)event {
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
