//
//  Mine.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Mine.h"
#import "GameManager.h"

@implementation Mine

- (void)additionalSetup
{
    autoDestroy = YES;
    sign = [[GameManager getInstance] getRndBetween: -1 and: 1];
    
    if (sign == 0) {
        sign = 1;
    }
}

- (void)renderSprite
{
    angle += (sign*5);
    
    [super renderSprite];
}

@end
