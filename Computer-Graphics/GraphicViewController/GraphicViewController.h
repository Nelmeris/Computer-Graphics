//
//  GraphicViewController.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 16/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GraphicView;

NS_ASSUME_NONNULL_BEGIN

@interface GraphicViewController : NSViewController {
    CGFloat defaultThickness;
    __weak IBOutlet GraphicView *graphicView;
}

@property NSMutableArray *figures;

@end

NS_ASSUME_NONNULL_END
