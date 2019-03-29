//
//  GraphicViewController.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Shape.h"
#import "KeyInfo.h"

@class GraphicView;

@interface GraphicViewController : NSViewController  <NSTableViewDelegate, NSTableViewDataSource> {
    CGFloat defaultThickness;
    __weak IBOutlet GraphicView *graphicView;
}

@property (weak) IBOutlet NSTableView *logTableView;
@property NSMutableArray<Shape *> *shapes;
@property NSMutableArray<KeyInfo*> *keys;

@end
