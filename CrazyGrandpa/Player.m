//
//  Player.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 12.08.12.
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
    
    //Spieler zentrieren
    pos.x = W/2 - frameW/2;
    pos.y = H/2 - frameH/2;
    
    dead = false;
    angle = 0;
    speedScalar = 5;
    speed.y = -speedScalar; //Konstante Bewegung nach "vorne"
}

- (void)draw
{
    static int angleStep = 3;
    
    if (touchAction) {
        if (moveLeft) {
            angle-=angleStep;
        } else {
            angle+=angleStep;
        }
        angleStep++;
        if (angleStep > 10) {
            angleStep = 10;
        }
        speed.x =  sin([self getRad: angle])*speedScalar;
        speed.y = -cos([self getRad: angle])*speedScalar;
    } else {
        angleStep = 3;
    }
    
    pos.x += speed.x;
    pos.y += speed.y;
    
    if (!dead) {
        [self fire];
        [self drawFrame];
    }
}

- (void)fire
{
    int sX = pos.x + frameW/2 - 16;
    int sY = pos.y + frameH/2 - 16;
    if (cnt % 5 == 0) {
        Bullet *bullet = [[GameManager getInstance] createSprite: BULLET
                                          speed: CGPointMake(speed.x*3, speed.y*3)
                                            pos: CGPointMake(sX, sY)];
        [bullet setAngle:angle];
    }
    if (cnt % 2 == 0) {
        Gear *gear =
        [[GameManager getInstance] createSprite: GEAR
                                          speed: CGPointMake(-speed.x, -speed.y)
                                            pos: CGPointMake(sX, sY)];
        [gear setAngle:angle];
    }
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
    touchAction = false;
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


@end
