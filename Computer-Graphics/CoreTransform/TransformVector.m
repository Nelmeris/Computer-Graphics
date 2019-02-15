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

@end
