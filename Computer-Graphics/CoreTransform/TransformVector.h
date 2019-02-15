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

NS_ASSUME_NONNULL_BEGIN

@interface TransformVector : Vector

- (id)init;

- (NSInteger)getCount;

- (id)init: (CGFloat)x andY: (CGFloat)y;

- (void)makeHomogen: (CGFloat)x andY: (CGFloat)y;

@end

NS_ASSUME_NONNULL_END
