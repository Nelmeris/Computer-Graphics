//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"

@implementation GraphicView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath* background = [NSBezierPath bezierPath];
    
    [background appendBezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    [background closePath];
    
    [[NSColor colorWithCalibratedRed: 0.9529 green: 0.9098  blue: 0.9176  alpha: 1] setFill];
    
    [background fill];
    [background stroke];
    
    NSBezierPath* yellowPath = [NSBezierPath bezierPath];
    
    [yellowPath setLineWidth: 10.0];
    
    [yellowPath moveToPoint:NSMakePoint(0.0, self.frame.size.height / 2)];
    [yellowPath lineToPoint:NSMakePoint(self.frame.size.width, self.frame.size.height / 2)];
    [yellowPath closePath];
    
    [[NSColor colorWithCalibratedRed: 0.1764 green: 0.3843  blue: 0.4235  alpha: 1] setStroke];
    
    [yellowPath stroke];
    
    NSBezierPath* greenPath = [NSBezierPath bezierPath];
    
    [greenPath setLineWidth: 10.0];
    
    [greenPath moveToPoint:NSMakePoint(self.frame.size.width, 0.0)];
    [greenPath lineToPoint:NSMakePoint(0, self.frame.size.height)];
    [greenPath closePath];
    
    [[NSColor colorWithCalibratedRed: 0.5843 green: 0.3686  blue: 0.5137  alpha: 1] setStroke];
    
    [greenPath stroke];
}

@end
