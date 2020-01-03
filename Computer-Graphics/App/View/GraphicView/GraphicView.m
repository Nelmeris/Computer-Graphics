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
#define CLIP_AREA_MARGIN 30.0

#define SELECTED_SHAPE_THICKNESS 2

@interface GraphicView () {
}

@end

@implementation GraphicView

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        shapes = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"ColorPicked" object:NULL];
        selectedShapeIndex = -1;
    }
    return self;
}

- (void)changeColor:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    [[self selectedShape].shape setColor:dict[@"color"]];
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
        Shape* shape = tShape.shape;
        
        // Setting clip area
        NSBezierPath *clipRectangle = [NSBezierPath bezierPath];
        [clipRectangle appendBezierPathWithRect:[transform makeClipRectangle]];
        
        [NSColorFromHEX(CLIP_AREA_COLOR) setStroke];
        [clipRectangle setLineWidth:5];
        [clipRectangle stroke];
        
        [self autoScaling:shape];
        [shape.color setStroke];
        
        NSInteger linesCount = [shape getLinesCount];
        if (linesCount == 0) continue;
        
        // Drawing the transformed points
        for (Line *line in [shape getLines]) {
            Line *transformedLine = [transform transformLine:line];
            if ([transform clipLine:transformedLine]) {
                [transformedLine drawWithColor:shape.color width:shape.thickness];
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
    CGFloat scalarX = (VIEW_WIDTH / 4) / [shape getWidth];
    CGFloat scalarY = (VIEW_HEIGHT / 4) / [shape getHeight];
    
    [shape scaling:(1 - scalarX > 1 - scalarY) ? scalarX : scalarY];
    
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
    if (self.selectedShape)
        self.selectedShape.shape.thickness /= SELECTED_SHAPE_THICKNESS;
    
    if (selectedShapeIndex == shapes.count - 1)
        selectedShapeIndex = -1;
    else
        selectedShapeIndex++;
    
    if (self.selectedShape)
        self.selectedShape.shape.thickness *= SELECTED_SHAPE_THICKNESS;
    
    [self setNeedsDisplay:YES];
}

- (void)prevShape {
    if (shapes.count == 0) return;
    if (self.selectedShape)
        self.selectedShape.shape.thickness /= SELECTED_SHAPE_THICKNESS;
    
    if (selectedShapeIndex == -1)
        selectedShapeIndex = shapes.count - 1;
    else
        selectedShapeIndex--;
    
    if (self.selectedShape)
        self.selectedShape.shape.thickness *= SELECTED_SHAPE_THICKNESS;
    
    [self setNeedsDisplay:YES];
}

- (void)selectShape:(NSUInteger)index {
    if (shapes.count <= index)
        return;
    if (self.selectedShape)
        self.selectedShape.shape.thickness /= SELECTED_SHAPE_THICKNESS;
    
    selectedShapeIndex = index;
    
    if (self.selectedShape)
        self.selectedShape.shape.thickness *= SELECTED_SHAPE_THICKNESS;
    
    [self setNeedsDisplay:YES];
}

- (TransformShape *)selectedShape {
    if (selectedShapeIndex == -1)
        return NULL;
    return shapes[selectedShapeIndex];
}

@end
