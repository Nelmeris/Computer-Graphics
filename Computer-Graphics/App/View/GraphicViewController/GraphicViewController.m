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
#import "ColorPickerViewController.h"

#define FILE_TYPES @"json"

@interface GraphicViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property NSString* fileURL;

@end

@implementation GraphicViewController

- (void)awakeFromNib
{
    [_logTableView setDelegate:self];
    [_logTableView setDataSource:self];
}

- (void)viewDidLoad {
    _keys = [NSMutableArray new];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _keys.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return ((KeyInfo*)_keys[row]).description;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    [cell.textField setStringValue:((KeyInfo*)_keys[_keys.count - 1 - row]).description];
    return cell;
}

- (IBAction)fileOpen:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:FILE_TYPES, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSModalResponseOK) {
        for (NSURL *url in [panel URLs]) {
            Shape *shape = [[Shape alloc] initFromJSON:url.relativePath];
            [graphicView addShape:shape];
        }
    }
}

- (IBAction)fileClose:(id)sender {
    [graphicView clear];
}

- (IBAction)fileSave:(NSMenuItem *)sender {
}

- (IBAction)fileSaveAs:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:FILE_TYPES, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSModalResponseOK) {
        for (NSURL *url in [panel URLs]) {
            NSLog(@"%@", url.relativePath);
        }
    }
}

- (IBAction)openThicknessPicker:(NSMenuItem *)sender {
    [self performSegueWithIdentifier:@"ThicknessPickerSegue" sender:self];
}

- (IBAction)openColorPicker:(NSMenuItem *)sender {
    [self performSegueWithIdentifier:@"ColorPickerSegue" sender:self];
}

- (void)colorUpdate:(NSColorPanel*)colorPanel{
    NSColor* theColor = colorPanel.color;
    NSLog(@"%f", theColor.blueComponent);
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[ColorPickerViewController class]]) {
        ColorPickerViewController *controller = segue.destinationController;
        if (graphicView.selectedShape) {
            NSColor *color = graphicView.selectedShape.shape.color;
            [controller setColor:color];
        }
    }
}

@end
