//
//  GameManager.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "GameManager.h"
#import "Texture.h"
#import <OpenGLES/ES1/gl.h>
#import "ParallaxLayer.h"
#import "Bullet.h"
#import "Octo.h"
#import "Gear.h"
#import "Player.h"
#import "Animation.h"
#import "Mine.h"
#import "Fighter.h"
#import "Terrain.h"

int W=480;
int H=320;

@implementation GameManager


#pragma mark - Memory Management

- (void)dealloc
{
    [sprites release];
    [newSprites release];
    [destroyableSprites release];
    [dictionary release];
    [super dealloc];
}


#pragma mark - Init Methods

+ (GameManager*)getInstance
{
    static GameManager* gameManager;
    
	if (!gameManager) {
        gameManager = [[GameManager alloc] init];
        NSLog(@"gameManager Singleton angelegt!");
		[gameManager preloader];
	}
    
    return gameManager;
}

- (void)preloader
{
    sprites = [[NSMutableArray alloc] initWithCapacity:20];
    newSprites = [[NSMutableArray alloc] initWithCapacity:20];
    destroyableSprites = [[NSMutableArray alloc] initWithCapacity:20];

    //Preload OGL-Textures
    [self getTexture: @"fighter.png" isImage: YES];
    [self getTexture: @"octo_8f.png" isImage: YES];
    [self getTexture: @"explosion_8f.png" isImage: YES];
    [self getTexture: @"player.png" isImage: YES];
    [self getTexture: @"mine.png" isImage: YES];
    [self getTexture: @"bullets.png" isImage: YES];
    [self getTexture: @"gear.png" isImage: YES];
        
    //Parallax-Layer
    back = [[ParallaxLayer alloc] initWithImage: @"testbg.png"];
    clouds = [[ParallaxLayer alloc] initWithImage: @"clouds.png"];
    
    [self setOpenGlProjection];
    state = LOAD_GAME;
}

- (void)loadGame
{
    [sprites removeAllObjects];
    [newSprites removeAllObjects];
    [destroyableSprites removeAllObjects];
    
    [self createSprite: PLAYER
                 speed: CGPointMake(0, 0)
                   pos: CGPointMake(0, 0)];
    
//    Terrain *terrain = [[[Terrain alloc] init] autorelease];
//    [terrain setType:TERRAIN];
//    [newSprites addObject:terrain];
}

- (id) createSprite: (SpriteType) type
              speed: (CGPoint) sxy
                pos: (CGPoint) pxy {
    if (type == PLAYER) {
        player = [[Player alloc] initWithImage: @"player.png"
                                    frameCnt: 1
                                   frameStep: 0
                                       speed: sxy
                                         pos: pxy];
        [player setType: PLAYER];
        [newSprites addObject: player];
        [player release];
        return player;
//    } else if (type == BULLET) {
//        Bullet *bullet = [[Bullet alloc] initWithImage: @"bullets.png"
//                                            frameCnt: 1
//                                           frameStep: 0
//                                               speed: sxy
//                                                 pos: pxy];
//        [bullet setType: BULLET];
//        [newSprites addObject: bullet];
//        [bullet release];
//        return bullet;
    } else if (type == GEAR) {
        Gear *gear = [[Gear alloc] initWithImage: @"gear.png"
                                      frameCnt: 1
                                     frameStep: 0
                                         speed: sxy
                                           pos: pxy];
        [gear setType: GEAR];
        [newSprites addObject: gear];
        [gear release];
        return gear;
//    } else if (type == OCTO) {
//        Octo *octo = [[Octo alloc] initWithImage: @"octo_8f.png"
//                                      frameCnt: 8
//                                     frameStep: 3
//                                         speed: sxy
//                                           pos: pxy];
//        [octo setType: OCTO];
//        [newSprites addObject: octo];
//        [octo release];
//        return octo;
    } else if (type == MINE) {
        Mine *mine = [[Mine alloc] initWithImage: @"mine.png"
                                      frameCnt: 1
                                     frameStep: 0
                                         speed: sxy
                                           pos: pxy];
        [mine setType: MINE];
        [newSprites addObject: mine];
        [mine release];
        return mine;
//    } else if (type == FIGHTER) {
//        Fighter *fighter = [[Fighter alloc] initWithImage: @"fighter.png"
//                                               frameCnt: 1
//                                              frameStep: 0
//                                                  speed: sxy
//                                                    pos: pxy];
//        [fighter setType: FIGHTER];
//        [newSprites addObject: fighter];
//        [fighter release];
//        return fighter;
    } else if (type == ANIMATION) {
        Animation *ani = [[Animation alloc] initWithImage: @"explosion_8f.png"
                                               frameCnt: 8
                                              frameStep: 3
                                                  speed: sxy
                                                    pos: pxy];
        [ani setType: ANIMATION];
        [newSprites addObject: ani];
        [ani release];
        return ani;
    } else {
        NSLog(@"ERROR: Unbekannter Sprite-Typ: %i", type);
        return nil;
    }
}

- (void) createExplosionFor: (Sprite *) sprite {
    CGPoint p = [Animation getOriginBasedOnCenterOf: [sprite getRect]
                                             andPic: @"explosion_8f.png"
                                       withFrameCnt: 8];
    [self createSprite: ANIMATION
                 speed: CGPointMake(0, 0)
                   pos: p];
}

#pragma mark - Game Handling Methods

- (void) touchBegan: (CGPoint) p {
    [self handleStates];
    if (state == PLAY_GAME && player) {
        //[player setTouch: p];
        [player setGlideFactor:4.5];
    }
}

- (void) touchMoved: (CGPoint) p {
    if (state == PLAY_GAME) {
        [self touchBegan: p];
    }
}

- (void) touchEnded {
    if (state == PLAY_GAME && player) {
        [player touchEnded];
    }
}

- (void) handleStates {
    if (state == START_GAME) {
        state = PLAY_GAME;
    }
    else if (state == GAME_OVER) {
        state = LOAD_GAME;
    }
}

- (void)drawStatesWithFrame:(CGRect)frame
{
    W = frame.size.width;
    H = frame.size.height;
    CGPoint o = [self getViewportOrigin];
    switch (state) {
        case LOAD_GAME:
            [self loadGame];
            state = START_GAME;
            break;
        case START_GAME:
            [self drawOpenGlString: @"Tap screen to start!" at: CGPointMake(o.x, o.y)];
            [self drawOpenGlString: @"How to control the ship:" at: CGPointMake(o.x, o.y + 50)];
            [self drawOpenGlString: @"Tap left - turn left." at: CGPointMake(o.x, o.y + 75)];
            [self drawOpenGlString: @"Tap right - turn right." at: CGPointMake(o.x, o.y + 100)];
            break;
        case PLAY_GAME:
            [self playGame];
            break;
        case GAME_OVER:
            [self playGame];
            [self drawOpenGlString: @"G A M E  O V E R" at: CGPointMake(o.x, o.y)];
            break;
        default: NSLog(@"ERROR: Unbekannter Spielzustand: %i", state);
            break;
    }
}

- (void)playGame
{
    timer++;
    //[self scrollWorld];
    
    //Parallax-Ebenen
    [back drawWithFactor:2 realtiveTo:[player getParallaxPosition] atOrigin:[self getViewportOrigin]];
    //[clouds drawWithFactor:1 realtiveTo:[player getParallaxPosition] atOrigin:[self getViewportOrigin]];
    
    [self generateNewObjects];
    [self manageSprites];
    [self renderSprites];
}

- (void)scrollWorld
{
    CGPoint p = [player getPos];
    CGRect r = [player getRect];
    xt = W/2 - r.size.width/2 - p.x;
    yt = H/2 - r.size.height/2 - p.y;
    glLoadIdentity();
    glTranslatef(xt, yt, 0);
}

- (CGPoint)getViewportOrigin
{
    return CGPointMake(-xt, -yt);
}

- (void)generateNewObjects
{
    //Octos
    if (timer % 12 == 0) {
        int sx = [self getRndBetween: -3 and: 3];
        int sy = [self getRndBetween: -7 and: -1];
        [self generateObject: OCTO speedX: sx speedY: sy];
    }
    
    //Mines
    if (timer % 5 == 0) {
        [self generateObject: MINE speedX: 0 speedY: 0];
    }
    
    //Fighter
    if (timer % 18 == 0) {
        [self generateObject: FIGHTER speedX: 7 speedY: 7];
    }
    
    //Fighter im Galaga-Style erzeugen
    static int fighterCnt = 15; //Anzahl Fighter pro Reihe
    static CGPoint startP;
    if (fighterCnt == 15 && timer % 20 == 0) { //Neue Reihe erzeugen?
        fighterCnt = 0;
        startP = [self getRandomStartPosition];
    }
    if (timer % 9 == 0 && fighterCnt < 15) { //timer bestimmt die Abstaende
        fighterCnt++;
        [self createSprite: FIGHTER
                     speed: CGPointMake(7, 7)
                       pos: startP];
    }
}

- (void)generateObject:(SpriteType)type speedX:(int)sx speedY:(int)sy
{
    CGPoint startPos = [self getRandomStartPosition];
    
    [self createSprite: type
                 speed: CGPointMake(sx, sy)
                   pos: startPos];
}

- (CGPoint)getRandomStartPosition
{
    int px = -W, py = -H; //Positionierung ausserhab des Screens
    int f = 128; //Pufferzone (frameW bzw. frameH)
    int flag = [self getRndBetween: 0 and: 3];
    
    switch (flag) {
        case 0: //Top
            px    = [self getRndBetween: -f-W and: f+W*2];
            py    = [self getRndBetween: -f-H and: -f];
            break;
        case 1: //Left
            px    = [self getRndBetween: -f-W and: -f];
            py    = [self getRndBetween: -f-H and: f+H*2];
            break;
        case 2: //Right
            px    = [self getRndBetween: f+W and: f+W*2];
            py    = [self getRndBetween: -f-H and: f+H*2];
            break;
        case 3: //Bottom
            px    = [self getRndBetween: -f-W and: f+W*2];
            py    = [self getRndBetween: f+H and: f+H*2];
            break;
    }
    
    CGPoint o = [self getViewportOrigin];
    return CGPointMake(o.x + px, o.y + py);
}

- (void) checkSprite:(Sprite *)sprite
{
    if ([sprite getType] == PLAYER || [sprite getType] == BULLET) {
        for (Sprite *sprite2test in sprites) {
            if ([sprite2test getType] == OCTO
                || [sprite2test getType] == FIGHTER) {
                if ([sprite checkColWithSprite: sprite2test] && state != GAME_OVER) {
                    [sprite hit];
                    [sprite2test hit];
                }
            }
            if ([sprite getType] == BULLET && [sprite2test getType] == MINE) {
                if ([sprite checkColWithSprite: sprite2test]) {
                    //Mines sind unzerstörbar
                    [sprite hit];
                    [[GameManager getInstance] createExplosionFor: sprite];
                }
            }
            if ([sprite getType] == PLAYER && [sprite2test getType] == MINE) {
                if ([sprite checkColWithSprite: sprite2test]) {
                    [sprite hit];
                }
            }
        }
    }
}

#pragma mark - OpenGL Methods

- (void)setOpenGlProjection
{
    //Set View
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0, W, H, 0, 0, 1); //2D-Perspektive
    //left - right - bottom - top
    //Origin = Oben links
    //Positive x-Achse zeigt nach rechts
    //Positive y-Achse zeigt nach unten
    
    //Enable Modelview: Auf das Rendern von Vertex-Arrays umschalten
    glMatrixMode(GL_MODELVIEW);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisable(GL_DEPTH_TEST); //2D only
}

- (void)drawOpenGlLineFrom:(CGPoint)p1 to:(CGPoint)p2
{
    GLshort vertices[ ] = {
        p1.x, p1.y,
        p2.x, p2.y
    };
    
    glVertexPointer(2, GL_SHORT, 0, vertices);
    glColor4f(1, 0, 0, 1);
    glDrawArrays(GL_LINES, 0, 2);
}

- (void)drawOpenGlRect:(CGRect)rect
{
    GLshort vertices[ ] = {
        0,                  rect.size.height, //links unten (y-Achse zeigt nach unten)
        rect.size.width,    rect.size.height, //rechts unten
        0,                  0, //links oben
        rect.size.width,    0  //rechts oben
    };
    
    glVertexPointer(2, GL_SHORT, 0, vertices);
    glColor4f(0, 0, 0, 1);
    
    glPushMatrix();
    glTranslatef(rect.origin.x, rect.origin.y, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();
}

- (void)drawOpenGlImg:(NSString*) picName at:(CGPoint) p
{
    Texture *texture = [self getTexture: picName isImage: YES];
    if (texture) {
        [texture drawAt: p];
    }
}

- (CGSize)getOpenGlImgDimension:(NSString*)picName
{
    Texture *texture = [self getTexture: picName isImage: YES];
    if (texture) {
        return CGSizeMake([texture getWidth], [texture getHeight]);
    }
    return CGSizeMake(0, 0);
}

- (void)drawOpenGlString:(NSString*)text at:(CGPoint) p
{
    Texture *texture = [self getTexture: text isImage: NO];
    if (texture) {
        [texture drawAt: p];
    }
}

- (Texture*)getTexture:(NSString*)name isImage:(bool)imgFlag
{
	Texture *texture = [[self getDictionary] objectForKey: name];
	if (!texture) {
		texture = [[Texture alloc] init];
        if (imgFlag) {
            [texture createTextureFromImage: name];
        } else {
            [texture createTextureFromString: name];
        }
        [[self getDictionary] setObject: texture forKey: name];
        
        NSLog(@"%@ als Tex im Dictionary abgelegt.", name);
        
        [texture release];
	}
	return texture;
}


#pragma mark - Helpers

- (void) setState: (int) stt
{
    state = stt;
}

- (void)manageSprites
{
    //NSLog(@"Sprites: %i destroyable: %i new: %i", [sprites count], [destroyableSprites count], [newSprites count]);
    
    //Cleanup
    for(Sprite *destroyableSprite in destroyableSprites) {
        for(Sprite *sprite in sprites) {
            if(destroyableSprite == sprite) {
                [sprites removeObject: sprite];
                break;
            }
        }
    }
    
    //Neue Sprites hinzufügen
    for (Sprite *newSprite in newSprites){
        [sprites addObject: newSprite];
    }
    
    [destroyableSprites removeAllObjects];
    [newSprites removeAllObjects];
}

- (void)renderSprites
{
    for (Sprite *sprite in sprites) {
        if ([sprite isActive]) {
            [self checkSprite: sprite];
            if ([sprite getType] != PLAYER) {
                [sprite draw];
            }
        } else {
            [destroyableSprites addObject: sprite];
        }
    }
    //Der Player soll nicht von anderen Sprites verdeckt werden
    //und wird deshalb als letztes Sprite gerendert.
    [player draw];
}


- (NSMutableDictionary *) getDictionary
{
	if (!dictionary) { //Hashtable
		dictionary = [[NSMutableDictionary alloc] init];
		NSLog(@"Dictionary angelegt!");
	}
	return dictionary;
}

- (void) removeFromDictionary: (NSString*) name
{
    [[self getDictionary] removeObjectForKey: name];
}

- (int) getRndBetween: (int) bottom and: (int) top
{
	int rnd = bottom + (arc4random() % (top+1-bottom));
	return rnd;
}

@end
