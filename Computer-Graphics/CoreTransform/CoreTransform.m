//
//  Transform.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "CoreTransform.h"
#import "TransformMatrix.h"
#import "TransformVector.h"
#import "GraphicalObject.h"

@implementation CoreTransform

+ (void)move: (CGFloat)x byY: (CGFloat)y matrix: (TransformMatrix*)c {
    [c setValue:x andI:0 andJ:M - 1];
    [c setValue:y andI:1 andJ:M - 1];
}

+ (void)rotate: (CGFloat)phi matrix: (TransformMatrix*)c {
    [c setValue:cos(phi) andI:0 andJ:0];
    [c setValue:-sin(phi) andI:0 andJ:1];
    [c setValue:sin(phi) andI:1 andJ:0];
    [c setValue:cos(phi) andI:1 andJ:1];
}

+ (void)scale: (CGFloat)value matrix: (TransformMatrix*)c {
    [c setValue:value andI:0 andJ:0];
    [c setValue:value andI:1 andJ:1];
}

+ (void)rotateFrame: (CGFloat)phi frame: (NSRect)frame matrix: (TransformMatrix*)c {
    [CoreTransform rotate:phi matrix:c];
    CGFloat x = frame.size.width / 2;
    CGFloat y = frame.size.height / 2;
    [CoreTransform
        move:x - x * cos(phi) + y * sin(phi)
        byY:y - x * sin(phi) - y * cos(phi)
        matrix:c];
}

+ (void)mirrorFrameRefByX: (NSRect)frame matrix: (TransformMatrix*)c {
    [CoreTransform move:frame.size.width byY:0 matrix:c];
    [c setValue:-1 andI:0 andJ:0];
}

+ (void)mirrorFrameRefByY: (NSRect)frame matrix: (TransformMatrix*)c {
    [CoreTransform move:0 byY:frame.size.height matrix:c];
    [c setValue:-1 andI:1 andJ:1];
}

+ (void)scaleFrame: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c {
    [CoreTransform move:(frame.size.width / 2) * (1 - value)
                    byY:(frame.size.height / 2) * (1 - value)
                    matrix:c];
    [c setValue:value andI:0 andJ:0];
    [c setValue:value andI:1 andJ:1];
}

+ (void)scaleFrameRefByX: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c {
    [c setValue:(frame.size.width / 2) * (1 - value) andI:0 andJ:M - 1];
    [c setValue:value andI:0 andJ:0];
}

+ (void)scaleFrameRefByY: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c {
    [c setValue:(frame.size.height / 2) * (1 - value) andI:1 andJ:M - 1];
    [c setValue:value andI:1 andJ:1];
}

@end
