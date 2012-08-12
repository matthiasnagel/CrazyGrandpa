//
//  GameManager.h
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@class Player;
@class ParallaxLayer;
@class Texture;

extern int W;
extern int H;

typedef enum {
    LOAD_GAME,
    START_GAME,
    PLAY_GAME,
    GAME_OVER
} States;

@interface GameManager : NSObject
{
    States state;
    Player *player;
    
    NSMutableArray *sprites; //Aktive Sprites, die gerendert werden sollen
    NSMutableArray *newSprites; //Neue Sprites, die der sprites-Liste hinzugefügt werden sollen
    NSMutableArray *destroyableSprites; //Inaktive Sprites, die gelöscht werden sollen
    NSMutableDictionary *dictionary;
        
    //Parallax-Layer
    ParallaxLayer *back;
    ParallaxLayer *clouds;
    
    //Scroll-Translation
    float xt;
    float yt;

    //Current Frame
    int timer;
}

//Init Methods
+ (GameManager *)getInstance;
- (void)preloader;
- (void)loadGame;
- (id)createSprite: (SpriteType)type speed:(CGPoint)sxy pos:(CGPoint)pxy;
- (void)createExplosionFor: (Sprite*)sprite;

//Game Handler
- (void)touchBegan:(CGPoint) p;
- (void)touchMoved:(CGPoint) p;
- (void)touchEnded;
- (void)drawStatesWithFrame: (CGRect) frame;
- (void)playGame;
- (void)scrollWorld;
- (CGPoint)getViewportOrigin;
- (void)generateNewObjects;
- (void)generateObject:(SpriteType)type speedx:(int)sx speedy:(int)sy;
- (CGPoint)getRandomStartPosition;
- (void)checkSprite:(Sprite*)sprite;

//Helper Methods
- (void)setState: (int) stt;
- (void)manageSprites;
- (void)renderSprites;
- (int)getRndBetween:(int)bottom and:(int)top;
- (NSMutableDictionary*) getDictionary;
- (void) removeFromDictionary: (NSString*) name;

//OpenGL
- (void)setOpenGlProjection;
- (void)drawOpenGlLineFrom:(CGPoint)p1 to:(CGPoint)p2;
- (void)drawOpenGlRect:(CGRect)rect;
- (void)drawOpenGlImg: (NSString*) picName at: (CGPoint) p;
- (CGSize)getOpenGlImgDimension: (NSString*) picName;
- (void)drawOpenGlString:(NSString*)text at:(CGPoint) p;
- (Texture*)getTexture:(NSString*)name isImage:(bool)imgFlag;

@end
