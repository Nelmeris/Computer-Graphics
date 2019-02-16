//
//  TransformVector.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TransformVector.h"

@implementation TransformVector

- (id)init {
    self = [super init];
    vector = [[NSMutableArray alloc] init];
    
    for (NSInteger j = 0; j < M; j++) {
        NSNumber *value = @0;
        [vector addObject: value];
    }
    
    return self;
}

- (id)init: (NSPoint)point {
    vector = [[NSMutableArray alloc] init];
    NSNumber *numX = [NSNumber numberWithDouble:point.x];
    NSNumber *numY = [NSNumber numberWithDouble:point.y];
    [vector addObject:numX];
    [vector addObject:numY];
    [vector addObject:@1];
    return self;
}

- (id)init: (CGFloat)x andY: (CGFloat)y {
    self = [super init];
    vector = [[NSMutableArray alloc] init];
    NSNumber *numX = [NSNumber numberWithDouble:x];
    NSNumber *numY = [NSNumber numberWithDouble:y];
    [vector addObject:numX];
    [vector addObject:numY];
    [vector addObject:@1];
    return self;
}

- (void)set: (NSPoint)point {
    [self set:point.x andY:point.y];
}

- (void)set: (CGFloat)x andY: (CGFloat)y {
    [self setValue:x index:0];
    [self setValue:y index:1];
    [self setValue:1 index:2];
}

- (NSInteger)getCount {
    return M;
}

- (NSPoint)makePoint {
    CGFloat x = ((CGFloat)[self getValue:0]) / [self getValue:2];
    CGFloat y = ((CGFloat)[self getValue:1]) / [self getValue:2];
    NSPoint point = NSMakePoint(x, y);
    return point;
}

@end
