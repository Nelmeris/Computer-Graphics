//
//  TransformMatrix.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TransformMatrix.h"
#import "TransformVector.h"

@implementation TransformMatrix

- (id)init {
    self = [super init];
    matrix = [NSMutableArray new];
    for (NSInteger i = 0; i < M; i++) {
        NSMutableArray *vector = [NSMutableArray new];
        for (NSInteger j = 0; j < M; j++) {
            NSNumber *value = @0;
            [vector addObject:value];
        }
        [matrix addObject:vector];
    }
    [self makeUnit];
    return self;
}

- (NSInteger)getRowCount {
    return M;
}

- (NSInteger)getColumnCount {
    return M;
}

- (void)set:(TransformMatrix*)a {
    for (int i = 0; i < M; i++)
        for (int j = 0; j < M; j++)
            [self setValue:[a getValue:i andJ:j] andI:i andJ:j];
}

- (TransformMatrix*)multi:(TransformMatrix*)mat {
    TransformMatrix* c = [TransformMatrix new];
    for (NSInteger i = 0; i < M; i++) {
        for (NSInteger j = 0; j < M; j++) {
            CGFloat skalaar = 0.0;
            for (int k = 0; k < M; k++)
                skalaar += [self getValue:i andJ:k] * [mat getValue:k andJ:j];
            [c setValue:skalaar andI:i andJ:j];
        }
    }
    return c;
}

- (TransformVector*)multiVec: (TransformVector*)vec {
    TransformVector* c = [TransformVector new];
    for (int i = 0; i < M; i++) {
        CGFloat skalaar = 0;
        for (int j = 0; j < M; j++)
            skalaar += [self getValue:i andJ:j] * [vec getValue:j];
        [c setValue:skalaar index:i];
    }
    return c;
}

@end
