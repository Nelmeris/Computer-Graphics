//
//  GraphicViewController.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicViewController.h"
#import "GraphicView.h"
#import "Shape.h"

@interface GraphicViewController ()

@end

@implementation GraphicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaultThickness = 2.5;
    _shapes = [NSMutableArray new];
}

- (IBAction)fileOpen:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:@"txt", nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSModalResponseOK) {
        for (NSURL *url in [panel URLs]) {
            Shape *shape = [Shape new];
            [shape loadShapeFromFile:url.relativePath];
            [shape setThickness:defaultThickness];
            [self.shapes addObject:shape];
            [graphicView setNeedsDisplay:YES];
        }
    }
}

@end
