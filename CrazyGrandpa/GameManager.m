//
//  GameManager.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "GameManager.h"
#import "Texture.h"
#import <OpenGLES/ES1/gl.h>

int W=480;
int H=320;

@implementation GameManager


#pragma mark - Memory Management

- (void)dealloc
{
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
    [self setOpenGlProjection];
    state = LOAD_GAME;
}

- (void)loadGame
{
}

#pragma mark - Game Handling Methods

- (void)touchBegan: (CGPoint) p {
    NSLog(@"Touch: %f %f", p.x, p.y);
}

- (void)touchMoved: (CGPoint) p {
    [self touchBegan: p];
}

- (void)touchEnded {
}

- (void)drawStatesWithFrame:(CGRect)frame
{
    W = frame.size.width;
    H = frame.size.height;
    switch (state) {
        case LOAD_GAME:
            [self loadGame];
            state = PLAY_GAME;
            break;
        case PLAY_GAME:
            [self playGame];
            break;
        default: NSLog(@"ERROR: Unbekannter Spielzustand: %i", state);
            break;
    }
}

- (void)playGame
{
    timer++;
    
    CGSize textureSize = [self getOpenGlImgDimension: @"boy-sprite.png"];
    int w = textureSize.width;
    int h = textureSize.height;
    
    static int yStep = 0;
    yStep -= 1;
    
    for (int x = 0; x < W; x += w) {
        for (int y = 0; y < H; y += h) {
            [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(x, y + yStep)];
        }
    }
    
//    for (int i = 0; i < 99999; i++)
//    {
//        int x = [self getRndBetween: 0 and: W];
//        int y = [self getRndBetween: 0 and: H];
//        [self drawOpenGlRect:CGRectMake(x, y, 1, 1)];
//    }
//    
//    [self drawOpenGlLineFrom: CGPointMake(0, H/2) to: CGPointMake(W, H/2)];
    //[self drawOpenGlTriangle]; //OpenGL ES - Hello World
    //[self drawOpenGlLineFrom:CGPointMake(0, 0) to:CGPointMake(480, 320)];
    [self drawOpenGlString: @"OpenGL ES rules!" at: CGPointMake(60, 100)];
    
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

- (void)drawOpenGlTriangle
{
    GLshort vertices[ ] = {
        0,   250, //links unten (y-Achse zeigt nach unten)
        250, 250, //rechts unten
        0,   0,   //links oben
    };
    
    glColor4f(0, 0, 0, 1);
    glVertexPointer(2, GL_SHORT, 0, vertices); //"2" = Anzahl Elemente pro Eckpunkt, entweder 2, 3, oder 4!
    glDrawArrays(GL_TRIANGLES, 0, 3); //"3" = Anzahl der Eckpunkte
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

- (void) drawOpenGlImg: (NSString*) picName at: (CGPoint) p {
    Texture *texture = [self getTexture: picName isImage: YES];
    if (texture) {
        [texture drawAt: p];
    }
}

- (CGSize) getOpenGlImgDimension: (NSString*) picName {
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
