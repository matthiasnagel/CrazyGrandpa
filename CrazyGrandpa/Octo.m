//
//  Octo.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Octo.h"
#import "GameManager.h"

@implementation Octo

- (void)additionalSetup
{
    autoDestroy = YES;
}

- (void) hit
{
    active = NO;
    [[GameManager getInstance] createExplosionFor:self];
}

@end
