//
//  Terrain.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Terrain.h"
#import <OpenGLES/ES1/gl.h>
#import "GameManager.h"
#import "Texture.h"

@implementation Terrain

- (id)init
{
	if ((self = [super init])) {
		
		//screenW = 480.0;
		//screenH = 320.0;
		screenW = 960;
        screenH = 640;
        
        textureSize = 512;
        
		[self generateHillKeyPoints];
		[self generateBorderVertices];
        
        tex = [[GameManager getInstance] getTexture:@"pattern1.png" isImage: YES];
        
		self.offsetX = 0;
	}
	return self;
}

- (void) generateHillKeyPoints
{
	nHillKeyPoints = 0;
	
	float x, y, dx, dy, ny;
	
	x = -screenW/4;
	y = screenH*1/4;
	hillKeyPoints[nHillKeyPoints++] = (ccVertex2F){x, y};
    
	// starting point
	x = 0;
	y = screenH/2;
	hillKeyPoints[nHillKeyPoints++] = (ccVertex2F){x, y};
	
	int minDX = 360, rangeDX = 80;
	int minDY = 80,  rangeDY = 70;
	float sign = -1; // +1 - going up, -1 - going  down
	float maxHeight = 200;
	float minHeight = 20;
	while (nHillKeyPoints < kMaxHillKeyPoints-1) {
		dx = arc4random()%rangeDX+minDX;
		x += dx;
		dy = arc4random()%rangeDY+minDY;
		ny = y + dy*sign;
		if(ny > maxHeight) ny = maxHeight;
		if(ny < minHeight) ny = minHeight;
		y = ny;
		sign *= -1;
		hillKeyPoints[nHillKeyPoints++] = (ccVertex2F){x, screenH-y};
        
	}
    
	// cliff
	x += minDX+rangeDX;
	y = screenH;
	hillKeyPoints[nHillKeyPoints++] = (ccVertex2F){x, y};
    
	// adjust vertices for retina
	for (int i=0; i<nHillKeyPoints; i++) {
		hillKeyPoints[i].x *= 1.0;
		hillKeyPoints[i].y *= 1.0;
        
//        NSLog(@"");
	}
	
	fromKeyPointI = 0;
	toKeyPointI = 0;
}

- (void) generateBorderVertices
{    
	nBorderVertices = 0;
	ccVertex2F p0, p1, pt0, pt1;
	p0 = hillKeyPoints[0];
	for (int i=1; i<nHillKeyPoints; i++) {
		p1 = hillKeyPoints[i];
		
		int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
		float dx = (p1.x - p0.x) / hSegments;
		float da = M_PI / hSegments;
		float ymid = (p0.y + p1.y) / 2;
		float ampl = (p0.y - p1.y) / 2;
		pt0 = p0;
		borderVertices[nBorderVertices++] = pt0;
		for (int j=1; j<hSegments+1; j++) {
			pt1.x = p0.x + j*dx;
			pt1.y = ymid + ampl * cosf(da*j);
			borderVertices[nBorderVertices++] = pt1;
			pt0 = pt1;
		}
		
		p0 = p1;
	}
}

- (void) resetHillVertices
{
	static int prevFromKeyPointI = -1;
	static int prevToKeyPointI = -1;
	
	// key points interval for drawing
	
	float leftSideX = _offsetX-screenW/8/1.0;
	float rightSideX = _offsetX+screenW*7/8/1.0;
	
	// adjust position for retina
	leftSideX *= 1.0;
	rightSideX *= 1.0;
	
	while (hillKeyPoints[fromKeyPointI+1].x < leftSideX) {
		fromKeyPointI++;
		if (fromKeyPointI > nHillKeyPoints-1) {
			fromKeyPointI = nHillKeyPoints-1;
			break;
		}
	}
	while (hillKeyPoints[toKeyPointI].x < rightSideX) {
		toKeyPointI++;
		if (toKeyPointI > nHillKeyPoints-1) {
			toKeyPointI = nHillKeyPoints-1;
			break;
		}
	}
	
	if (prevFromKeyPointI != fromKeyPointI || prevToKeyPointI != toKeyPointI) {
		
        //		CCLOG(@"building hillVertices array for the visible area");
        
        //		CCLOG(@"leftSideX = %f", leftSideX);
        //		CCLOG(@"rightSideX = %f", rightSideX);
		
        //		CCLOG(@"fromKeyPointI = %d (x = %f)",fromKeyPointI,hillKeyPoints[fromKeyPointI].x);
        //		CCLOG(@"toKeyPointI = %d (x = %f)",toKeyPointI,hillKeyPoints[toKeyPointI].x);
		
		// vertices for visible area
		nHillVertices = 0;
		ccVertex2F p0, p1, pt0, pt1;
		p0 = hillKeyPoints[fromKeyPointI];
		for (int i=fromKeyPointI+1; i<toKeyPointI+1; i++) {
			p1 = hillKeyPoints[i];
			
			// triangle strip between p0 and p1
			int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
			int vSegments = 1;
			float dx = (p1.x - p0.x) / hSegments;
			float da = M_PI / hSegments;
			float ymid = (p0.y + p1.y) / 2;
			float ampl = (p0.y - p1.y) / 2;
			pt0 = p0;
			for (int j=1; j<hSegments+1; j++) {
				pt1.x = p0.x + j*dx;
				pt1.y = ymid + ampl * cosf(da*j);
				for (int k=0; k<vSegments+1; k++) {
					hillVertices[nHillVertices] = (ccVertex2F){pt0.x, pt0.y+(float)textureSize/vSegments*k};
//                    NSLog(@"x: %.2f y: %.2f hillvertices: %d",hillVertices[nHillVertices].x,hillVertices[nHillVertices].y,nHillVertices);
					hillTexCoords[nHillVertices++] = (ccVertex2F){pt0.x/(float)textureSize, (float)(k)/vSegments};
                    
					hillVertices[nHillVertices] = (ccVertex2F){pt1.x, pt1.y+(float)textureSize/vSegments*k};
//                    NSLog(@"x: %.2f y: %.2f hillvertices: %d",hillVertices[nHillVertices].x,hillVertices[nHillVertices].y,nHillVertices);
					hillTexCoords[nHillVertices++] = (ccVertex2F){pt1.x/(float)textureSize, (float)(k)/vSegments};
				}
				pt0 = pt1;
			}
			
			p0 = p1;
		}
		
        //		CCLOG(@"nHillVertices = %d", nHillVertices);
		
		prevFromKeyPointI = fromKeyPointI;
		prevToKeyPointI = toKeyPointI;
	}
}


- (void)draw
{
    glEnable(GL_TEXTURE_2D); //alle Flaechen werden nun texturiert
    
    glColor4f(1, 1, 1, 1);
    glBindTexture(GL_TEXTURE_2D, [tex getTextureID]);
    glVertexPointer(2, GL_FLOAT, 0, hillVertices);
    glTexCoordPointer(2, GL_SHORT, 0, hillTexCoords);
    
    glPushMatrix();
    glTranslatef(pos.x, pos.y, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nHillVertices);
    glPopMatrix();
    
    glDisable(GL_TEXTURE_2D);
}

- (void)drawFrame
{

}

- (void)setOffsetX:(float)offsetX
{
	static BOOL firstTime = YES;
	if (_offsetX != offsetX || firstTime) {
		firstTime = NO;
		_offsetX = offsetX;
		pos = CGPointMake(screenW/8-_offsetX*1.0, 0);
		[self resetHillVertices];
        [self draw];
	}
}

- (void) reset
{	
	fromKeyPointI = 0;
	toKeyPointI = 0;
}


@end
