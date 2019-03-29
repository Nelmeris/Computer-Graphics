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

@interface TransformMatrix : Matrix

- (id)init;

- (void)set: (TransformMatrix*)a;

- (TransformMatrix*)multi: (TransformMatrix*)mat;

- (TransformVector*)multiVec: (TransformVector*)vec;

@end
