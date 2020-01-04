//
//  ColorHex.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 03.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@implementation NSColor (Hex)

+ (NSColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString characterAtIndex:0] == '#')
        [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgbValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = ((rgbValue & 0x0000FF) >> 0) / 255.0;
    return [NSColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (NSColor*) colorWithHex: (NSUInteger)hex {
    CGFloat red, green, blue, alpha;

    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;

    return [NSColor colorWithRed: red green:green blue:blue alpha:alpha];
}

- (uint)hex {
    CGFloat red, green, blue, alpha;

    @try {
        [self getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    @catch (NSException *exception) {
        [self getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }

    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    alpha = roundf(alpha * 255.f);

    return ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
}

- (NSString*)hexString {
    return [NSString stringWithFormat:@"%08x", [self hex]];
}

@end
