//
//  Fighter.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 12.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "Sprite.h"

@interface Fighter : Sprite
{
    int angleOffset;
    int pathCnt;
    int speedScalarX;
    int speedScalarY;
}

@end
