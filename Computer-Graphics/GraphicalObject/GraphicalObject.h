//
//  GraphicalObject.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GraphicalObject : NSObject {
    NSMutableArray *points;
    CGFloat thickness;
}

- (id)init;

- (NSInteger)getPointsCount;
- (CGFloat)getThickness;

- (void)setThickness: (CGFloat)value;
- (void)scaling: (CGFloat)value;

- (CGFloat)getMinX;
- (CGFloat)getMinY;
- (CGFloat)getMaxX;
- (CGFloat)getMaxY;

- (CGFloat)getWidth;
- (CGFloat)getHeight;

- (NSPoint)getPoint: (NSInteger)index;

- (void)loadFigure: (NSString*)filePath;

@end

NS_ASSUME_NONNULL_END
