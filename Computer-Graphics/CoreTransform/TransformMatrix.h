//
//  TransformMatrix.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTransform.h"

#import "Matrix.h"

#define M 3

NS_ASSUME_NONNULL_BEGIN

@interface TransformMatrix : Matrix

- (id)init;

@end

NS_ASSUME_NONNULL_END
