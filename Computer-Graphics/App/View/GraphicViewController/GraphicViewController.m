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
#import "ThicknessPickerViewController.h"

#define FILE_TYPES @"nsp"

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

- (void)awakeFromNib {
    [_logTableView setDelegate:self];
    [_logTableView setDataSource:self];
}

- (void)viewDidLoad {
    _keys = [NSMutableArray new];
    [_logTableView setHidden:YES];
    [self disableFigureButtons];
    [self disableFileButtons];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _keys.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    
    if (clicked != NSModalResponseOK) return;
    
    for (NSURL *url in [panel URLs]) {
        [graphicView clear];
        NSArray<Shape*>* shapes = [Shape loadShapesFromFile:url.relativePath];
        _fileURL = url.relativePath;
        for (Shape* shape in shapes)
            [graphicView addShape:shape];
    }
    [self enableFileButtons];
}

- (IBAction)fileSave:(NSMenuItem *)sender {
    [Shape saveToFile:[graphicView getShapes] filePath:_fileURL];
}

- (IBAction)fileSaveAs:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setCanCreateDirectories:YES];
    NSArray* fileTypes = [NSArray arrayWithObjects:FILE_TYPES, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked != NSModalResponseOK) return;
    NSURL *url = [panel URL];
    
    _fileURL = url.relativePath;
    [Shape saveToFile:[graphicView getShapes] filePath:_fileURL];
}

- (IBAction)fileClose:(id)sender {
    [graphicView clear];
    [self disableFileButtons];
    [self disableFigureButtons];
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

- (void)removeShape:(NSMenuItem *)sender {
    [graphicView removeSelectedShape];
}

- (IBAction)newShape:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    NSArray* fileTypes = [NSArray arrayWithObjects:FILE_TYPES, nil];
    [panel setAllowedFileTypes: fileTypes];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked != NSModalResponseOK) return;
    
    for (NSURL *url in [panel URLs]) {
        NSArray<Shape*>* shapes = [Shape loadShapesFromFile:url.relativePath];
        for (Shape* shape in shapes)
            [graphicView addShape:shape];
    }
}

- (IBAction)showOrHideLog:(NSMenuItem *)sender {
    [_logTableView setHidden:!_logTableView.isHidden];
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

- (void)disableFigureButtons {
    [_thicknessFigureMenuItem setTarget:NULL];
    [_thicknessFigureMenuItem setAction:NULL];
    [_colorFigureMenuItem setTarget:NULL];
    [_colorFigureMenuItem setAction:NULL];
    [_removeFigureMenuItem setTarget:NULL];
    [_removeFigureMenuItem setAction:NULL];
}

- (void)enableFigureButtons {
    [_thicknessFigureMenuItem setTarget:self];
    [_thicknessFigureMenuItem setAction:@selector(openThicknessPicker:)];
    [_colorFigureMenuItem setTarget:self];
    [_colorFigureMenuItem setAction:@selector(openColorPicker:)];
    [_removeFigureMenuItem setTarget:self];
    [_removeFigureMenuItem setAction:@selector(removeShape:)];
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
