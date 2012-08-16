//
//  Player.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Sprite.h"


@interface Player : Sprite
{
    CGPoint touchPoint;
    bool touchAction;
    bool moveLeft;
    bool dead;
    int positionX;
    double vX;
    double vY;
    double v0;
    double vmin;
    double vmax;
    double boostFactor;
    double controlFactor;
    BOOL boostActive;
    
    //segeflugformel test
    double A;
    double W;
    double V;
    double u;
    double g;
}

- (void)setTouch:(CGPoint)touchPoint;
- (void)touchEnded;
- (void)fire;
- (CGPoint)getParallaxPosition;
- (void)setGlideFactor:(double)factor;

@end
