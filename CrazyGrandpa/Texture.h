//
//  Texture.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Texture : NSObject
{
    GLuint textureID;
    int width;
    int height;
}

//Initialisierer
- (void)createTextureFromImage:(NSString*)imageName;
- (void)createTextureFromString:(NSString*)text;

//Texturerzeugung - Helper
- (GLubyte*)generatePixelDataFromImage:(UIImage*)image;
- (GLubyte*)generatePixelDataFromString: (NSString*)text;
- (void)generateTexture:(GLubyte *)pixelData;

//Textur rendern
- (void)drawAt:(CGPoint)point;
- (void)drawFrame:(int)frameNr frameWidth:(int)fw angle:(int)degrees at:(CGPoint)p;

//Getter
- (GLuint)getTextureID;
- (int)getWidth;
- (int)getHeight;


@end
