//
//  GraphicView.h
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreTransform.h"

NS_ASSUME_NONNULL_BEGIN

@interface GraphicView : NSView {
    NSMutableArray *paths;
    NSMutableArray *figures;
    Matrix transform;
}

@end

NS_ASSUME_NONNULL_END
