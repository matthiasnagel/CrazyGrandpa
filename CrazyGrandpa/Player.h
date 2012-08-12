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
    int speedScalar;
    bool dead;
}

- (void)setTouch:(CGPoint)touchPoint;
- (void)touchEnded;
- (void)fire;

@end
