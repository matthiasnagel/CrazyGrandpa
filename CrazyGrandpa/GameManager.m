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
#import "ParallaxLayer.h"

int W=480;
int H=320;

@implementation GameManager


#pragma mark - Memory Management

- (void)dealloc
{
    [playerTexture release];
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
    playerTexture = [self getTexture:@"boy-sprite.png" isImage:YES];
    int playerW = [playerTexture getWidth];
    int playerH = [playerTexture getHeight];
    
    //Spieler zentrieren
    playerX = W/2 - playerW/2;
    playerY = H/2 - playerH/2;
    
    //Parallax-Layer
    back = [[ParallaxLayer alloc] initWithImage: @"testbg.png"];
    clouds = [[ParallaxLayer alloc] initWithImage: @"clouds.png"];
    
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
    
//    CGSize textureSize = [self getOpenGlImgDimension: @"boy-sprite.png"];
//    int w = textureSize.width;
//    int h = textureSize.height;
//    
//    static int yStep = 0;
//    yStep -= 1;
//    
//    for (int x = 0; x < W; x += w) {
//        for (int y = 0; y < H; y += h) {
//            [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(x, y + yStep)];
//        }
//    }
    
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
//    [self drawOpenGlString: @"OpenGL ES rules!" at: CGPointMake(60, 100)];
//    [self translate];
//    [self rotate];
//    [self scale];
//    [self allTogether];
//    static int frameNr = 0;
//    static int frameW = 64;
//    static int angle = 0;
//    static int x = 0;
//    static int y = 0;
//    
//    if (timer % 3 == 0) {
//        frameNr ++;
//        if (frameNr > 7) {
//            frameNr = 0;
//        }
//    }
//    
//    angle++;
//    x++;
//    y++;
//    
//    [playerTexture drawFrame: frameNr
//                frameWidth: frameW
//                     angle: angle
//                        at: CGPointMake(x, y)];
    [self scrollWorld];
    
    //Player nach oben bewegen
    playerX += 1;
    playerY -= 0;
    
    //Parallax-Ebenen rendern
    [back drawWithFactor:2 realtiveTo:CGPointMake(playerX, playerY) atOrigin:[self getViewportOrigin]];
    
    [clouds drawWithFactor:1 realtiveTo:CGPointMake(playerX, playerY) atOrigin:[self getViewportOrigin]];
    
    //Player rendern
    [playerTexture drawAt: CGPointMake(playerX, playerY)];
}

- (void)scrollWorld
{
    int playerW = [playerTexture getWidth];
    int playerH = [playerTexture getHeight];
    xt = W/2 - playerW/2 - playerX;
    yt = H/2 - playerH/2 - playerY;
    glLoadIdentity();
    glTranslatef(xt, yt, 0);
}

- (CGPoint)getViewportOrigin
{
    return CGPointMake(-xt, -yt);
}

- (void)translate
{
    static int x = 160-32;
    static int y = 320-32;
    
    y -= 1;
    
    glPushMatrix();
    glTranslatef(x, y, 0);
    [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(0, 0)]; //Animation erfolgt ueber die Matrix
    glPopMatrix();
}

- (void)rotate
{
    static int a = 0;
    a -= 10;
    
    glPushMatrix();
    glTranslatef(160, 240, 0); //Mittig platzieren
    glRotatef(a, 0, 0, 1);
    [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(0, 0)]; //Animation erfolgt ueber die Matrix
    glPopMatrix();
}

- (void) scale {
    static float s = 1;
    static int sf = 1; //Vorzeichen
    
    s -= 0.01 * sf;
    if (s < 0 || s > 1) {
        sf *= -1;
    }
    
    glPushMatrix();
    glTranslatef(160, 240, 0);
    glScalef(s, s, 1);
    [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(0, 0)]; //Animation erfolgt ueber die Matrix
    glPopMatrix();
}

- (void) allTogether {
    static int x = 160;
    static int y = 320;
    static int a = 0;
    static float s = 1;
    static int sf = 1; //Vorzeichen
    
    y -= 1;
    a -= 10;
    
    s -= 0.01 * sf;
    if (s < 0 || s > 1) {
        sf *= -1;
    }
    
    glPushMatrix();
    glTranslatef(x, y, 0);
    glRotatef(a, 0, 0, 1);
    glScalef(s, s, 1);
    [self drawOpenGlImg: @"boy-sprite.png" at: CGPointMake(0, 0)]; //Animation erfolgt ueber die Matrix
    glPopMatrix();
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
