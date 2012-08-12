//
//  GameManager.h
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture;
@class ParallaxLayer;

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
    NSMutableDictionary *dictionary;
    
    Texture *playerTexture;
    int playerX;
    int playerY;
    
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

//Game Handler
- (void)touchBegan:(CGPoint) p;
- (void)touchMoved:(CGPoint) p;
- (void)touchEnded;
- (void)drawStatesWithFrame: (CGRect) frame;
- (void)playGame;
- (void) translate;
- (void) rotate;
- (void) scale;
- (void) allTogether;

//Helper Methods
- (void)setState: (int) stt;
- (int)getRndBetween: (int) bottom and: (int) top;
- (NSMutableDictionary*) getDictionary;
- (void) removeFromDictionary: (NSString*) name;

//OpenGL
- (void)setOpenGlProjection;
- (void)drawOpenGlTriangle;
- (void)drawOpenGlLineFrom:(CGPoint)p1 to:(CGPoint)p2;
- (void)drawOpenGlRect:(CGRect)rect;
- (void)drawOpenGlImg: (NSString*) picName at: (CGPoint) p;
- (CGSize)getOpenGlImgDimension: (NSString*) picName;
- (void)drawOpenGlString:(NSString*)text at:(CGPoint) p;
- (Texture*)getTexture:(NSString*)name isImage:(bool)imgFlag;

@end
