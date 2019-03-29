//
//  CoreTransformClip.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTransform.h"
#import "Line.h"

@interface CoreTransform (Clip)

- (instancetype)initWithView:(NSView *)view clipAreaMargin:(CGFloat)margin;

- (NSRect)makeClipRectangle;

- (bool)clipLine:(Line*)line;
+ (bool)clipLine: (Line *)line andPMin: (NSPoint)Pmin andPMax: (NSPoint)Pmax;

@end
