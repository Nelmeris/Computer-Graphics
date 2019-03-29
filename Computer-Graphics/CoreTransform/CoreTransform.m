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
#import "Shape.h"

@implementation CoreTransform

- (instancetype)initWithView:(NSView *)view {
    self = [super init];
    if (self) {
        matrix = [TransformMatrix new];
        margin = 0;
        self->view = view;
    }
    return self;
}

- (void)reset {
    [matrix makeUnit];
}

- (Line *)transformLine:(Line *)line {
    // Convert point to vector
    TransformVector* vectorFrom = [[TransformVector alloc]initWithPoint:line.from];
    TransformVector* vectorTo = [[TransformVector alloc]initWithPoint:line.to];
    // Multiplying a vector by a transformation matrix
    TransformVector* newVectorFrom = [matrix multiVec:vectorFrom];
    TransformVector* newVectorTo = [matrix multiVec:vectorTo];
    // Return the converted line
    return [[Line alloc] initWithFromPoint:[newVectorFrom makePoint] toPoint:[newVectorTo makePoint]];
}

- (void)move:(CGFloat)x byY:(CGFloat)y {
    TransformMatrix *matrix = [TransformMatrix new];
    [matrix setValue:x andI:0 andJ:M - 1];
    [matrix setValue:y andI:1 andJ:M - 1];
    self->matrix = [matrix multi:self->matrix];
}

- (void)rotate:(CGFloat)phi {
    TransformMatrix *matrix = [TransformMatrix new];
    [matrix setValue:cos(phi) andI:0 andJ:0];
    [matrix setValue:-sin(phi) andI:0 andJ:1];
    [matrix setValue:sin(phi) andI:1 andJ:0];
    [matrix setValue:cos(phi) andI:1 andJ:1];
    self->matrix = [matrix multi:self->matrix];
}

- (void)scale: (CGFloat)value {
    TransformMatrix *matrix = [TransformMatrix new];
    [matrix setValue:value andI:0 andJ:0];
    [matrix setValue:value andI:1 andJ:1];
    self->matrix = [matrix multi:self->matrix];
}

- (void)rotateFrame: (CGFloat)phi {
    TransformMatrix *matrix = [TransformMatrix new];
    [CoreTransform rotate:phi matrix:matrix];
    CGFloat x = view.frame.size.width / 2;
    CGFloat y = view.frame.size.height / 2;
    [CoreTransform
     move:x - x * cos(phi) + y * sin(phi)
     byY:y - x * sin(phi) - y * cos(phi)
     matrix:matrix];
    self->matrix = [matrix multi:self->matrix];
}

- (void)mirrorFrameRefByX {
    TransformMatrix *matrix = [TransformMatrix new];
    [CoreTransform move:view.frame.size.width byY:0 matrix:matrix];
    [matrix setValue:-1 andI:0 andJ:0];
    self->matrix = [matrix multi:self->matrix];
}

- (void)mirrorFrameRefByY {
    TransformMatrix *matrix = [TransformMatrix new];
    [CoreTransform move:0 byY:view.frame.size.height matrix:matrix];
    [matrix setValue:-1 andI:1 andJ:1];
    self->matrix = [matrix multi:self->matrix];
}

- (void)scaleFrame: (CGFloat)value {
    TransformMatrix *matrix = [TransformMatrix new];
    [CoreTransform move:(view.frame.size.width / 2) * (1 - value)
                    byY:(view.frame.size.height / 2) * (1 - value)
                 matrix:matrix];
    [matrix setValue:value andI:0 andJ:0];
    [matrix setValue:value andI:1 andJ:1];
    self->matrix = [matrix multi:self->matrix];
}

- (void)scaleFrameRefByX: (CGFloat)value {
    TransformMatrix *matrix = [TransformMatrix new];
    [matrix setValue:(view.frame.size.width / 2) * (1 - value) andI:0 andJ:M - 1];
    [matrix setValue:value andI:0 andJ:0];
    self->matrix = [matrix multi:self->matrix];
}

- (void)scaleFrameRefByY: (CGFloat)value {
    TransformMatrix *matrix = [TransformMatrix new];
    [matrix setValue:(view.frame.size.height / 2) * (1 - value) andI:1 andJ:M - 1];
    [matrix setValue:value andI:1 andJ:1];
    self->matrix = [matrix multi:self->matrix];
}

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

@end
