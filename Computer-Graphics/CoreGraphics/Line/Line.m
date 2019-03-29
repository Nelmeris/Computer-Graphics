//
//  Line.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "Line.h"

@interface Line () {
    NSBezierPath *path;
}

@end

@implementation Line

- (instancetype)initWithFromPoint: (NSPoint)from toPoint: (NSPoint)to {
    self = [super init];
    if (self) {
        _from = from;
        _to = to;
    }
    return self;
}

- (void)drawWithColor:(NSColor*)color width:(CGFloat)width {
    path = [NSBezierPath bezierPath];
    [path moveToPoint:_from];
    [path lineToPoint:_to];
    [path closePath];
    [path setLineWidth:width];
    [color setStroke];
    [path stroke];
}

- (void)erase {
    
}

@end
