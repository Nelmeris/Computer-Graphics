//
//  GraphicView.h
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphicViewController.h"
#import "ShapeOnView.h"

@class GraphicViewController;
@interface GraphicView : NSView {
    GraphicViewController* controller;
    NSMutableArray<ShapeOnView*> *shapes;
    NSUInteger selectedShapeIndex;
    NSArray<KeyInfo*>* hotkeys;
}

@property (readonly) ShapeOnView* selectedShape;

- (void)addShape:(Shape*)shape;
- (void)removeSelectedShape;
- (void)clear;
- (void)nextShape;
- (void)prevShape;
- (void)selectShape:(NSInteger)index;
- (NSArray<Shape*>*)getShapes;
- (void)redraw;

@end
