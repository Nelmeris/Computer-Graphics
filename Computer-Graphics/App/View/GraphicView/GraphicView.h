//
//  GraphicView.h
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphicViewController.h"
#import "TransformShape.h"

@interface GraphicView : NSView {
    GraphicViewController* controller;
    NSMutableArray<TransformShape*> *shapes;
    NSUInteger selectedShapeIndex;
}

@property (readonly) TransformShape* selectedShape;

- (void)addShape:(Shape*)shape;
- (void)removeSelectedShape;
- (void)clear;
- (void)nextShape;
- (void)prevShape;
- (void)selectShape:(NSInteger)index;
- (NSArray<Shape*>*)getShapes;

@end
