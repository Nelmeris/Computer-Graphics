//
//  Matrix.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject {
    NSMutableArray *matrix;
}

- (id)initWithRows: (NSInteger)rows andColumns: (NSInteger)columns;

- (CGFloat)getValue: (NSInteger)i andJ: (NSInteger)j;
- (void)setValue: (CGFloat)value andI: (NSInteger)i andJ: (NSInteger)j;

- (void)makeUnit;

- (NSInteger)getRowCount;
- (NSInteger)getColumnCount;

- (BOOL)isUnit;

- (void)print;

@end
