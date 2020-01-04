//
//  GraphicView.m
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicView.h"
#import "CoreTransformClip.h"
#import "ShapeOnView.h"
#import "ColorHex.h"

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define BACKGROUND_COLOR 0xFFFFFF
#define CLIP_AREA_COLOR 0x000000
#define CLIP_AREA_MARGIN 20
#define CLIP_AREA_THICKNESS 5

#define SELECTED_SHAPE_THICKNESS 2

@interface GraphicView () {
    NSBezierPath* background;
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
        background = NULL;
    }
    return self;
}

- (void)changeColor:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    [[self selectedShape].shape setColor:dict[@"color"]];
    [self redraw];
}

- (void)changeThickness:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    CGFloat thickness = [((NSNumber*)dict[@"thickness"]) floatValue];
    [[self selectedShape].shape setThickness:thickness];
    [self redraw];
}

- (void)viewWillDraw {
    controller = (GraphicViewController*)self.window.contentViewController;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Setting background
    NSRect rect = NSMakeRect(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
    background = [NSBezierPath bezierPathWithRect:rect];
    NSColor* bgColor = [NSColor colorWithHex:BACKGROUND_COLOR];
    [bgColor setFill];
    [background fill];
    
    // Pass through all shapes
    for (ShapeOnView *tShape in shapes) {
        CoreTransform* core = tShape.transform;
        Shape* shape = [tShape.shape copy];
        
        // Setting clip area
        NSRect rect = [core makeClipRectangle];
        tShape.clipRectangle = [NSBezierPath bezierPathWithRect:rect];
        NSColor* clipRectangleColor = [NSColor colorWithHex:CLIP_AREA_COLOR];
        [clipRectangleColor setStroke];
        [tShape.clipRectangle setLineWidth:CLIP_AREA_THICKNESS];
        [tShape.clipRectangle stroke];
        
        // Setting shape
        [shape transform:core];
        [self autoScaling:shape];
        [shape.color setStroke];
        
        // Drawing the transformed points
        for (Line *line in shape.lines) {
            CGFloat thickness = shape.thickness +
                ((tShape.shape == [self selectedShape].shape) ? SELECTED_SHAPE_THICKNESS : 0);
            if ([core clipLine:line])
                [line drawWithColor:shape.color width:thickness];
        }
    }
}

- (void)redraw {
    [self setNeedsDisplay:YES];
}

- (void)autoScaling: (Shape*)shape {
    CGFloat scalarX = ((VIEW_WIDTH - CLIP_AREA_MARGIN * 2) / 1000);
    CGFloat scalarY = ((VIEW_HEIGHT - CLIP_AREA_MARGIN * 2) / 1000);
    
    CGFloat finalScalar = ((scalarX < scalarY) ? scalarX : scalarY);
    [shape scaling:finalScalar];
}

- (void)clear {
    selectedShapeIndex = -1;
    [shapes removeAllObjects];
    [self redraw];
}

- (void)addShape:(Shape *)shape {
    CoreTransform* transform = [[CoreTransform alloc]initWithView:self clipAreaMargin:CLIP_AREA_MARGIN];
    ShapeOnView* tShape = [ShapeOnView new];
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
}

- (ShapeOnView *)selectedShape {
    if (selectedShapeIndex == -1)
        return NULL;
    return shapes[selectedShapeIndex];
}

- (void)removeSelectedShape {
    ShapeOnView* shape = self.selectedShape;
    [self prevShape];
    [shapes removeObject:shape];
}

- (NSArray<Shape *> *)getShapes {
    NSMutableArray* result = [NSMutableArray new];
    for (ShapeOnView *tShape in shapes) {
        CoreTransform* core = tShape.transform;
        Shape* shape = [tShape.shape copy];
        [shape transform:core];
        [result addObject:shape];
    }
    return [result copy];
}

@end
