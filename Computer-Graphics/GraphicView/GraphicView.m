//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransformClip.h"

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define NSColorFromHEX(hexValue) [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define BACKGROUND_COLOR 0xFFFFFF
#define CLIP_AREA_COLOR 0x000000
#define CLIP_AREA_MARGIN 30.0

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        transform = [[CoreTransform alloc]initWithView:self clipAreaMargin:CLIP_AREA_MARGIN];
    }
    return self;
}

- (void)viewWillDraw {
    controller = (GraphicViewController*)self.window.contentViewController;
}

- (void)drawRect: (NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Setting background
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRect: NSMakeRect(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];

    [NSColorFromHEX(BACKGROUND_COLOR) setFill];
    [background fill];
    
    // Setting clip area
    NSBezierPath *clipRectangle = [NSBezierPath bezierPath];
    [clipRectangle appendBezierPathWithRect:[transform makeClipRectangle]];
    
    [NSColorFromHEX(CLIP_AREA_COLOR) setStroke];
    [clipRectangle setLineWidth:5];
    [clipRectangle stroke];
    
    // Pass through all shapes
    for (NSInteger i = 0; i < controller.shapes.count; i++) {
        Shape *shape = [controller.shapes objectAtIndex: i];
        [self autoScaling:shape];
        [shape.color setStroke];
        
        NSInteger linesCount = [shape getLinesCount];
        if (linesCount == 0) continue;
        
        // Drawing the transformed points
        NSMutableArray<Line *> *lines = [shape getLines];
        
        for (NSInteger i = 0; i < linesCount; i++)
        {
            Line *transformedLine = [transform transformLine:lines[i]];
            if ([transform clipLine:transformedLine]) {
                [transformedLine drawWithColor:shape.color width:shape.thickness];
            }
        }
    }
}

- (Shape*)autoScaling: (Shape*)shape {
    CGFloat scalarX = (VIEW_WIDTH / 4) / [shape getWidth];
    CGFloat scalarY = (VIEW_HEIGHT / 4) / [shape getHeight];
    
    [shape scaling:(1 - scalarX > 1 - scalarY) ? scalarX : scalarY];
    return shape;
}

@end
