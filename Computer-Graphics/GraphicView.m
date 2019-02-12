//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"

@implementation GraphicView

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        scaleX = 20;
        scaleY = 20;
        moveX = 40;
        moveY = 40;
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
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    // Saving figure
    int const pointsCount = 46;
    
    NSPoint points[pointsCount] = {
        NSMakePoint(0, 10),
        
        NSMakePoint(1, 10),
        NSMakePoint(1, 11),
        NSMakePoint(5, 11),
        NSMakePoint(5, 12),
        
        NSMakePoint(4, 12),
        NSMakePoint(4, 7),
        NSMakePoint(5, 7),
        NSMakePoint(5, 8),
        
        NSMakePoint(6, 8),
        NSMakePoint(6, 9),
        NSMakePoint(8, 9),
        NSMakePoint(8, 8),
        
        NSMakePoint(9, 8),
        NSMakePoint(9, 7),
        NSMakePoint(10, 7),
        NSMakePoint(10, 2),
        
        NSMakePoint(11, 2),
        NSMakePoint(11, 1),
        NSMakePoint(13, 1),
        NSMakePoint(13, 0),
        
        NSMakePoint(10, 0),
        NSMakePoint(10, 1),
        NSMakePoint(9, 1),
        NSMakePoint(9, 2),

        NSMakePoint(8, 2),
        NSMakePoint(8, 4),
        NSMakePoint(7, 4),
        NSMakePoint(7, 1),

        NSMakePoint(8, 1),
        NSMakePoint(8, 0),
        NSMakePoint(3, 0),
        NSMakePoint(3, 1),
        
        NSMakePoint(5, 1),
        NSMakePoint(5, 2),
        NSMakePoint(6, 2),
        NSMakePoint(6, 3),
        
        NSMakePoint(4, 3),
        NSMakePoint(4, 5),
        NSMakePoint(2, 5),
        NSMakePoint(2, 4),
        
        NSMakePoint(1, 4),
        NSMakePoint(1, 6),
        NSMakePoint(2, 6),
        NSMakePoint(2, 9),
        
        NSMakePoint(0, 9)
    };
    
    // Scaling and Moving
    for (int i = 0; i < pointsCount; i++) {
        points[i].x *= scaleX;
        points[i].y *= scaleY;
        points[i].x += moveX;
        points[i].y += moveY;
    }
    
    // Drawing
    [path moveToPoint: points[pointsCount - 1]];
    
    for (int i = 0; i < pointsCount; i++) {
        [path lineToPoint: points[i]];
    }
    
    [path closePath];
    
    [path setLineWidth: 5];
    [[NSColor blackColor] setStroke];
    [[NSColor yellowColor] setFill];
    [path fill];
    [path stroke];
    
    NSBezierPath *eye = [NSBezierPath bezierPath];
    [eye appendBezierPathWithRect: NSMakeRect(2 * scaleX + moveX, 10 * scaleY + moveY, 1, 1)];
    
    [[NSColor blackColor] setFill];
    [eye fill];
    [eye setLineWidth: 5];
    [eye stroke];
}

@end
