//
//  Gear.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Gear.h"

@implementation Gear

- (void)draw
{
    if (active) {
        pos.x+=speed.x;
        pos.y+=speed.y;
        
        [self drawFrame];
        
        if (cnt > 3) {
            active = NO;
        }
    }
}

@end
