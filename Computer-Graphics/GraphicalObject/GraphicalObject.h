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

- (id) init;

- (NSInteger) getPointsCount;
- (CGFloat) getThickness;

- (NSPoint) getPoint: (NSInteger)index;

- (void) loadFigure: (NSString*)filePath andBaseScaling: (CGFloat)scale andThickness: (CGFloat) thickness;

@end

NS_ASSUME_NONNULL_END
