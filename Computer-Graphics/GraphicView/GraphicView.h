//
//  GraphicView.h
//  Computer Graphics
//
//  Created by Artem Kufaev on 12/02/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphicViewController.h"
#import "CoreTransform.h"

@interface GraphicView : NSView {
    GraphicViewController* controller;
    CoreTransform *transform;
}

@end
