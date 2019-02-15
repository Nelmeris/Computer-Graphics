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

@implementation CoreTransform

// Перемножение матриц
+ (TransformMatrix*)multi: (TransformMatrix*)a andB: (TransformMatrix*)b {
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
+ (TransformVector*)multiMatVec: (TransformMatrix*)a andB: (TransformVector*)b {
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
+ (TransformVector*)makeVector: (NSPoint)a; {
    TransformVector* vector = [[TransformVector alloc] init:a.x andY:a.y];
    return vector;
}

// Перевод вектора в точку
+ (NSPoint)makePoint: (TransformVector*)a {
    CGFloat x = ((CGFloat)[a getValue:0]) / [a getValue:2];
    CGFloat y = ((CGFloat)[a getValue:1]) / [a getValue:2];
    NSPoint point = NSMakePoint(x, y);
    return point;
}

// Трансформация перемещения
+ (void)move: (CGFloat)Tx andTy: (CGFloat)Ty andC: (TransformMatrix*)c {
    [c setValue:Tx andI:0 andJ:M - 1];
    [c setValue:Ty andI:1 andJ:M - 1];
}

// Трансформация поворота
+ (void)rotate: (CGFloat)phi andC: (TransformMatrix*)c {
    [c setValue:cos(phi) andI:0 andJ:0];
    [c setValue:-sin(phi) andI:0 andJ:1];
    [c setValue:sin(phi) andI:1 andJ:0];
    [c setValue:cos(phi) andI:1 andJ:1];
}

// Трансформация скалирования
+ (void)scale: (CGFloat)S andC: (TransformMatrix*)c {
    [c setValue:S andI:0 andJ:0];
    [c setValue:S andI:1 andJ:1];
}

@end
