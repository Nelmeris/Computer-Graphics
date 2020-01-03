//
//  GraphicalObject.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Shape.h"
#import "Matrix.h"

#define NSColorFromHEX(hexValue) [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@implementation Shape

- (instancetype)init {
    self = [super init];
    if (self) {
        lines = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initFromJSON:(NSString *)filePath {
    self = [super init];
    if (self) {
        lines = [NSMutableArray new];
        [self loadShapeFromJSON:filePath];
    }
    return self;
}

- (void)loadShapeFromJSON:(NSString *)filePath {
    NSError *error = nil;
    
    NSData *returnedData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"%@", error); }
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            unsigned colorInt = 0;
            [[NSScanner scannerWithString:[results objectForKey:@"color"]] scanHexInt:&colorInt];
            _color = NSColorFromHEX(colorInt);
            _thickness = [[results objectForKey:@"thickness"] doubleValue];
            for (int i = 0; i < [results mutableArrayValueForKey:@"lines"].count; i++) {
                id lineData = [results mutableArrayValueForKey:@"lines"][i];
                id pointData = [lineData objectForKey:@"from"];
                NSPoint from = NSMakePoint([[pointData objectForKey:@"x"] floatValue], [[pointData objectForKey:@"y"] floatValue]);
                pointData = [lineData objectForKey:@"to"];
                NSPoint to = NSMakePoint([[pointData objectForKey:@"x"] floatValue], [[pointData objectForKey:@"y"] floatValue]);
                Line* line = [[Line alloc] initWithFromPoint:from toPoint:to];
                [lines addObject:line];
            }
        }
        else
        {
            NSLog(@"?");
        }
    }
    else
    {
        NSLog(@"!");
    }
}

- (void)scaling: (CGFloat)value {
    for (int i = 0; i < lines.count; i++) {
        Line *line = [lines objectAtIndex:i];
        [line setFrom:NSMakePoint(line.from.x * value, line.from.y * value)];
        [line setTo:NSMakePoint(line.to.x * value, line.to.y * value)];
        [lines setObject:line atIndexedSubscript:i];
    }
}

- (CGFloat)getMinX {
    Line *line = [lines objectAtIndex:0];
    CGFloat min = MIN(line.from.x, line.to.x);
    for (int i = 1; i < lines.count; i++) {
        line = [lines objectAtIndex:i];
        min = MIN(min, MIN(line.from.x, line.to.x));
    }
    return min;
}
- (CGFloat)getMinY {
    Line *line = [lines objectAtIndex:0];
    CGFloat min = MIN(line.from.y, line.to.y);
    for (int i = 1; i < lines.count; i++) {
        line = [lines objectAtIndex:i];
        min = MIN(min, MIN(line.from.y, line.to.y));
    }
    return min;
}
- (CGFloat)getMaxX {
    Line *line = [lines objectAtIndex:0];
    CGFloat min = MAX(line.from.x, line.to.x);
    for (int i = 1; i < lines.count; i++) {
        line = [lines objectAtIndex:i];
        min = MAX(min, MAX(line.from.x, line.to.x));
    }
    return min;
}
- (CGFloat)getMaxY {
    Line *line = [lines objectAtIndex:0];
    CGFloat min = MAX(line.from.y, line.to.y);
    for (int i = 1; i < lines.count; i++) {
        line = [lines objectAtIndex:i];
        min = MAX(min, MAX(line.from.y, line.to.y));
    }
    return min;
}

- (CGFloat)getWidth {
    return fabs([self getMaxX] - [self getMinX]);
}

- (CGFloat)getHeight {
    return fabs([self getMaxY] - [self getMinY]);
}

- (NSInteger)getLinesCount {
    return lines.count;
}

- (NSMutableArray<Line *> *)getLines {
    return lines;
}

@end
