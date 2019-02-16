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

// Перемножение матриц
+ (TransformMatrix*)multi:(TransformMatrix*)a andB:(TransformMatrix*)b {
    TransformMatrix* c = [[TransformMatrix alloc]init];
    for (NSInteger i = 0; i < M; i++) {
        for (NSInteger j = 0; j < M; j++) {
            CGFloat skalaar = 0.0;
            for (int k = 0; k < M; k++)
                skalaar += [a getValue:i andJ:k] * [b getValue:k andJ:j];
            [c setValue:skalaar andI:i andJ:j];
        }
    }
    return c;
}

// Перемножение матрицы на вектор
+ (TransformVector*)multiMatVec:(TransformMatrix*)a andB:(TransformVector*)b {
    TransformVector* c = [[TransformVector alloc]init];
    for (int i = 0; i < M; i++) {
        CGFloat skalaar = 0;
        for (int j = 0; j < M; j++)
            skalaar += [a getValue:i andJ:j] * [b getValue:j];
        [c setValue:skalaar index:i];
    }
    return c;
}

// Перевод точки в вектор
+ (TransformVector*)makeVector:(NSPoint)a; {
    TransformVector* vector = [[TransformVector alloc] init:a.x andY:a.y];
    return vector;
}

// Перевод вектора в точку
+ (NSPoint)makePoint:(TransformVector*)a {
    CGFloat x = ((CGFloat)[a getValue:0]) / [a getValue:2];
    CGFloat y = ((CGFloat)[a getValue:1]) / [a getValue:2];
    NSPoint point = NSMakePoint(x, y);
    return point;
}

// Трансформация перемещения
+ (void)move:(CGFloat)x byY:(CGFloat)y matrix:(TransformMatrix*)c {
    [c setValue:x andI:0 andJ:M - 1];
    [c setValue:y andI:1 andJ:M - 1];
}

// Трансформация поворота
+ (void)rotate:(CGFloat)phi matrix:(TransformMatrix*)c {
    [c setValue:cos(phi) andI:0 andJ:0];
    [c setValue:-sin(phi) andI:0 andJ:1];
    [c setValue:sin(phi) andI:1 andJ:0];
    [c setValue:cos(phi) andI:1 andJ:1];
}

// Трансформация скалирования
+ (void)scale:(CGFloat)value matrix:(TransformMatrix*)c {
    [c setValue:value andI:0 andJ:0];
    [c setValue:value andI:1 andJ:1];
}

+ (void)rotateFrame:(CGFloat)phi frame:(NSRect)frame matrix:(TransformMatrix*)c {
    [CoreTransform rotate:phi matrix:c];
    CGFloat x = frame.size.width / 2;
    CGFloat y = frame.size.height / 2;
    [CoreTransform
        move:x - x * cos(phi) + y * sin(phi)
        byY:y - x * sin(phi) - y * cos(phi)
        matrix:c];
}

+ (void)mirrorFrameRefByX:(NSRect)frame matrix:(TransformMatrix*)c {
    [CoreTransform move:frame.size.width byY:0 matrix:c];
    [c setValue:-1 andI:0 andJ:0];
}

+ (void)mirrorFrameRefByY:(NSRect)frame matrix:(TransformMatrix*)c {
    [CoreTransform move:0 byY:frame.size.height matrix:c];
    [c setValue:-1 andI:1 andJ:1];
}

+ (void)scaleFrame:(CGFloat)value frame:(NSRect)frame matrix:(TransformMatrix*)c {
    [CoreTransform move:(frame.size.width / 2) * (1 - value)
                    byY:(frame.size.height / 2) * (1 - value)
                    matrix:c];
    [c setValue:value andI:0 andJ:0];
    [c setValue:value andI:1 andJ:1];
}

+ (void)scaleRefByX:(CGFloat)value frame:(NSRect)frame matrix:(TransformMatrix*)c {
    [c setValue:(frame.size.width / 2) * (1 - value) andI:0 andJ:M - 1];
    [c setValue:value andI:0 andJ:0];
}

+ (void)scaleRefByY:(CGFloat)value frame:(NSRect)frame matrix:(TransformMatrix*)c {
    [c setValue:(frame.size.height / 2) * (1 - value) andI:1 andJ:M - 1];
    [c setValue:value andI:1 andJ:1];
}

@end
