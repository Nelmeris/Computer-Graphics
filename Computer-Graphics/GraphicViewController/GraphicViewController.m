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

@interface GraphicViewController () <NSTableViewDelegate, NSTableViewDataSource>

@end

@implementation GraphicViewController

- (void)awakeFromNib
{
    [_logTableView setDelegate:self];
    [_logTableView setDataSource:self];
    defaultThickness = 2.5;
}

- (void)viewDidLoad {
    _shapes = [NSMutableArray new];
    _keys = [NSMutableArray new];
}

//- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
//    [NSTimer scheduledTimerWithTimeInterval:5.0
//                                     target:self
//                                   selector:@selector(deleteRowWhithIndex:)
//                                   userInfo:nil
//                                    repeats:NO];
//}

//- (void)deleteRowWhithIndex:(NSInteger)index {
//    [_logTableView removeRowsAtIndexes:[[NSIndexSet alloc]initWithIndex:_logTableView.numberOfRows - 1] withAnimation:YES];
//    [_keys removeObjectAtIndex:0];
//}

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
