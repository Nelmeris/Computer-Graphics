//
//  Point.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

- (id)init: (NSInteger)x andY: (NSInteger)y {
    self = [super init];
    self.x = x;
    self.y = y;
    return self;
}

@end
