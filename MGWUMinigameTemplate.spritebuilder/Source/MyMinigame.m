//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"



@implementation MyMinigame


CCNode *_contentNode;
CCPhysicsNode *_physicsNode;
CCNode *_dbTarget;
CCNode *_dart;
CCLabelTTF *_timeLabel;


int score = 0;

int minY = 40;
int minX = 40;

int maxY = 280;
int maxX = 530;

int rangeY = 280-40;
int rangeX = 530-40;

int randomX;
int randomY;

int numSeconds=0;


CGPoint touchLocation;

bool targetOn = false;

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"These are the game instructions :D";
        
        targetOn = false;
        
        
        [[CCDirector sharedDirector] setAnimationInterval:1.0/30];
        
        
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    
    // We're calling a public method of the character that tells it to jump!
    [self.hero jump];
    
    //enable touch
    self.userInteractionEnabled = TRUE;
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
    
    [self schedule:@selector(timerUpdate:) interval:1];
    
    
    
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
    _timeLabel.string = [NSString stringWithFormat:@"%d", numSeconds];
    
    if(targetOn == false)
    {
        [self createTarget];
    }
    
    
    if(randomX <= _dart.position.x+30 && randomX >= _dart.position.x-30 &&
       randomY <= _dart.position.y+30 && randomY >= _dart.position.y-30 )
    {
        
        [self removeTarget];
        targetOn=false;
        
    }
    
    if(numSeconds>=60)
    {
        [self endMinigame];
    }
    
   
    
    
}


-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    NSLog(@"%d",score);
    [self endMinigameWithScore:score];
}

// DO NOT DELETE!
-(MyCharacter *)hero {
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_dart removeFromParent];
    touchLocation = [touch locationInNode:self];
    NSLog(@"X location: %f", touchLocation.x);
    NSLog(@"Y Location: %f",touchLocation.y);
    
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self createDart];
}

-(void)createTarget
{
     randomX = (arc4random()%rangeX) +40;
     randomY = (arc4random()%rangeY) +40;
    
    _dbTarget = [CCBReader load:@"DBTarget"];
    _dbTarget.position = CGPointMake(randomX, randomY);
    [self addChild:_dbTarget];
    
    NSLog(@"%d",randomX);
    NSLog(@"%d",randomY);
    
    targetOn = true;
}

-(void)createDart
{
    _dart = [CCBReader load:@"DBDart"];
    _dart.position = CGPointMake(touchLocation.x,20);
    [self addChild:_dart];
    //NSLog(@"dart created");
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.2 position:CGPointMake(touchLocation.x,touchLocation.y)];
    [_dart runAction:actionMove];
}

- (void)removeTarget {
    
    //load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SealExplosion"];
    
    //make the particle effect clean itself up,once its complete
    explosion.autoRemoveOnFinish = TRUE;
    
    //place the particle effect on the seals position
    explosion.position = _dbTarget.position;
    
    //add the particle effect to the same node the seal is on
    [self addChild:explosion];
    
    //finally,remove the destriyed seal
    [_dbTarget removeFromParent];
    score++;
    
}

-(void) timerUpdate:(CCTime)delta
{
    numSeconds++;
    NSLog(@"%d",numSeconds);
    _timeLabel.string = [NSString stringWithFormat:@"%d", numSeconds];
    // update timer here, using numSeconds
}






@end
