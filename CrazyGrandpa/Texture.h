//
//  Texture.h
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
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
- (GLubyte *)generatePixelDataFromImage:(UIImage*)image;
- (GLubyte *)generatePixelDataFromString: (NSString*)text;
- (void)generateTexture:(GLubyte *)pixelData;

//Textur rendern
- (void)drawAt:(CGPoint)point;

//Getter
- (GLuint)getTextureID;
- (int)getWidth;
- (int)getHeight;


@end
