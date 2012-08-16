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
    
    BOOL boostActive;
    BOOL moveUp;
    BOOL moveDown;
}

- (void)setTouch:(CGPoint)touchPoint;
- (void)touchEnded;
- (void)fire;
- (CGPoint)getParallaxPosition;
- (void)setGlideFactor:(double)factor;

@end
