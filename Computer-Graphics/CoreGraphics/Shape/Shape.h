//
//  GraphicalObject.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface Shape : NSObject {
    NSMutableArray<Line *> *lines;
}

@property (nonatomic, strong) NSColor* color;
@property (nonatomic) CGFloat thickness;

- (instancetype)init;
- (instancetype)initFromJSON:(NSString *)filePath;

- (void)loadShapeFromJSON:(NSString *)filePath;

- (NSInteger)getLinesCount;

- (void)scaling: (CGFloat)value;

- (CGFloat)getMinX;
- (CGFloat)getMinY;
- (CGFloat)getMaxX;
- (CGFloat)getMaxY;

- (CGFloat)getWidth;
- (CGFloat)getHeight;

- (NSMutableArray<Line *> *)getLines;

@end
