//
//  GraphicViewController.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Shape.h"

@class GraphicView;

@interface GraphicViewController : NSViewController {
    CGFloat defaultThickness;
    __weak IBOutlet GraphicView *graphicView;
}

@property NSMutableArray<Shape *> *shapes;

@end
