//
//  Texture.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Texture.h"
#import <OpenGLES/ES1/gl.h>

@implementation Texture

- (void)dealloc
{
    NSLog(@"Delete texture, ID: %i", textureID);
    glDeleteTextures(1, &textureID);
    [super dealloc];
}

- (void) createTextureFromImage: (NSString *) imageName {
    UIImage *image = [UIImage imageNamed: imageName];
	
	int scaleFactor = 1;
	
	float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (iOSVersion >= 4.0) {
        if (image.scale >= 2) {
            scaleFactor = image.scale;
        }
    }
	
    if (image) {
        //Get image dimension
        width = image.size.width * scaleFactor;
        height = image.size.height * scaleFactor;
        
        if ((width & (width-1)) != 0 || (height & (height-1)) != 0 || width > 2048 || height > 2048) {
            NSLog(@"ERROR: %@ width und/oder height ist keine 2er Potenz oder > 2048!", imageName);
        }
        
        //create pixel data
        GLubyte *pixelData = [self generatePixelDataFromImage: image];
        
        //save generated texture to id
        [self generateTexture: pixelData];
        
        //cleanup
        int memory = width*height*4;
        
        NSLog(@"%@-Pic-Textur erzeugt, Size: %i KB, ID: %i", imageName, memory/1024, textureID);
        
        free(pixelData);
        
		width /= scaleFactor;
        height /= scaleFactor;
    }
    else
    {
        NSLog(@"ERROR: %@ nicht gefunden, Textur nicht erzeugt.", imageName);
    }
}

- (void) createTextureFromString: (NSString *) text
{
    //set texture dimension
    int len = text.length*20;
    
    if (len < 64) width = 64;
    else if (len < 128) width = 128;
    else if (len < 256) width = 256;
    else width = 512; //max width text
    
    height = 32;
    
    //create pixel data
    GLubyte *pixelData = [self generatePixelDataFromString: text];
    
    //save generated texture to id
    [self generateTexture: pixelData];
    
    //cleanup
    int memory = width*height*4;
    
    NSLog(@"%@-Text-Textur erzeugt, Size: %i KB, ID: %i", text, memory/1024, textureID);
    
    free(pixelData);
}

- (GLubyte *)generatePixelDataFromImage:(UIImage*)image
{
    GLubyte *pixelData = (GLubyte*) calloc(width*height*4, sizeof(GLubyte));    
    CGColorSpaceRef imageCS = CGImageGetColorSpace(image.CGImage);
    
    CGContextRef context = CGBitmapContextCreate( pixelData,
                                            width, height, 8, width*4,
                                            imageCS,
                                            kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage); //render image on context
    CGContextRelease(context);
    
    return pixelData;
}

- (GLubyte *)generatePixelDataFromString:(NSString*)text
{
    const char *cText = [text cStringUsingEncoding: NSASCIIStringEncoding];
    
    GLubyte *pixelData = (GLubyte *) calloc( width*height*4, sizeof(GLubyte) );
    CGColorSpaceRef rgbCS = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate( pixelData,
                                            width, height, 8, width*4,
                                            rgbCS,
                                            kCGImageAlphaPremultipliedLast);
    
    int size = 22; //font-size, smaller as height
    
    CGContextSetRGBFillColor(context, 0,1,0,1); //font-color
    CGContextSelectFont(context, "Verdana", size, kCGEncodingMacRoman);
    
    int ys = height-size; //swapped y-axis
    
    CGContextShowTextAtPoint(context, 0, ys, cText, strlen(cText)); //render image on context
    CGColorSpaceRelease(rgbCS);
    CGContextRelease(context);
    
    return pixelData;
}

- (void)generateTexture:(GLubyte *)pixelData
{
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelData);
    
    //active global texture states
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)drawAt:(CGPoint) point
{
    GLshort imageVertices[ ] = {
        0,      height, //links unten
        width,  height, //rechts unten
        0,      0,      //links oben
        width,  0       //rechts oben
    };
    
    GLshort textureCoords[ ] = {
        0, 1, //links unten
        1, 1, //rechts unten
        0, 0, //links oben
        1, 0  //rechts oben
    };
    
	point.x = (int)point.x;
    point.y = (int)point.y;
	
    glEnable(GL_TEXTURE_2D); //alle Flaechen werden nun texturiert
    
    glColor4f(1, 1, 1, 1);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glVertexPointer(2, GL_SHORT, 0, imageVertices);
    glTexCoordPointer(2, GL_SHORT, 0, textureCoords);
    
    glPushMatrix();
    glTranslatef(point.x, point.y, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();
    
    glDisable(GL_TEXTURE_2D);
}

- (void)drawFrame:(int)frameNr frameWidth:(int)fw angle:(int)degrees at:(CGPoint)p
{    
    //texture sprites    
    GLshort imageVertices[ ] = {
        0,   height, //links unten
        fw,  height, //rechts unten
        0,   0,      //links oben
        fw,  0       //rechts oben
    };
    
    GLfloat txW = 1.0/(width/fw);
    GLfloat x1  = frameNr*txW;
    GLfloat x2 =  x2  = x1 + txW; //oder: x2 = (frameNr+1)*txW;
    GLfloat textureCoords[ ] = {
        x1,  1, //links unten
        x2,  1, //rechts unten
        x1,  0, //links oben
        x2,  0  //rechts oben
    };
    
    glEnable(GL_TEXTURE_2D); //alle Flaechen werden nun texturiert
    
    glColor4f(1, 1, 1, 1);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glVertexPointer(2, GL_SHORT, 0, imageVertices);
    glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
    
    glPushMatrix();
    glTranslatef(p.x+fw/2, p.y+height/2, 0);
    glRotatef(degrees, 0, 0, 1); //angle = 0 = keine Rotation
    glTranslatef(0-fw/2, 0-height/2, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();
    
    glDisable(GL_TEXTURE_2D);
}

- (GLuint)getTextureID {
    return textureID;
}

- (int)getWidth {
    return width;
}

- (int)getHeight {
    return height;
}

@end
