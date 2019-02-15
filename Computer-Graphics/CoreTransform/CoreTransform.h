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

#define M 3

NS_ASSUME_NONNULL_BEGIN

@interface CoreTransform : NSObject

+ (void)times: (TransformMatrix*)a andB: (TransformMatrix*)b andC: (TransformMatrix*)c;
+ (void)timesMatVec: (TransformMatrix*)a andB: (TransformVector*)b andC: (TransformVector*)c;
+ (void)set: (TransformMatrix*)a andB: (TransformMatrix*)b;
+ (void)point2vec: (NSPoint)a andB: (TransformVector*)b;
+ (void)vec2point: (TransformVector*)a andB: (NSPoint*) b;
+ (void)makeHomogenVec: (CGFloat)x andY: (CGFloat)y andC: (TransformVector*)c;
+ (void)move: (CGFloat)Tx andTy: (CGFloat)Ty andC: (TransformMatrix*)c;
+ (void)rotate: (CGFloat)phi andC: (TransformMatrix*)c;
+ (void)scale: (CGFloat)S andC: (TransformMatrix*)c;

@end

NS_ASSUME_NONNULL_END
