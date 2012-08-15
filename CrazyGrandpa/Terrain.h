//
//  Terrain.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Sprite.h"

#define kMaxHillKeyPoints 101
#define kMaxHillVertices 1000
#define kMaxBorderVertices 5000
#define kHillSegmentWidth 15

typedef struct _ccVertex2F
{
	GLfloat x;
	GLfloat y;
} ccVertex2F;

@interface Terrain : Sprite
{
	ccVertex2F hillKeyPoints[kMaxHillKeyPoints];
	int nHillKeyPoints;
	int fromKeyPointI;
	int toKeyPointI;
	ccVertex2F hillVertices[kMaxHillVertices];
	ccVertex2F hillTexCoords[kMaxHillVertices];
	int nHillVertices;
	ccVertex2F borderVertices[kMaxBorderVertices];
	int nBorderVertices;
	float _offsetX;
	int screenW;
	int screenH;
	int textureSize;
}

- (void)setOffsetX:(float)offsetX;

@end
