//
//  ParallaxLayer.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "ParallaxLayer.h"
#import "GameManager.h"
#import "Texture.h"

@implementation ParallaxLayer

- (id)initWithImage:(NSString *)imageName
{
    self = [super init];
    
    texture = [[GameManager getInstance] getTexture:imageName isImage: YES];
    layerWidth = [texture getWidth];
    layerHeight = [texture getHeight];
    
    refX = 0;
    refY = 0;
    oldX = 0;
    oldY = 0;
    
    return self;
}

- (void)drawWithFactor:(float)factor realtiveTo:(CGPoint)position atOrigin:(CGPoint)origin
{
    //Positionsaenderung des Spielers gegenueber dem vorherigen Frame ermitteln
    float px = position.x;
    float py = position.y;
    float diffX = px - oldX;
    float diffY = py - oldY;
    oldX = px;
    oldY = py;
    
    //Parallaxebene relativ zum Spieler verschieben
    //factor = 1 -> speed = actor
    //factor = 2 -> speed = actor/2 (halb so schnell)
    //usw.
    refX -= diffX/factor;
    refY -= diffY/factor;
    
    //Innerhalb dieser Grenzen wird der Referenzpunkt verschoben
    if (refX > layerWidth)  refX = 0;
    if (refX < 0)       refX = layerWidth;
    if (refY > layerHeight)  refY = 0;
    if (refY < 0)       refY = layerHeight;
    
    //Viewport vollstaendig mit Layer bekacheln, ausgehend vom Referenzpunkt
    for (float x = origin.x + refX-layerWidth; x < origin.x + W; x+=layerWidth) {
        for (float y = origin.y + refY-layerHeight; y < origin.y + H; y+=layerHeight) {
            [texture drawAt: CGPointMake(x, y)];
        }
    }
}


@end
