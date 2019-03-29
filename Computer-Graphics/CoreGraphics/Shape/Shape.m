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
    
    NSData *returnedData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];;
    
    // probably check here that returnedData isn't nil; attempting
    // NSJSONSerialization with nil data raises an exception, and who
    // knows how your third-party library intends to react?
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"%@", error); }
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
        }
        else
        {
            NSLog(@"?");
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
    else
    {
        NSLog(@"!");
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
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
