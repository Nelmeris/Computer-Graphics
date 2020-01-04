//
//  ColorPickerViewController.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 03.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ColorHex.h"

@interface ColorPickerViewController ()

@property (weak) IBOutlet NSColorWell *colorWell;
@property (weak) IBOutlet NSTextField *colorHexField;

@end

@implementation ColorPickerViewController

- (void)awakeFromNib {
    if (self.color) {
        [_colorWell setColor:self.color];
        [_colorHexField setStringValue:self.color.hexString];
    }
}

- (IBAction)colorPicked:(NSColorWell*)sender {
    NSColor* color = sender.color;
    [_colorHexField setStringValue:color.hexString];
    [NSNotificationCenter.defaultCenter postNotificationName:@"ColorPicked" object:self userInfo:@{@"color": color}];
}

- (IBAction)cancel:(NSButton *)sender {
    [NSNotificationCenter.defaultCenter postNotificationName:@"ColorPicked" object:self userInfo:@{@"color": _color}];
    [self dismissController:self];
}

- (IBAction)apply:(NSButton *)sender {
    [NSNotificationCenter.defaultCenter postNotificationName:@"ColorPicked" object:self userInfo:@{@"color": _colorWell.color}];
    [self dismissController:self];
}

@end
