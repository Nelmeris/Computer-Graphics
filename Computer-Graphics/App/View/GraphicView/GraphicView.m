//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransformClip.h"
#import "TransformShape.h"

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define NSColorFromHEX(hexValue) [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define BACKGROUND_COLOR 0xFFFFFF
#define CLIP_AREA_COLOR 0x000000
#define CLIP_AREA_MARGIN 10.0
#define CLIP_AREA_THICKNESS 5

#define SELECTED_SHAPE_THICKNESS 2

@interface GraphicView () {
}

@end

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        shapes = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"ColorPicked" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThickness:) name:@"ThicknessPicked" object:NULL];
        selectedShapeIndex = -1;
    }
    return self;
}

- (void)changeColor:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    [[self selectedShape].shape setColor:dict[@"color"]];
    [self setNeedsDisplay:YES];
}

- (void)changeThickness:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    CGFloat thickness = [((NSNumber*)dict[@"thickness"]) floatValue];
    [[self selectedShape].shape setThickness:thickness];
    [self setNeedsDisplay:YES];
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
    
    // Pass through all shapes
    for (TransformShape *tShape in shapes) {
        CoreTransform* transform = tShape.transform;
        Shape* shape = [tShape.shape copy];
        
        // Setting clip area
        NSBezierPath *clipRectangle = [NSBezierPath bezierPath];
        [clipRectangle appendBezierPathWithRect:[transform makeClipRectangle]];
        
        [NSColorFromHEX(CLIP_AREA_COLOR) setStroke];
        [clipRectangle setLineWidth:CLIP_AREA_THICKNESS];
        [clipRectangle stroke];
        
        [self autoScaling:shape];
        [shape.color setStroke];
        
        // Drawing the transformed points
        for (Line *line in shape.lines) {
            Line *transformedLine = [transform transformLine:line];
            if ([transform clipLine:transformedLine]) {
                CGFloat thickness = shape.thickness +
                    ((shape == [self selectedShape].shape) ? SELECTED_SHAPE_THICKNESS : 0);
                [transformedLine drawWithColor:shape.color width:thickness];
            }
        }
    }
}

- (void)clear {
    selectedShapeIndex = -1;
    [shapes removeAllObjects];
    [self setNeedsDisplay:YES];
}

- (Shape*)autoScaling: (Shape*)shape {
    CGFloat scalarX = ((VIEW_WIDTH - CLIP_AREA_MARGIN * 2) / 1000);
    CGFloat scalarY = ((VIEW_HEIGHT - CLIP_AREA_MARGIN * 2) / 1000);
    
    [shape scaling:((scalarX < scalarY) ? scalarX : scalarY)];
    
    return shape;
}

- (void)addShape:(Shape *)shape {
    CoreTransform* transform = [[CoreTransform alloc]initWithView:self clipAreaMargin:CLIP_AREA_MARGIN];
    TransformShape* tShape = [[TransformShape alloc] init];
    tShape.shape = shape;
    tShape.transform = transform;
    [shapes addObject:tShape];
    [self selectShape:shapes.count - 1];
}

- (void)nextShape {
    if (shapes.count == 0) return;
    
    if (selectedShapeIndex == shapes.count - 1)
        [self selectShape:-1];
    else
        [self selectShape:selectedShapeIndex + 1];
}

- (void)prevShape {
    if (shapes.count == 0) return;
    
    if (selectedShapeIndex == -1)
        [self selectShape:shapes.count - 1];
    else
        [self selectShape:selectedShapeIndex - 1];
}

- (void)selectShape:(NSInteger)index {
    if (index >= (NSInteger)shapes.count)
        return;
    
    selectedShapeIndex = index;
    
    if (selectedShapeIndex == -1)
        [controller disableFigureButtons];
    else
        [controller enableFigureButtons];
    
    [self setNeedsDisplay:YES];
}

- (TransformShape *)selectedShape {
    if (selectedShapeIndex == -1)
        return NULL;
    return shapes[selectedShapeIndex];
}

- (void)removeSelectedShape {
    TransformShape* shape = self.selectedShape;
    [self prevShape];
    [shapes removeObject:shape];
    [self setNeedsDisplay:YES];
}

- (NSArray<Shape *> *)getShapes {
    NSMutableArray* result = [NSMutableArray new];
    for (TransformShape *tShape in shapes) {
        CoreTransform* core = tShape.transform;
        Shape* shape = [tShape.shape copy];
        [shape transform:core];
        [result addObject:shape];
    }
    return [result copy];
}

@end
