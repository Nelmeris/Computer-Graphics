//
//  Transform.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define M 3
typedef float Vector[M];
typedef float Matrix[M][M];

@interface CoreTransform : NSObject

+ (void) times: (Matrix)a andB: (Matrix)b andC: (Matrix)c;
+ (void) timesMatVec: (Matrix)a andB: (Vector)b andC: (Vector)c;
+ (void) set: (Matrix)a andB: (Matrix)b;
+ (void) point2vec: (NSPoint)a andB: (Vector)b;
+ (void) vec2point: (Vector)a andB: (NSPoint*) b;
+ (void) makeHomogenVec: (float)x andY: (float)y andC: (Vector)c;
+ (void) unit: (Matrix)a;
+ (void) move: (float)Tx andTy: (float)Ty andC: (Matrix)c;
+ (void) rotate: (float)phi andC: (Matrix)c;
+ (void) scale: (float)S andC: (Matrix)c;

@end

NS_ASSUME_NONNULL_END
