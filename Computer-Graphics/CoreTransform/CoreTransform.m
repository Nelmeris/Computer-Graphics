//
//  Transform.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "CoreTransform.h"

@implementation CoreTransform

// Перемножение матриц
+ (void) times: (Matrix)a andB: (Matrix)b andC: (Matrix)c {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < M; j++) {
            float skalaar = 0;
            for (int k = 0; k < M; k++)
                skalaar += a[i][k] * b[k][j];
            c[i][j] = skalaar;
        }
    }
}

// Перемножение матрицы на вектор
+ (void) timesMatVec: (Matrix)a andB: (Vector)b andC: (Vector)c {
    for (int i = 0; i < M; i++) {
        float skalaar = 0;
        for (int j = 0; j < M; j++)
            skalaar += a[i][j] * b[j];
        c[i] = skalaar;
    }
}

// Копирование матрицы
+ (void) set: (Matrix)a andB: (Matrix)b {
    for (int i = 0; i < M; i++)
        for (int j = 0; j < M; j++)
            b[i][j] = a[i][j];
}

// Перевод точки в вектор
+ (void) point2vec: (NSPoint)a andB: (Vector)b {
    b[0] = a.x; b[1] = a.y; b[2] = 1;
}

// Перевод вектора в точку
+ (void) vec2point: (Vector)a andB: (NSPoint*) b {
    b->x = ((float)a[0]) / a[2];
    b->y = ((float)a[1]) / a[2];
}

// Создание вектора
+ (void) makeHomogenVec: (float)x andY: (float)y andC: (Vector)c {
    c[0] = x; c[1] = y; c[2] = 1;
}

// Сброс матрицы
+ (void) unit: (Matrix)a {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < M; j++) {
            if (i == j) a[i][j] = 1;
            else a[i][j] = 0;
        }
    }
}

// Трансформация перемещения
+ (void) move: (float)Tx andTy: (float)Ty andC: (Matrix)c {
    [CoreTransform unit:c];
    c[0][M - 1] = Tx;
    c[1][M - 1] = Ty;
}

// Трансформация поворота
+ (void) rotate: (float)phi andC: (Matrix)c {
    [CoreTransform unit:c];
    c[0][0] = cos(phi); c[0][1] = -sin(phi);
    c[1][0] = sin(phi); c[1][1] = cos(phi);
}

// Трансформация скалирования
+ (void) scale: (float)S andC: (Matrix)c {
    [CoreTransform unit:c];
    c[0][0] = S; c[1][1] = S;
}

@end
