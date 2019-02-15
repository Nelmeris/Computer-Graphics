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

- (void) loadFigure:(NSString *)filePath andBaseScaling:(CGFloat)scale andThickness:(CGFloat)thickness {
    self->thickness = thickness;
    
    NSError *error = nil;
    
    NSString *stringFromFile = [[NSString alloc]
                                initWithContentsOfFile: filePath
                                encoding: NSUTF8StringEncoding
                                error: &error];
    
    // Intermediate
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:stringFromFile];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    while (!scanner.atEnd) {
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        
        NSInteger x = [numberString integerValue] * scale;
        
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        
        NSInteger y = [numberString integerValue] * scale;
        
        MyPoint *point = [[MyPoint alloc] init:x andY:y];
        [points addObject: point];
    }
}

@end
