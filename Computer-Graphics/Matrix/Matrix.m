//
//  Matrix.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Matrix.h"
#import "Vector.h"

@implementation Matrix

- (id)init: (NSInteger)rows andColumns: (NSInteger)columns {
    self = [super init];
    matrix = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < rows; i++) {
        NSMutableArray *vector = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < columns; j++)
            [vector addObject: @0];
        [matrix addObject:vector];
    }
    return self;
}

- (CGFloat)getValue: (NSInteger)i andJ: (NSInteger)j {
    if (i > [self getRowCount] || j > [self getColumnCount]) {
        NSLog(@"Invalid index!");
        return 0.0;
    }
    
    NSMutableArray *vector = [matrix objectAtIndex: i];
    NSNumber *value = [vector objectAtIndex: j];
    return [value floatValue];
}

- (void)setValue: (CGFloat)value andI: (NSInteger)i andJ: (NSInteger)j {
    if (i > [self getRowCount] || j > [self getColumnCount]) {
        NSLog(@"Invalid index!");
        return;
    }
    
    NSNumber *num = [NSNumber numberWithDouble:value];
    NSMutableArray *vector = [matrix objectAtIndex: i];
    [vector setObject:num atIndexedSubscript:j];
}

- (void)makeUnit {
    for (NSInteger i = 0; i < [matrix count]; i++) {
        NSMutableArray *vector = [matrix objectAtIndex: i];
        for (NSInteger j = 0; j < [vector count]; j++)
            [vector setObject:(i == j) ? @1 : @0 atIndexedSubscript:j];
    }
}

- (BOOL)isUnit {
    for (NSInteger i = 0; i < [matrix count]; i++) {
        NSMutableArray *vector = [matrix objectAtIndex: i];
        for (NSInteger j = 0; j < [vector count]; j++) {
            CGFloat value = [self getValue:i andJ:j];
            if (value != 0 && !(i == j && value == 1))
                return NO;
        }
    }
    return YES;
}

- (BOOL)isEqual:(Matrix*)secondMatrix {
    if ([self getRowCount] != [secondMatrix getRowCount] || [self getColumnCount] != [secondMatrix getColumnCount])
        return NO;
    
    for (NSInteger i = 0; i < [self getRowCount]; i++)
        for (NSInteger j = 0; j < [self getColumnCount]; j++)
            if ([self getValue:i andJ:j] != [secondMatrix getValue:i andJ:j])
                return NO;
    
    return YES;
}

- (NSInteger)getRowCount {
    return [matrix count];
}

- (NSInteger)getColumnCount {
    if ([self getRowCount] == 0)
        return 0;
    NSMutableArray *vector = [matrix objectAtIndex: 0];
    return [vector count];
}

- (void)print {
    for (int i = 0; i < [self getRowCount]; i++) {
        for (int j = 0; j < [self getColumnCount]; j++)
            printf("%.0f ", [self getValue:i andJ:j]);
        printf("\n");
    }
    printf("\n");
}

@end
