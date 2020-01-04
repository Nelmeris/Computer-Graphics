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
#import "GraphicView.h"

@class GraphicView;

@interface GraphicViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
    __weak IBOutlet GraphicView* graphicView;
    __weak IBOutlet IBOutlet NSTableView *logTableView;
}

@property NSMutableArray<KeyInfo*>* keys;

@end

@interface GraphicViewController (Figure)

- (void)disableFigureButtons;
- (void)enableFigureButtons;

@end

@interface GraphicViewController (Log)

- (void)addKeyToLog:(KeyInfo*)key;

@end
