//
//  Transform.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransformMatrix;
@class TransformVector;
@class GraphicalObject;

#define M 3

NS_ASSUME_NONNULL_BEGIN

@interface CoreTransform : NSObject

+ (TransformMatrix*)multi: (TransformMatrix*)a andB: (TransformMatrix*)b;
+ (TransformVector*)multiMatVec: (TransformMatrix*)a andB: (TransformVector*)b;

+ (TransformVector*)makeVector: (NSPoint)a;
+ (NSPoint)makePoint: (TransformVector*)a;

+ (void)move: (CGFloat)x byY: (CGFloat)y matrix: (TransformMatrix*)c;
+ (void)rotate: (CGFloat)phi matrix: (TransformMatrix*)c;
+ (void)scale: (CGFloat)value matrix: (TransformMatrix*)c;

+ (void)mirrorFrameRefByX: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)mirrorFrameRefByY: (NSRect)frame matrix: (TransformMatrix*)c;

+ (void)scaleRefByC: (CGFloat)value matrix: (TransformMatrix*)c;

@end

NS_ASSUME_NONNULL_END
