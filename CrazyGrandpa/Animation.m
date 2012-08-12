//
//  Animation.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Animation.h"
#import "Texture.h"
#import "GameManager.h"

@implementation Animation

- (void)drawFrame
{
    frameNr = [self updateFrame];
    if (cycleCnt == 1) {
        active = false;
    }
    if (active) {
        [self renderSprite];
    }
}

+ (CGPoint)getOriginBasedOnCenterOf:(CGRect)rectMaster andPic:(NSString *)picName withFrameCnt:(int)fcnt
{
    Texture *slave = [[GameManager getInstance] getTexture:picName isImage: YES];
    
    //Mittelpunkt Master
    int xmm = rectMaster.origin.x + rectMaster.size.width/2;
    int ymm = rectMaster.origin.y + rectMaster.size.height/2;
    
    //Origin der Animation
    int xs = xmm-[slave getWidth]/2/fcnt;
    int ys = ymm-[slave getHeight]/2;
    
    return CGPointMake(xs, ys);
}


@end
