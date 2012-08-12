//
//  Fighter.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Fighter.h"

@implementation Fighter

- (void)additionalSetup
{
    angle = 0;
    angleOffset = 3;
    pathCnt = 0;
    speedScalarX = speed.x;
    speedScalarY = speed.y;
    autoDestroy = true;
}

- (void)draw
{
    int animationPath[ ] = {-5, -5, -5, 5, 5, 5, -5, 5, 3, 3, 5, 5, -5};
    
    if (cnt % 10 == 0) {
        angleOffset = animationPath[pathCnt];
        pathCnt ++;
        if (pathCnt > sizeof(animationPath)/sizeof(int)-1) {
            pathCnt = 0;
        }
    }
    
    angle += angleOffset;
    speed.x =  sin([self getRad: angle])*speedScalarX;
    speed.y = -cos([self getRad: angle])*speedScalarY;
    
    pos.x += speed.x;
    pos.y += speed.y;
    
    [self drawFrame];
}  


@end
