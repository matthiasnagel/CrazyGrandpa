//
//  GameManager.h
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int W;
extern int H;

typedef enum {
    LOAD_GAME,
    PLAY_GAME
} States;

@interface GameManager : NSObject
{
    States state;
    NSMutableDictionary *dictionary;
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

//Helper Methods
- (void)setState: (int) stt;
- (int)getRndBetween: (int) bottom and: (int) top;

//OpenGL
- (void)setOpenGlProjection;
- (void)drawOpenGlTriangle;
- (void)drawOpenGlLineFrom:(CGPoint)p1 to:(CGPoint)p2;
- (void)drawOpenGlRect:(CGRect)rect;

@end
