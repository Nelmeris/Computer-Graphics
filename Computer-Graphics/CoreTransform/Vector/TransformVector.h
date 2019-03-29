//
//  TransformVector.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTransform.h"

#import "Vector.h"

@interface TransformVector : Vector

- (id)init;

- (id)initWithPoint: (NSPoint)point;
- (id)initWithX: (CGFloat)x andY: (CGFloat)y;

- (void)setPoint: (NSPoint)point;
- (void)setX: (CGFloat)x andY: (CGFloat)y;

- (NSInteger)getCount;

- (NSPoint)makePoint;

@end
