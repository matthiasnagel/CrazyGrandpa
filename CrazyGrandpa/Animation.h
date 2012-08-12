//
//  Animation.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Sprite.h"

@interface Animation : Sprite

+ (CGPoint)getOriginBasedOnCenterOf:(CGRect)rectMaster
                             andPic:(NSString *)picName
                       withFrameCnt:(int)fcnt;

@end
