//
//  TransformShape.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 03.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import "Shape.h"
#import "CoreTransform.h"

#ifndef TransformShape_h
#define TransformShape_h

@interface TransformShape : NSObject

@property Shape* shape;
@property CoreTransform* transform;

@end

#endif /* TransformShape_h */
