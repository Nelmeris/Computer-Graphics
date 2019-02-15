//
//  Matrix.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Matrix : NSObject {
    NSMutableArray *matrix;
}

- (id)init: (NSInteger)rows andColumns: (NSInteger)columns;

- (CGFloat)getValue: (NSInteger)i andJ: (NSInteger)j;
- (void)setValue: (CGFloat)value andI: (NSInteger)i andJ: (NSInteger)j;

- (void)makeUnit;

- (NSInteger)getRowCount;
- (NSInteger)getColumnCount;

- (BOOL)isEqual:(Matrix*)secondMatrix;

- (void)print;

@end

NS_ASSUME_NONNULL_END
