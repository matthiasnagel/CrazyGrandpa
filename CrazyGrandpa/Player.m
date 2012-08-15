//
//  Player.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Player.h"
#import "GameManager.h"
#import "Bullet.h"
#import "Gear.h"

@implementation Player

- (void)additionalSetup
{
    touchAction = false;
    
    dead = false;
    angle = 0;
    speed.x = 80.0;
    speed.y = 0;
    
    //todo save pos.y (startposition), pos.x, vx, vmax and vmin in const.h
    pos.y = 30; //start position
    pos.x = 60;
    vX = 80.0;
    vmax = 180.0;
    vmin = 20.0;
    
    boostActive = false;
}

- (void)draw
{
    if(!boostActive) {
        vX += (vmin - vX) * 0.02;
    } else {
        vX += (vmax - vX) * 0.02;
    }
    
    positionX += vX * 0.2;
    
    pos.y += (80 - vX) * 0.025;
    
    speed.x = speed.x;
    speed.y = sqrt(pow(vX, 2) + pow(vY,2));
        
    angle = (-speed.y / speed.x) * 20 + 20;
        
    if (!dead) {
        [self fire];
        [self drawFrame];
    }
}

- (void)fire
{
    int sX = pos.x;
    int sY = pos.y;
    if (cnt % 5 == 0) {
        Bullet *bullet = [[GameManager getInstance] createSprite: BULLET
                                          speed: CGPointMake(speed.x*3, speed.y*3)
                                            pos: CGPointMake(sX, sY)];
        [bullet setAngle:angle];
    }
//    if (cnt % 2 == 0) {
//        Gear *gear =
//        [[GameManager getInstance] createSprite: GEAR
//                                          speed: CGPointMake(-speed.x, -speed.y)
//                                            pos: CGPointMake(pos.x, sY)];
//        [gear setAngle:angle];
//    }
}

- (void)setTouch:(CGPoint)point
{
    touchAction = true;
    if (point.x < W/2) {
        //nach links steuern
        moveLeft = YES;
    } else {
        //nach rechts steuern
        moveLeft = NO;
    }
}

- (void)touchEnded
{
    boostActive = FALSE;
}

- (void)hit
{
    if (!dead) {
        dead = YES;
        speed.x = 0; speed.y = 0;
        touchAction = false;
        [[GameManager getInstance] setState: GAME_OVER];
        [[GameManager getInstance] createExplosionFor: self];
    }
}

- (CGPoint)getParallaxPosition
{
    return CGPointMake(positionX, 0);
}

- (void)setGlideFactor:(double)factor
{
    boostActive = TRUE;
}


@end
