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
+ (void)times: (TransformMatrix*)a andB: (TransformMatrix*)b andC: (TransformMatrix*)c {
    for (NSInteger i = 0; i < M; i++) {
        for (NSInteger j = 0; j < M; j++) {
            CGFloat skalaar = 0.0;
            for (int k = 0; k < M; k++)
                skalaar += [a getValue:i andJ:k] * [b getValue:k andJ:j];
            [c setValue:skalaar andI:i andJ:j];
        }
    }
}

// Перемножение матрицы на вектор
+ (void) timesMatVec: (TransformMatrix*)a andB: (TransformVector*)b andC: (TransformVector*)c {
    for (int i = 0; i < M; i++) {
        CGFloat skalaar = 0;
        for (int j = 0; j < M; j++)
            skalaar += [a getValue:i andJ:j] * [b getValue:j];
        [c setValue:skalaar andI:i];
    }
}

// Копирование матрицы
+ (void) set: (TransformMatrix*)a andB: (TransformMatrix*)b {
    for (int i = 0; i < M; i++)
        for (int j = 0; j < M; j++)
            [b setValue:[a getValue:i andJ:j] andI:i andJ:j];
}

// Перевод точки в вектор
+ (void) point2vec: (NSPoint)a andB: (TransformVector*)b {
    [b setValue:a.x andI:0];
    [b setValue:a.y andI:1];
    [b setValue:1 andI:2];
}

// Перевод вектора в точку
+ (void) vec2point: (TransformVector*)a andB: (NSPoint*) b {
    b->x = ((CGFloat)[a getValue:0]) / [a getValue:2];
    b->y = ((CGFloat)[a getValue:1]) / [a getValue:2];
}

// Создание вектора
+ (void) makeHomogenVec: (CGFloat)x andY: (CGFloat)y andC: (TransformVector*)c {
    [c setValue:x andI:0];
    [c setValue:y andI:1];
    [c setValue:1 andI:2];
}

// Трансформация перемещения
+ (void) move: (CGFloat)Tx andTy: (CGFloat)Ty andC: (TransformMatrix*)c {
    [c setValue:Tx andI:0 andJ:M - 1];
    [c setValue:Ty andI:1 andJ:M - 1];
}

// Трансформация поворота
+ (void) rotate: (CGFloat)phi andC: (TransformMatrix*)c {
    [c setValue:cos(phi) andI:0 andJ:0];
    [c setValue:-sin(phi) andI:0 andJ:1];
    [c setValue:sin(phi) andI:1 andJ:0];
    [c setValue:cos(phi) andI:1 andJ:1];
}

// Трансформация скалирования
+ (void) scale: (CGFloat)S andC: (TransformMatrix*)c {
    [c setValue:S andI:0 andJ:0];
    [c setValue:S andI:1 andJ:1];
}

@end
