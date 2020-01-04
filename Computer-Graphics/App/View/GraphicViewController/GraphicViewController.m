//
//  GraphicViewController.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GraphicViewController.h"
#import "Shape.h"
#import "ColorPickerViewController.h"
#import "ThicknessPickerViewController.h"
#import <Carbon/Carbon.h>

#define PROJECT_FILE_TYPE @"npj"
#define SHAPE_FILE_TYPE @"nsh"

@interface GraphicViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property NSString* fileURL;

@property (weak) IBOutlet NSMenuItem *addFigureMenuItem;

@property (weak) IBOutlet NSMenuItem *thicknessFigureMenuItem;
@property (weak) IBOutlet NSMenuItem *colorFigureMenuItem;
@property (weak) IBOutlet NSMenuItem *removeFigureMenuItem;

@property (weak) IBOutlet NSMenuItem *saveFileMenuItem;
@property (weak) IBOutlet NSMenuItem *saveAsFileMenuItem;
@property (weak) IBOutlet NSMenuItem *closeFileMenuItem;

@end

@implementation GraphicViewController

- (void)viewDidLoad {
    _keys = [NSMutableArray new];
    [logTableView setHidden:YES];
    [logTableView setDelegate:self];
    [logTableView setDataSource:self];
    [self disableFigureButtons];
    [self disableFileButtons];
}

- (void)disableFigureButtons {
    [_thicknessFigureMenuItem setTarget:NULL];
    [_thicknessFigureMenuItem setAction:NULL];
    [_colorFigureMenuItem setTarget:NULL];
    [_colorFigureMenuItem setAction:NULL];
    [_removeFigureMenuItem setTarget:NULL];
    [_removeFigureMenuItem setAction:NULL];
}

- (void)disableFileButtons {
    [_saveFileMenuItem setTarget:NULL];
    [_saveFileMenuItem setAction:NULL];
    [_saveAsFileMenuItem setTarget:NULL];
    [_saveAsFileMenuItem setAction:NULL];
    [_closeFileMenuItem setTarget:NULL];
    [_closeFileMenuItem setAction:NULL];
    [_addFigureMenuItem setTarget:NULL];
    [_addFigureMenuItem setAction:NULL];
}

@end

@implementation GraphicViewController (Log)

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _keys.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return ((KeyInfo*)_keys[row]).description;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    [cell.textField setStringValue:((KeyInfo*)_keys[_keys.count - 1 - row]).description];
    return cell;
}

- (IBAction)showOrHideLog:(NSMenuItem *)sender {
    [logTableView setHidden:!logTableView.isHidden];
}

- (void)addKeyToLog:(KeyInfo*)key {
    [_keys addObject:key];
    [logTableView reloadData];
}

@end

@implementation GraphicViewController (Shapes)

- (void)removeShape:(NSMenuItem *)sender {
    [graphicView removeSelectedShape];
    [graphicView redraw];
}

- (IBAction)openThicknessPicker:(NSMenuItem *)sender {
    [self performSegueWithIdentifier:@"ThicknessPickerSegue" sender:self];
}

- (IBAction)openColorPicker:(NSMenuItem *)sender {
    [self performSegueWithIdentifier:@"ColorPickerSegue" sender:self];
}

- (void)keyUp:(NSEvent *)event {
    if (event.modifierFlags != 256 || !graphicView.selectedShape)
        return;
    if (event.keyCode == kVK_ANSI_C)
        [self openColorPicker:NULL];
    if (event.keyCode == kVK_ANSI_T)
        [self openThicknessPicker:NULL];
}

- (IBAction)newShape:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:SHAPE_FILE_TYPE, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSWindow* window = NSApplication.sharedApplication.mainWindow;
    [panel beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse response) {
        if (response != NSModalResponseOK) return;
      
        NSString *path = panel.URL.relativePath;
        
        NSArray<Shape*>* shapes = [Shape loadShapesFromFile:path];
        for (Shape* shape in shapes)
            [self->graphicView addShape:shape];
        
        [self->graphicView redraw];
    }];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[ColorPickerViewController class]]) {
        ColorPickerViewController *controller = segue.destinationController;
        if (!graphicView.selectedShape) return;
        
        NSColor *color = graphicView.selectedShape.shape.color;
        [controller setColor:color];
    }
    if ([segue.destinationController isKindOfClass:[ThicknessPickerViewController class]]) {
        ThicknessPickerViewController *controller = segue.destinationController;
        if (!graphicView.selectedShape) return;
        
        CGFloat thickness = graphicView.selectedShape.shape.thickness;
        [controller setThickness:thickness];
    }
}

- (void)enableFigureButtons {
    [_thicknessFigureMenuItem setTarget:self];
    [_thicknessFigureMenuItem setAction:@selector(openThicknessPicker:)];
    [_colorFigureMenuItem setTarget:self];
    [_colorFigureMenuItem setAction:@selector(openColorPicker:)];
    [_removeFigureMenuItem setTarget:self];
    [_removeFigureMenuItem setAction:@selector(removeShape:)];
}

@end

@implementation GraphicViewController (File)

- (IBAction)fileNew:(NSMenuItem *)sender {
    [graphicView clear];
    _fileURL = NULL;
    [self enableFileButtons];
    [self disableFigureButtons];
}

- (IBAction)fileOpen:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:PROJECT_FILE_TYPE, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSWindow* window = NSApplication.sharedApplication.mainWindow;
    [panel beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse response) {
        if (response != NSModalResponseOK) return;
      
        NSString* path = [panel URL].relativePath;
        self->_fileURL = path;
        
        [self->graphicView clear];
        
        NSArray<Shape*>* shapes = [Shape loadShapesFromFile:path];
        for (Shape* shape in shapes)
            [self->graphicView addShape:shape];
        
        [self enableFileButtons];
        [self->graphicView redraw];
    }];
}

- (IBAction)fileSave:(NSMenuItem *)sender {
    if (_fileURL)
        [Shape saveToFile:[graphicView getShapes] filePath:_fileURL];
    else
        [self fileSaveAs:NULL];
}

- (IBAction)fileSaveAs:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setCanCreateDirectories:YES];
    NSArray* fileTypes = [NSArray arrayWithObjects:PROJECT_FILE_TYPE, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSWindow* window = NSApplication.sharedApplication.mainWindow;
    [panel beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse response) {
        if (response != NSModalResponseOK) return;
      
        NSString *path = panel.URL.relativePath;
        self->_fileURL = path;
        
        [Shape saveToFile:[self->graphicView getShapes] filePath:path];
    }];
}

- (IBAction)fileClose:(id)sender {
    [graphicView clear];
    [self disableFileButtons];
    [self disableFigureButtons];
}

- (void)enableFileButtons {
    [_saveFileMenuItem setTarget:self];
    [_saveFileMenuItem setAction:@selector(fileSave:)];
    [_saveAsFileMenuItem setTarget:self];
    [_saveAsFileMenuItem setAction:@selector(fileSaveAs:)];
    [_closeFileMenuItem setTarget:self];
    [_closeFileMenuItem setAction:@selector(fileClose:)];
    [_addFigureMenuItem setTarget:self];
    [_addFigureMenuItem setAction:@selector(newShape:)];
}

@end
