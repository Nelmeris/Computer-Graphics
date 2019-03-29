//
//  Line.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (nonatomic) NSPoint from;
@property (nonatomic) NSPoint to;

- (instancetype)initWithFromPoint: (NSPoint)from toPoint: (NSPoint)to;

- (NSPoint *)getPointFrom;
- (NSPoint *)getPointTo;

@end
