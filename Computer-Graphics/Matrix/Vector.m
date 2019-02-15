//
//  Vector.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Vector.h"

@implementation Vector

- (id)init: (NSInteger)columns {
    self = [super init];
    vector = [[NSMutableArray alloc] init];
    
    for (NSInteger j = 0; j < columns; j++) {
        NSNumber *value = @0;
        [vector addObject: value];
    }
    
    return self;
}

- (CGFloat)getValue: (NSInteger)i {
    if (i > [self getCount]) {
        NSLog(@"Invalid index!");
        return 0.0;
    }
    
    return [[vector objectAtIndex:i] floatValue];
}

- (void)setValue: (CGFloat)value andI: (NSInteger)i {
    if (i > [self getCount]) {
        NSLog(@"Invalid index!");
        return;
    }
    
    NSNumber *num = [NSNumber numberWithDouble:value];
    [vector setObject:num atIndexedSubscript:i];
}

- (void)makeZero {
    for (NSInteger i = 0; i < [vector count]; i++) {
        [vector setObject:@0 atIndexedSubscript:i];
    }
}

- (NSInteger)getCount {
    return [vector count];
}

- (BOOL)isEqual:(Vector*)secondVector {
    if ([self getCount] != [secondVector getCount])
        return NO;
    
    for (NSInteger i = 0; i < [self getCount]; i++)
        if ([self getValue:i] != [secondVector getValue:i])
            return NO;
    
    return YES;
}

- (void)print {
    for (int i = 0; i < [self getCount]; i++) {
        printf("%.0f ", [self getValue:i]);
    }
    printf("\n");
}

@end
