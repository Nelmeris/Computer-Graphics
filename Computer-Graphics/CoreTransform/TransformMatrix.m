//
//  TransformMatrix.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TransformMatrix.h"

@implementation TransformMatrix

- (id)init {
    self = [super init];
    matrix = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < M; i++) {
        NSMutableArray *vector = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < M; j++) {
            NSNumber *value = @0;
            [vector addObject: value];
        }
        [matrix addObject:vector];
    }
    return self;
}

- (NSInteger)getRowCount {
    return M;
}

- (NSInteger)getColumnCount {
    return M;
}

// Копирование матрицы
- (void) set:(TransformMatrix*)a {
    for (int i = 0; i < M; i++)
        for (int j = 0; j < M; j++)
            [self setValue:[a getValue:i andJ:j] andI:i andJ:j];
}

@end
