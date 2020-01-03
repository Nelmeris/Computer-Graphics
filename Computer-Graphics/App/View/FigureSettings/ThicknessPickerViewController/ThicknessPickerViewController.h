//
//  NSViewController+ThicknessPickerViewController.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 04.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThicknessPickerViewController : NSViewController <NSTextFieldDelegate>

@property CGFloat thickness;

@end

NS_ASSUME_NONNULL_END
