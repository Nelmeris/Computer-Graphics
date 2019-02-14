//
//  Point.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 14/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPoint : NSObject

@property CGFloat x;
@property CGFloat y;

- (id) init: (NSInteger)x andY: (NSInteger)y;

@end

NS_ASSUME_NONNULL_END
