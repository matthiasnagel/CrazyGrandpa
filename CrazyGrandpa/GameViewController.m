//
//  GameViewController.m
//  CrazyGrandpa
//
//  Created by Kon Ehlers on 11.08.12.
//  Copyright (c) 2012 KoMa Games. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void) dealloc
{
    [self stopGameLoop];
    [timer release];
    [gameView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    gameView = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    gameView.backgroundColor = [UIColor blackColor];
    [gameView setUpOpenGl];
    self.view = gameView;
}

- (void)startGameLoop
{
    NSString *deviceOS = [[UIDevice currentDevice] systemVersion];
    bool forceTimerVariant = YES;
    
    if (forceTimerVariant || [deviceOS compare: @"3.1" options: NSNumericSearch] == NSOrderedAscending) {
        //33 frames per second -> timestep between the frames = 1/33
        NSTimeInterval fpsDelta = 0.0303;
        timer = [NSTimer scheduledTimerWithTimeInterval: fpsDelta
                                                 target: self
                                               selector: @selector(loop)
                                               userInfo: nil
                                                repeats: YES];
        
    }
    else {
        int frameLink = 2;
        timer = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(loop)];
        [timer setFrameInterval: frameLink];
        [timer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
    }
    
    NSLog(@"Game Loop timer instance: %@", timer);
}

- (void)stopGameLoop
{
    [timer invalidate];
    timer = nil;
}

- (void)loop
{
	[gameView drawRect:CGRectMake(0, 0, 480, 320)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
