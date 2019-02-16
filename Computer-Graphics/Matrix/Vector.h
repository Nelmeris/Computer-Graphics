//
//  Vector.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

NS_ASSUME_NONNULL_BEGIN

@interface Vector : NSObject {
    NSMutableArray *vector;
}

- (id)init: (NSInteger)columns;

- (CGFloat)getValue: (NSInteger)i;
- (void)setValue: (CGFloat)value index: (NSInteger)i;

- (void)makeZero;

- (NSInteger)getCount;

- (BOOL)isEqual: (Vector*)secondVector;

- (void)print;

@end

NS_ASSUME_NONNULL_END
