//
//  CoreTransformClip.m
//  Computer-Graphics
//
//  Created by Artem Kufaev on 29/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "CoreTransformClip.h"
#import "TransformMatrix.h"

@implementation CoreTransform (Clip)

- (instancetype)initWithView:(NSView *)view clipAreaMargin:(CGFloat)margin {
    self = [super init];
    if (self) {
        matrix = [TransformMatrix new];
        self->view = view;
        self->margin = margin;
        
        CGFloat scalarX = (view.frame.size.width - margin * 2) / view.frame.size.width;
        CGFloat scalarY = (view.frame.size.height - margin * 2) / view.frame.size.height;
        
        [self scaleFrame:(scalarX < scalarY) ? scalarX : scalarY];
    }
    return self;
}

- (NSRect)makeClipRectangle {
    return NSMakeRect(margin, margin, view.frame.size.width - margin * 2, view.frame.size.height - margin * 2);
}

- (bool)clipLine:(Line*)line {
    NSPoint Pmin = NSMakePoint(margin, margin);
    NSPoint Pmax = NSMakePoint(view.frame.size.width - margin, view.frame.size.height - margin);
    
    NSPoint from = line.from;
    NSPoint to = line.to;
    
    float tmin = 0, tmax = 1, P = 0.0, Q = 0.0;
    int i = 1;
    
    while (true)
    {
        if (i > 4)
        {
            float x = from.x + (to.x - from.x) * tmin;
            float y = from.y + (to.y - from.y) * tmin;
            [line setFrom:NSMakePoint(x, y)];
            
            x = from.x + (to.x - from.x) * tmax;
            y = from.y + (to.y - from.y) * tmax;
            [line setTo:NSMakePoint(x, y)];
            return true;
        }
        
        switch (i)
        {
            case 1: P = from.x - to.x; Q = from.x - Pmin.x; break;
            case 2: P = to.x - from.x; Q = Pmax.x - from.x; break;
            case 3: P = from.y - to.y; Q = from.y - Pmin.y; break;
            case 4: P = to.y - from.y; Q = Pmax.y - from.y; break;
        }
        
        if (P == 0)
        {
            if (Q < 0)
                return false;
            else
            {
                i++;
                continue;
            }
        }
        
        if (P > 0)
        {
            if (tmax > (Q / P))
                tmax = Q / P;
        }
        else
            if (tmin < (Q / P))
                tmin = Q / P;
        
        if (tmin > tmax)
            return false;
        else
        {
            i++;
            continue;
        }
    }
}

- (void)reset {
    [matrix makeUnit];
    
    CGFloat scalarX = (view.frame.size.width - margin * 2) / view.frame.size.width;
    CGFloat scalarY = (view.frame.size.height - margin * 2) / view.frame.size.height;
    
    [self scaleFrame:(scalarX < scalarY) ? scalarX : scalarY];
}

@end
