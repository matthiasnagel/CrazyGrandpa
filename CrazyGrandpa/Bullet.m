//
//  Bullet.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (void)setAngle:(int)degree
{
    angle = degree;
    autoDestroy = YES;
}

- (void)hit
{
    active = NO;
}

@end
