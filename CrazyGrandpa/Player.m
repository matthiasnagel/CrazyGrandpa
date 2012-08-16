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
    vmax = 300.0;
    vmin = 100.0;
    
    boostActive = false;
    
    moveDown = false;
    moveUp = false;
}

- (void)draw
{
    if(boostActive) {
        vX += (vmax - vX) * 0.02;
    } else if(moveUp) {
        vX += (vmax - vX) * 0.02;
    } else if(moveDown) {
        vX += (vmin - vX) * 0.02;
    } else {
        vX += (vmin - vX) * 0.02;
    }
    
    if(moveUp) {
        //pos.y += (120 - vX) * 0.10;
        vX += 3;
    } else if(moveDown) {
        //pos.y += 3;
        vX -= 3;
    } else {
        //vX += (vmin - vX) * 0.02;
    }
    
    pos.y += (120 - vX) * 0.10;
    
    positionX += vX * 0.09;
    
    if(pos.y > 600) {
        pos.y = 600;
    }
    if(pos.y < 0) {
        pos.y = 0;
    }
    
    speed.x = speed.x;
    speed.y = sqrt(pow(vX, 2) + pow(vY,2));
        
    angle = (-speed.y / speed.x) * 20 + 25;
    
    //Manage zoom & background position
    GameManager *gm = [GameManager getInstance];
    
    double factor = (((vX - 100) / 2) / 100) + 0.5;
    factor = factor / 2 + 0.5;
    if (factor < 0.5) { factor = 0.5; } else if (factor > 1.0) { factor = 1.0; }
    
    double dY = -pos.y+50;
    
    if(dY > 0) { dY = 0; }
    
    [gm setZoomFactor:factor to:dY];
    
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
    if (point.x < 100) {
        moveUp = TRUE;
        moveDown = FALSE;
        boostActive = FALSE;
    } else if (point.x > 100 && point.x < 300) {
        NSLog(@"middle");
        boostActive = TRUE;
        moveDown = FALSE;
        moveUp = FALSE;
    } else {
        moveDown = TRUE;
        moveUp = FALSE;
        boostActive = FALSE;
        NSLog(@"right");
    }}

- (void)touchEnded
{
    boostActive = FALSE;
    moveUp = FALSE;
    moveDown = FALSE;
    NSLog(@"touch ended.");
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
