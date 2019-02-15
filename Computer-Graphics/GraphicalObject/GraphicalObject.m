//
//  GraphicalObject.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicalObject.h"
#import "MyPoint.h"

#import "Matrix.h"

@implementation GraphicalObject

- (id) init {
    self = [super init];
    points = [[NSMutableArray alloc] init];
    return self;
}

- (NSInteger) getPointsCount {
    return [points count];
}

- (CGFloat) getThickness {
    return thickness;
}

- (NSPoint) getPoint:(NSInteger)index {
    MyPoint *point = [points objectAtIndex: index];
    NSPoint nsPoint = NSMakePoint(point.x, point.y);
    return nsPoint;
}

- (void) loadFigure:(NSString *)filePath {
    NSError *error = nil;
    
    NSString *stringFromFile = [[NSString alloc]
                                initWithContentsOfFile: filePath
                                encoding: NSUTF8StringEncoding
                                error: &error];
    
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:stringFromFile];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    while (!scanner.atEnd) {
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        
        NSInteger x = [numberString integerValue];
        
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        
        NSInteger y = [numberString integerValue];
        
        MyPoint *point = [[MyPoint alloc] init:x andY:y];
        [points addObject: point];
    }
}

- (void)setThickness: (CGFloat)value {
    thickness = value;
}
- (void)scaling: (CGFloat)value {
    for (NSInteger i = 0; i < points.count; i++) {
        MyPoint *point = [points objectAtIndex: i];
        point.x *= value;
        point.y *= value;
        [points setObject:point atIndexedSubscript:i];
    }
}

- (CGFloat)getMinX {
    NSPoint point = [self getPoint:0];
    for (NSInteger i = 1; i < [self getPointsCount]; i++)
        if ([self getPoint:i].x < point.x)
            point = [self getPoint:i];
    return point.x;
}
- (CGFloat)getMinY {
    NSPoint point = [self getPoint:0];
    for (NSInteger i = 1; i < [self getPointsCount]; i++)
        if ([self getPoint:i].y < point.y)
            point = [self getPoint:i];
    return point.y;
}
- (CGFloat)getMaxX {
    NSPoint point = [self getPoint:0];
    for (NSInteger i = 1; i < [self getPointsCount]; i++)
        if ([self getPoint:i].x > point.x)
            point = [self getPoint:i];
    return point.x;
}
- (CGFloat)getMaxY {
    NSPoint point = [self getPoint:0];
    for (NSInteger i = 1; i < [self getPointsCount]; i++)
        if ([self getPoint:i].y > point.y)
            point = [self getPoint:i];
    return point.y;
}
- (CGFloat)getWidth {
    return fabs([self getMaxX] - [self getMinX]);
}

- (CGFloat)getHeight {
    return fabs([self getMaxY] - [self getMinY]);
}

@end
