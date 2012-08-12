//
//  GameViewController.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
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
