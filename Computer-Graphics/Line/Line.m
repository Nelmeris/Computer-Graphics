//
//  Line.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Line.h"

@implementation Line

- (instancetype)initWithFromPoint: (NSPoint)from toPoint: (NSPoint)to {
    self = [super init];
    if (self) {
        _from = from;
        _to = to;
    }
    return self;
}

- (NSPoint *)getPointFrom {
    return &_from;
}

- (NSPoint *)getPointTo {
    return &_to;
}

@end
