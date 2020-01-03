//
//  JSONDataTransformers.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 03.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <Cocoa/Cocoa.h>
#import "ColorHex.h"

@interface JSONValueTransformer (CustomTransformer)
@end

@implementation JSONValueTransformer (CustomTransformer)

- (NSString *)JSONObjectFromNSColor:(NSColor *)color
{
    return [color hexString];
}

@end
