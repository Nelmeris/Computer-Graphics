//
//  NSViewController+ThicknessPickerViewController.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 04.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import "ThicknessPickerViewController.h"

#import <AppKit/AppKit.h>

@interface ThicknessPickerViewController ()

@property (weak) IBOutlet NSTextField *thicknessField;
@property (weak) IBOutlet NSStepper *thicknessStepper;

@end

@implementation ThicknessPickerViewController

- (void)awakeFromNib {
    [_thicknessField setStringValue:[NSString stringWithFormat:@"%f", self.thickness]];
    [_thicknessStepper setFloatValue:self.thickness];
}

- (void)viewDidLoad {
    [_thicknessField setDelegate:self];
    [_thicknessStepper setIncrement:0.5];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [NSNotificationCenter.defaultCenter
        postNotificationName:@"ThicknessPicked"
        object:self
        userInfo:@{@"thickness":[NSNumber numberWithFloat:[_thicknessField.stringValue floatValue]] }];
}

- (IBAction)clickStepper:(NSStepper *)sender {
    CGFloat thickness = sender.floatValue;
    [_thicknessField setStringValue:[NSString stringWithFormat:@"%f", thickness]];
    [NSNotificationCenter.defaultCenter
        postNotificationName:@"ThicknessPicked"
        object:self
     userInfo:@{@"thickness":[NSNumber numberWithFloat:thickness] }];
}

- (IBAction)cancel:(NSButton *)sender {
    if (!_thickness) return;
    [NSNotificationCenter.defaultCenter
        postNotificationName:@"ThicknessPicked"
        object:self
     userInfo:@{@"thickness":[NSNumber numberWithFloat:_thickness] }];
    [self dismissController:self];
}

- (IBAction)apply:(NSButton *)sender {
    [NSNotificationCenter.defaultCenter
        postNotificationName:@"ThicknessPicked"
        object:self
        userInfo:@{@"thickness":[NSNumber numberWithFloat:[_thicknessField.stringValue floatValue]] }];
    [self dismissController:self];
}

@end
