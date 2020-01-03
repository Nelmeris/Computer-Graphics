//
//  Line.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface Line : NSObject

@property (nonatomic) NSPoint from;
@property (nonatomic) NSPoint to;

- (instancetype)initWithFromPoint: (NSPoint)from toPoint: (NSPoint)to;

- (void)drawWithColor:(NSColor*)color width:(CGFloat)width;
- (void)erase;

@end
