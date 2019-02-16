//
//  GraphicViewController.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicViewController.h"
#import "GraphicView.h"
#import "GraphicalObject.h"

@interface GraphicViewController ()

@end

@implementation GraphicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaultThickness = 2.5;
    _figures = [[NSMutableArray alloc] init];
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
            GraphicalObject *figure = [[GraphicalObject alloc]init];
            [figure loadFigure:url.relativePath];
            [figure setThickness:defaultThickness];
            [self.figures addObject:figure];
            [graphicView setNeedsDisplay:YES];
        }
    }
}

@end
