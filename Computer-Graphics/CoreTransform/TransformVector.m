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

- (NSInteger)getCount {
    return M;
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

- (void)makeHomogen: (CGFloat)x andY: (CGFloat)y {
    NSNumber *numX = [NSNumber numberWithDouble:x];
    NSNumber *numY = [NSNumber numberWithDouble:y];
    [vector setObject:numX atIndexedSubscript:0];
    [vector setObject:numY atIndexedSubscript:1];
    [vector setObject:@1 atIndexedSubscript:2];
}

@end
