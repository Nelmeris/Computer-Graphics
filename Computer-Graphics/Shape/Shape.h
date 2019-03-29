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

@property CGFloat thickness;

- (instancetype)init;
- (instancetype)initFromFile:(NSString *)filePath;

- (void)loadShapeFromFile:(NSString *)filePath;

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
