//
//  GameView.h
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameManager;

@interface GameView : UIView
{
    GameManager *gameManager;
    
    EAGLContext *eaglContext;
    GLuint renderbuffer;
    GLuint framebuffer;
    GLuint depthbuffer;
    GLint viewportWidth;
    GLint viewportHeight;
}

- (void)setUpOpenGl;

@end
