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
    
    //Spieler zentrieren
    pos.x = W/2 - frameW/2;
    pos.y = H/2 - frameH/2;
    
    dead = false;
    angle = 0;
    speedScalar = 5;
    glideFactor = -1.5;
    //speed.y = -speedScalar; //Konstante Bewegung nach "vorne"
    speed.x = 80.0;
    speed.y = 0;
    
    counter = 0;
}

- (void)draw
{
    counter++;
        
    double g = 1.81;
    double v0 = 80.0;
      
    pos.x = 60;
    positionX = v0 * counter / 10.0;
    //pos.y = g/2 * pow(counter / 10.0, 2) * -glideFactor;
    pos.y += g*(counter/10)*glideFactor;
    
    speed.x = speed.x;
    speed.y = g * counter / 10.0;
        
    angle = speed.y*10/speed.x * 10;
        
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
    touchAction = false;
    glideFactor = -1.5;
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
    glideFactor = factor;
}


@end
