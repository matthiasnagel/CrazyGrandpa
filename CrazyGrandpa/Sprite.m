//
//  Sprite.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Sprite.h"
#import "Texture.h"
#import "GameManager.h"

@implementation Sprite

- (void) dealloc
{
    [super dealloc];
}

- (id)initWithImage:(NSString *)name frameCnt:(int)fcnt frameStep:(int)fstp speed:(CGPoint)sxy pos:(CGPoint)pxy
{    
    if (self = [super init]) {
        texture = [[GameManager getInstance] getTexture:name isImage:YES];
        speed = sxy;
        pos = pxy;
        cnt = 0;
        frameNr = 0;
        frameCnt = fcnt;
        frameStep = fstp;
        //Achtung: Frame-Anzahl*frameW muss der Bildbreite entsprechen
        frameW = [texture getWidth]/frameCnt;
        frameH = [texture getHeight];
        angle = 0;
        type = -1;
        tolBB = 10; //Bounding Box enger ziehen
        forceIdleness = NO;
        active = YES;
        autoDestroy = NO;
        [self additionalSetup];
    }
    
    return self;
}

- (void)additionalSetup
{
    //Override for individual setup
}

- (void)setType:(SpriteType)spriteType
{
    type = spriteType;
}

- (int)getType
{
    return type;
}

- (CGRect)getRect
{
    return CGRectMake(pos.x, pos.y, frameW, frameH);
}

- (void)setSpeed:(CGPoint)sxy
{
    speed = sxy;
}

- (CGPoint)getSpeed
{
    return speed;
}

- (CGPoint)getPos
{
    return pos;
}

- (bool)isActive
{
    return active;
}

- (void)draw
{
    if (active)
    {
        pos.x += speed.x;
        pos.y += speed.y;
        [self drawFrame];
    }
}

- (void)drawFrame
{
    frameNr = [self updateFrame];
    
    if (forceIdleness && speed.x == 0 && speed.y == 0) {
        frameNr = 0;
    }
    
    [self renderSprite];
}

- (void)renderSprite
{
    int tolBBBkp = tolBB;
    tolBB = 0;
    
    CGPoint o = [[GameManager getInstance] getViewportOrigin];
    
    if ([self checkColWithRect: CGRectMake(o.x, o.y, W, H)]) {
        [texture drawFrame: frameNr
                frameWidth: frameW
                     angle: angle
                        at: CGPointMake(pos.x, pos.y)];
        
    }
    else if (autoDestroy) { //Sprites sollen nicht unmittelbar zerstört werden
        int dist = H*3;
        
        if (![self checkColWithRect:
              CGRectMake(o.x-dist, o.y-dist, W+dist*2, H+dist*2)]) {
            active = false;
        }
    }
    
    tolBB = tolBBBkp;
}

//180 Grad = PI Rad -> [self getRad: 180] = PI
- (float)getRad:(float)grad
{
	float rad = (M_PI / 180) * grad;
	return rad;
}

- (int)updateFrame
{
    //if (frameStep != 0) {
    if (frameStep == cnt) {
        cnt = 0;
        frameNr++;
        if (frameNr > frameCnt-1) {
            frameNr = 0;
            cycleCnt++;
        }
    }
    cnt++;
    //}
    return frameNr;
}

- (void)hit
{
    //Override for individual collision handling
}

//Kollision Punkt <-> Rechteck
- (bool)checkColWithPoint:(CGPoint)p
{
    CGRect rect = [self getRect];
    
    if (    p.x > rect.origin.x
        &&  p.x < (rect.origin.x+rect.size.width)
		&&  p.y > rect.origin.y
        &&  p.y < (rect.origin.y+rect.size.height)) {
        return true;
    }
    
    return false;
}

//Kollision Rechteck <-> Rechteck
- (bool)checkColWithRect:(CGRect)rect
{
    CGRect rect1 = [self getRect];
    CGRect rect2 = rect;
    
    //Rect 1
    int x1=rect1.origin.x+tolBB; //Rect1: Punkt links oben
    int y1=rect1.origin.y+tolBB;
    int w1=rect1.size.width-tolBB*2;
    int h1=rect1.size.height-tolBB*2;
    
    //Rect 2
    int x3=rect2.origin.x; //Rect2: Punkt links oben
    int y3=rect2.origin.y;
    int w2=rect2.size.width;
    int h2=rect2.size.height;
    
	int x2=x1+w1, y2=y1+h1;	//Rect1: Punkt rechts unten
	int x4=x3+w2, y4=y3+h2;	//Rect2: Punkt rechts unten
	
    if (   x2 >= x3
        && x4 >= x1
        && y2 >= y3
        && y4 >= y1) {
        return true;
    }
    return false;
}

- (bool)checkColWithSprite:(Sprite *)sprite
{
    return [self checkColWithRect: [sprite getRect]];
}


@end
