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
@class Shape;

#define M 3

@interface CoreTransform : NSObject

+ (void)move: (CGFloat)x byY: (CGFloat)y matrix: (TransformMatrix*)c;
+ (void)rotate: (CGFloat)phi matrix: (TransformMatrix*)c;
+ (void)scale: (CGFloat)value matrix: (TransformMatrix*)c;

+ (void)rotateFrame: (CGFloat)phi frame: (NSRect)frame matrix: (TransformMatrix*)c;

+ (void)mirrorFrameRefByX: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)mirrorFrameRefByY: (NSRect)frame matrix: (TransformMatrix*)c;

+ (void)scaleFrame: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)scaleFrameRefByX: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)scaleFrameRefByY: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;

@end
