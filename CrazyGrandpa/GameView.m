//
//  GameView.m
//  CrazyGrandpa
//
//  Created by Konstantin Ehlers & Matthias Nagel on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "GameView.h"
#import "GameManager.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@implementation GameView

- (void)dealloc
{
    [gameManager release];
    
    if (eaglContext) {
        glDeleteRenderbuffersOES(1, &depthbuffer);
        glDeleteFramebuffersOES(1, &framebuffer);
        glDeleteRenderbuffersOES(1, &renderbuffer);
        [eaglContext release];
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class) layerClass {
    return [CAEAGLLayer class];
}

- (void)setUpOpenGl
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.layer;
    eaglLayer.opaque = YES;
    
    eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
    
    if (!eaglContext || ![EAGLContext setCurrentContext: eaglContext]) {
        [self release];
    } else {
        //Renderbuffer
        glGenRenderbuffersOES(1, &renderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
        
        //Framebuffer
        glGenFramebuffersOES(1, &framebuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderbuffer);
        
        //Graphic context
        [eaglContext renderbufferStorage: GL_RENDERBUFFER_OES fromDrawable: eaglLayer];
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &viewportWidth);
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &viewportHeight);
        
        //Depthbuffer (3D only)
        glGenRenderbuffersOES(1, &depthbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, viewportWidth, viewportHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer); //rebind
        
        if (!gameManager) {
            gameManager = [GameManager getInstance];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    glViewport(0, 0, viewportWidth, viewportHeight);
    glClearColor(1.0,1.0,1.0,1.0);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    [gameManager drawStatesWithFrame: rect];    
    [eaglContext presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    CGPoint p = [[touches anyObject] locationInView: self];
    [gameManager touchBegan: p];
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
    CGPoint p = [[touches anyObject] locationInView: self];
    [gameManager touchMoved: p];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    [gameManager touchEnded];
}


- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event {
    [gameManager touchEnded];
}

@end
