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
CCNode *_pointerX;
CCNode *_pointerY;
CCLabelTTF *timelabel;
CCLabelTTF *scorelabel;




int score = 0;

int minY = 40;
int minX = 40;

int maxY = 280;
int maxX = 530;

int rangeY = 280-40;
int rangeX = 530-40;

int randomX;
int randomY;

int numSeconds=60;


CGPoint touchLocation;

bool targetOn = false;

bool touch1 = true;
bool touch2 = false;
bool pointer1 = true;
bool pointer2 = true;

bool checkTouch = false;
bool checkPointer = false;

int touchX,touchY;

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"These are the game instructions :D";
        
         numSeconds=60;
         score = 0;
        
         targetOn = false;
        
         touch1 = true;
         touch2 = false;
         pointer1 = true;
         pointer2 = true;
        
         checkTouch = false;
         checkPointer = false;
        
        
        
        
        timelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",numSeconds] fontName:@"Verdana-Bold" fontSize:18.0f];
        
        timelabel.position = CGPointMake(265, 300);
        
        
        [self addChild: timelabel z:14];
        
        scorelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"score: %d",score] fontName:@"Verdana-Bold" fontSize:18.0f];
        
        scorelabel.position = CGPointMake(50, 300);
        
        
        [self addChild: scorelabel z:14];
        
        
        [[CCDirector sharedDirector] setAnimationInterval:1.0/30];
        
        [self pointerXUpdate];
        
        
        
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
    
    /*if(randomX <= _dart.position.x+25 && randomX >= _dart.position.x-25 &&
       randomY <= _dart.position.y+25 && randomY >= _dart.position.y-25 )
    {
        
        [self removeTarget];
        targetOn=false;
        
    }*/
    
    
    if(targetOn == false)
    {
        [self createTarget];
    }
    
    if(numSeconds<=0)
    {
        [self endMinigame];
    }
    
   
    
    
}


-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    NSLog(@"score: %d",score);
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
    
    if(touch1 == true &&touch2 == false)
    {
        //touchX = touchLocation.x;
        [self xTouched];
    }
    if(touch1 == false &&touch2 == true)
    {
        //touchY = touchLocation.y;
        
        checkTouch = true;

        [self yTouched];
    }
    
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(touch1 == true &&touch2 == false)
    {
        touch1 = false;
        touch2 = true;
        
    }
    
    if(touch2 == true &&touch1 == false && checkTouch==true)
    {
        touch2 = false;
        touch1 = true;
        checkTouch=false;
        
    }
    
    
   
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
    _dart.position = CGPointMake(touchX,20);
    [self addChild:_dart z:13];
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.2 position:CGPointMake(touchX,touchY)];
    [_dart runAction:actionMove];
    
    [self performSelector:@selector(checkHit) withObject:self afterDelay:0.2f ];
    
    
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
    scorelabel.string = [NSString stringWithFormat:@"score: %d",score];
    
}

-(void) timerUpdate:(CCTime)delta
{
    numSeconds--;
    NSLog(@"%d",numSeconds);
    timelabel.string = [NSString stringWithFormat:@"%d",numSeconds];
   
    
    // update timer here, using numSeconds
}

-(void) pointerXUpdate
{
    
    NSLog(@"pointer x starts");
    //[_pointerX removeFromParent];
    _pointerX = [CCBReader load:@"DBPointer"];
    _pointerX.position = CGPointMake(560,140);
    [self addChild:_pointerX z:13];
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:2 position:CGPointMake(0,140)];
    CCAction *actionMove2 = [CCActionMoveTo actionWithDuration:2 position:CGPointMake(560,140)];
    CCActionRemove *actionRemove = [CCActionRemove action];
    
    CCActionSequence *pointerSequence = [CCActionSequence actionWithArray:@[actionMove,actionMove2]];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:pointerSequence];
    
    [_pointerX runAction:repeat];
    
    pointer1 = true;
    
}

-(void)pointerYUpdate
{
    NSLog(@"pointer y starts");
    //[_pointerY removeFromParent];
    _pointerY = [CCBReader load:@"DBPointer2"];
    _pointerY.position = CGPointMake(265,280);
    [self addChild:_pointerY z:13];
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:2 position:CGPointMake(265,0)];
    CCAction *actionMove2 = [CCActionMoveTo actionWithDuration:2 position:CGPointMake(265,280)];
    CCActionRemove *actionRemove = [CCActionRemove action];
    
    CCActionSequence *pointerSequence = [CCActionSequence actionWithArray:@[actionMove,actionMove2]];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:pointerSequence];
    
    [_pointerY runAction:repeat];
}

-(void)xTouched
{
    NSLog(@"x position set");
    touchX = _pointerX.position.x;
    [_pointerX removeFromParent];
    [self pointerYUpdate];
}

-(void)yTouched
{
    NSLog(@"y position set");
    touchY = _pointerY.position.y;
    [_pointerY removeFromParent];
    [self pointerXUpdate];
    [self createDart];
    
}

-(void)checkHit
{
    if(randomX <= touchX+25 && randomX >= touchX-25 &&
       randomY <= touchY+25 && randomY >= touchY-25 )
    {
        
        [self removeTarget];
        targetOn=false;
        
    }
    
}






@end
