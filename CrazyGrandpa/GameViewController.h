//
//  GameViewController.h
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameView;

@interface GameViewController : UIViewController
{
    GameView *gameView;
    id timer;
}

- (void)startGameLoop;
- (void)stopGameLoop;
- (void)loop;

@end
