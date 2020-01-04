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
    path = nil;
}

- (NSDictionary *)toDictionary {
    return @{
        @"from": @{
            @"x": [NSNumber numberWithFloat:_from.x],
            @"y": [NSNumber numberWithFloat:_from.y]
        },
        @"to": @{
            @"x": [NSNumber numberWithFloat:_to.x],
            @"y": [NSNumber numberWithFloat:_to.y]
        }
    };
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    Line* newLine = [Line new];
    newLine.from = _from;
    newLine.to = _to;
    return newLine;
}

@end
