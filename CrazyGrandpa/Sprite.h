//
//  Sprite.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture;

//Sprite-Typen
typedef enum {
    PLAYER,
    BULLET,
    GEAR,
    OCTO,
    MINE,
    FIGHTER,
    ANIMATION
} SpriteType;

@interface Sprite : NSObject
{
    Texture *texture;   //Textur-Filmstreifen
    CGPoint speed;      //Pixelgeschwindigkeit pro Frame in x-, y-Richtung
    CGPoint pos;        //aktuelle Position
    int cnt;            //interner Zaehler
    int frameNr;        //aktuelles Frame
    int frameCnt;       //Anzahl Frames im Filmstreifen
    int frameStep;      //Anzahl Frames pro Durchlauf
    int frameW;         //Breite eines Frames
    int frameH;         //Höhes eines Frames
    int angle;          //Winkel in Grad, um den das Sprite gedreht wird
    SpriteType type;           //Sprite-Typ
    int tolBB;          //Bounding Box - Toleranz
    int cycleCnt;       //Anzahl der Wiederholungen des Filmstreifens
    bool forceIdleness; //keine Animation, wenn Sprite stillsteht
    bool active;        //inaktive Sprites werden vom GameManager gelöscht
    bool autoDestroy;   //Außerhalb eines Toleranzbereiches wird active = false gesetzt
}

- (id)initWithImage:(NSString *)name frameCnt:(int)fcnt frameStep:(int)fstp speed:(CGPoint)sxy pos:(CGPoint)pxy;
- (void)additionalSetup;
- (void)draw;
- (void)drawFrame;
- (void)renderSprite;
- (int)updateFrame;
- (CGRect)getRect;
- (bool)checkColWithPoint:(CGPoint)p;
- (bool)checkColWithRect:(CGRect)rect;
- (bool)checkColWithSprite:(Sprite *)sprite;
- (void)hit;
- (float)getRad:(float)grad;
- (void)setType:(SpriteType)spriteType;
- (int)getType;
- (void)setSpeed:(CGPoint)sxy;
- (CGPoint)getSpeed;
- (CGPoint)getPos;
- (bool)isActive;

@end
