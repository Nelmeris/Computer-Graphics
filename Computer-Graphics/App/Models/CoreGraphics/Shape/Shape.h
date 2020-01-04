//
//  GraphicalObject.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"
#import "CoreTransform.h"

@interface Shape : NSObject <NSCopying> {
    NSMutableArray<Line *> *_lines;
}

@property (nonatomic, strong) NSColor* color;
@property (nonatomic) CGFloat thickness;
@property (nonatomic) NSArray<Line *> *lines;

- (instancetype)init;

+ (NSArray<Shape*>*)loadShapesFromFile:(NSString *)filePath;
+ (void)saveToFile:(NSArray<Shape*>*)shapes filePath:(NSString *)filePath;

- (void)scaling:(CGFloat)value;
- (void)transform:(CoreTransform*)core;

- (CGFloat)getMinX;
- (CGFloat)getMinY;
- (CGFloat)getMaxX;
- (CGFloat)getMaxY;

- (CGFloat)getWidth;
- (CGFloat)getHeight;

@end
