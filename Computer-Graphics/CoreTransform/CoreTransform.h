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

+ (TransformMatrix*)multi: (TransformMatrix*)a andB: (TransformMatrix*)b;
+ (TransformVector*)multiMatVec: (TransformMatrix*)a andB: (TransformVector*)b;

+ (TransformVector*)makeVector: (NSPoint)a;
+ (NSPoint)makePoint: (TransformVector*)a;

+ (void)move: (CGFloat)Tx andTy: (CGFloat)Ty andC: (TransformMatrix*)c;
+ (void)rotate: (CGFloat)phi andC: (TransformMatrix*)c;
+ (void)scale: (CGFloat)S andC: (TransformMatrix*)c;

@end

NS_ASSUME_NONNULL_END
