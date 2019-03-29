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

+ (void)move: (CGFloat)x byY: (CGFloat)y matrix:(TransformMatrix*)c;
+ (void)rotate: (CGFloat)phi matrix:(TransformMatrix*)c;
+ (void)scale: (CGFloat)value matrix:(TransformMatrix*)c;

+ (void)rotateFrame: (CGFloat)phi frame: (NSRect)frame matrix: (TransformMatrix*)c;

+ (void)mirrorFrameRefByX: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)mirrorFrameRefByY: (NSRect)frame matrix: (TransformMatrix*)c;

+ (void)scaleFrame: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)scaleFrameRefByX: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;
+ (void)scaleFrameRefByY: (CGFloat)value frame: (NSRect)frame matrix: (TransformMatrix*)c;

@end
