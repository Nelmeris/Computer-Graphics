//
//  GraphicView.h
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreTransform.h"

@class TransformMatrix;

NS_ASSUME_NONNULL_BEGIN

@interface GraphicView : NSView {
    NSMutableArray *paths;
    NSMutableArray *figures;
    TransformMatrix *transform;
    CGFloat defaultThickness;
}

@end

NS_ASSUME_NONNULL_END
