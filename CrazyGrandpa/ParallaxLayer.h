//
//  ParallaxLayer.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture;

@interface ParallaxLayer : NSObject
{
    Texture *texture;
    
    int layerWidth;
    int layerHeight;
    
    float refX;
    float refY;
    
    float oldX;
    float oldY;
}

- (id)initWithImage:(NSString*)imageName;
- (void)drawWithFactor:(float)factor realtiveTo:(CGPoint)position atOrigin:(CGPoint)origin;

@end
