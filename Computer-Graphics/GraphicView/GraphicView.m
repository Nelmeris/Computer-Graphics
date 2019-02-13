//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransform.h"

@implementation GraphicView

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        points = [NSMutableArray array];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [[NSColor whiteColor] setFill];
    [background fill];
    [background stroke];
    
    NSBezierPath *figure = [NSBezierPath bezierPath];
    
    Vector A;
    NSPoint* point = (NSPoint*)CFBridgingRetain(points[points.count - 1]);
    [CoreTransform point2vec: *point andB: A];
    
    Vector B;
    [CoreTransform timesMatVec: transform andB: A andC: B];
    
    NSPoint newPoint;
    [CoreTransform vec2point: B andB: newPoint];
    
    [figure moveToPoint: newPoint];
    
    for (int i = 0; i < points.count; i++) {
        Vector A;
        NSPoint* point = (NSPoint*)CFBridgingRetain(points[i]);
        [CoreTransform point2vec: *point andB: A];
        
        Vector B;
        [CoreTransform timesMatVec: transform andB: A andC: B];
        
        NSPoint newPoint;
        [CoreTransform vec2point: B andB: newPoint];
        
        [figure lineToPoint: newPoint];
    }
    
    
    [figure stroke];
}

@end
