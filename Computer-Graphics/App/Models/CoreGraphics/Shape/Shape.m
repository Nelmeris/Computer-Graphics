//
//  GraphicalObject.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Shape.h"
#import "Matrix.h"
#import "ColorHex.h"

@implementation Shape

- (instancetype)init {
    self = [super init];
    if (self) {
        _lines = [NSMutableArray new];
    }
    return self;
}

- (void)loadFromJSON:(NSDictionary *)json {
    NSString* color = [json objectForKey:@"color"];
    _color = [NSColor colorFromHexString:color];
    _thickness = [[json objectForKey:@"thickness"] doubleValue];
    for (NSDictionary* lineData in [json mutableArrayValueForKey:@"lines"]) {
        id pointData = [lineData objectForKey:@"from"];
        NSPoint from = NSMakePoint([[pointData objectForKey:@"x"] floatValue], [[pointData objectForKey:@"y"] floatValue]);
        pointData = [lineData objectForKey:@"to"];
        NSPoint to = NSMakePoint([[pointData objectForKey:@"x"] floatValue], [[pointData objectForKey:@"y"] floatValue]);
        Line* line = [[Line alloc] initWithFromPoint:from toPoint:to];
        [_lines addObject:line];
    }
}

+ (void)saveToFile:(NSArray<Shape*>*)shapes filePath:(NSString *)filePath {
    NSError *error = nil;
    
    NSMutableArray<NSDictionary*>* json = [NSMutableArray new];
    for (Shape* shape in shapes)
        [json addObject:[shape toDictionary]];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error) { NSLog(@"%@", error); }
    
    [jsonData writeToFile:filePath options: NSDataWritingAtomic error:&error];
    
    if(error) { NSLog(@"%@", error); }
}

- (NSDictionary*)toDictionary {
    NSMutableArray<NSDictionary*>* array = [NSMutableArray new];
    for (Line* line in _lines)
        [array addObject:[line toDictionary]];
    return @{
        @"color": [_color hexString],
        @"thickness": [NSNumber numberWithFloat:_thickness],
        @"lines": [array copy]
    };
}

+ (NSArray<Shape*>*)loadShapesFromFile:(NSString *)filePath {
    NSError *error = nil;
    
    NSData *returnedData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];
    
    if(NSClassFromString(@"NSJSONSerialization")) {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"%@", error); }
        
        NSMutableArray<Shape *>* result = [NSMutableArray new];
        
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray* array = object;
            for (NSDictionary* dict in array) {
                Shape* shape = [Shape new];
                [shape loadFromJSON:dict];
                [result addObject:shape];
            }
        } else if([object isKindOfClass:[NSDictionary class]]) {
            Shape* shape = [Shape new];
            [shape loadFromJSON:object];
            [result addObject:shape];
        }
        
        return [result copy];
    }
    
    return NULL;
}

- (void)scaling: (CGFloat)value {
    NSMutableArray<Line*>* lines = [NSMutableArray new];
    for (Line* line in _lines) {
        Line *newLine = [line copy];
        [newLine setFrom:NSMakePoint(line.from.x * value, line.from.y * value)];
        [newLine setTo:NSMakePoint(line.to.x * value, line.to.y * value)];
        [lines addObject:newLine];
    }
    _lines = lines;
}

- (CGFloat)getMinX {
    Line *line = [_lines objectAtIndex:0];
    CGFloat min = MIN(line.from.x, line.to.x);
    for (int i = 1; i < _lines.count; i++) {
        line = [_lines objectAtIndex:i];
        min = MIN(min, MIN(line.from.x, line.to.x));
    }
    return min;
}
- (CGFloat)getMinY {
    Line *line = [_lines objectAtIndex:0];
    CGFloat min = MIN(line.from.y, line.to.y);
    for (int i = 1; i < _lines.count; i++) {
        line = [_lines objectAtIndex:i];
        min = MIN(min, MIN(line.from.y, line.to.y));
    }
    return min;
}
- (CGFloat)getMaxX {
    Line *line = [_lines objectAtIndex:0];
    CGFloat min = MAX(line.from.x, line.to.x);
    for (int i = 1; i < _lines.count; i++) {
        line = [_lines objectAtIndex:i];
        min = MAX(min, MAX(line.from.x, line.to.x));
    }
    return min;
}
- (CGFloat)getMaxY {
    Line *line = [_lines objectAtIndex:0];
    CGFloat min = MAX(line.from.y, line.to.y);
    for (int i = 1; i < _lines.count; i++) {
        line = [_lines objectAtIndex:i];
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

- (NSArray<Line *> *)lines {
    return _lines;
}

- (void)setLines:(NSArray<Line *> *)lines {
    _lines = [lines copy];
}

- (void)transform:(CoreTransform *)core {
    NSMutableArray<Line*>* newLines = [NSMutableArray new];
    for (Line* line in _lines)
        [newLines addObject:[core transformLine:line]];
    _lines = newLines;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    Shape* newShape = [[Shape alloc] init];
    newShape.color = [_color copyWithZone:zone];
    newShape.thickness = _thickness;
    newShape.lines = [_lines copyWithZone:zone];
    return newShape;
}

@end
