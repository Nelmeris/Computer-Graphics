//
//  GraphicalObject.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Shape.h"

#import "Matrix.h"

@implementation Shape

- (instancetype)init {
    self = [super init];
    if (self) {
        lines = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initFromFile:(NSString *)filePath {
    self = [super init];
    if (self) {
        lines = [NSMutableArray new];
        [self loadShapeFromFile:filePath];
    }
    return self;
}

- (void)loadShapeFromFile: (NSString *)filePath {
    NSError *error = nil;
    
    NSString *stringFromFile = [[NSString alloc]
                                initWithContentsOfFile:filePath
                                encoding:NSUTF8StringEncoding
                                error:&error];
    
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:stringFromFile];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    while (!scanner.atEnd) {
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        NSInteger x = [numberString integerValue];
        
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        NSInteger y = [numberString integerValue];
        
        NSPoint from = NSMakePoint(x, y);
        
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        x = [numberString integerValue];
        
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        y = [numberString integerValue];
        
        NSPoint to = NSMakePoint(x, y);
        
        Line *line = [[Line alloc] initWithFromPoint:from toPoint:to];
        [lines addObject:line];
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
