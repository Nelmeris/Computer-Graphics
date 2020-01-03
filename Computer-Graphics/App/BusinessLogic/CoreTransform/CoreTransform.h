//
//  Transform.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"
#import <AppKit/AppKit.h>

@class TransformMatrix;
@class TransformVector;
@class Shape;

#define M 3

@interface CoreTransform : NSObject {
    TransformMatrix *matrix;
    NSView *view;
    CGFloat margin;
}

- (instancetype)initWithView:(NSView *)view;
- (void)reset;

- (Line *)transformLine: (Line *)line;

- (void)move:(CGFloat)x byY:(CGFloat)y;
- (void)rotate:(CGFloat)phi;
- (void)scale:(CGFloat)value;

- (void)rotateFrame:(CGFloat)phi;

- (void)mirrorFrameRefByX;
- (void)mirrorFrameRefByY;

- (void)scaleFrame:(CGFloat)value;
- (void)scaleFrameRefByX:(CGFloat)value;
- (void)scaleFrameRefByY:(CGFloat)value;

@end
