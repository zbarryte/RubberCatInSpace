//
//  GameScene.m
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "MainScene.h"
#import "RubberCat.h"

@implementation GameScene {
    CCNode *_contentNode;
    RubberCat *_rubberCat;
    
    // this should really be prog. gen, and a group
    CCNode *_sector0;
    CCNode *_sector1;
    CCNode *_sector2;
    CCNode *_sector3;
    CCNode *_sector4;
    CCNode *_sector5;
    CCNode *_sector6;
    CCNode *_sector7;
    CCNode *_sector8;
}

float xScreen;
float yScreen;

const uint kMargin = 22;
const float kAdjustMentPush = 1111;
const uint kBubbleSensitivity = 22;

const uint kNumSectors = 1;

BOOL isTouching;
CGPoint touchPoint;

-(void) didLoadFromCCB {
    // get screen coords
    CGSize $size = [[CCDirector sharedDirector] viewSize];
    xScreen = $size.width;
    yScreen = $size.height;
    
//    // camera follows rubber cat
    CCActionFollow *$follow = [CCActionFollow actionWithTarget:_rubberCat worldBoundary:_contentNode.boundingBox];
    [_contentNode runAction:$follow];
    
    self.userInteractionEnabled = YES;
    
    
    // should go elsewhere
    _sector0 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector1 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector2 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector3 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector4 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector5 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector6 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector7 = [CCBReader load:@"sectors/lvl0/Sector000"];
    _sector8 = [CCBReader load:@"sectors/lvl0/Sector000"];
}

-(void) exitLevel {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

-(void) restartLevel {
    [[CCDirector sharedDirector] replaceScene:[[self class] scene]];
}

-(void)update:(CCTime)$dt {
//
//    CGPoint $RCPos = [_rubberCat convertToWorldSpace:_rubberCat.position];
//    if ($RCPos.x < kMargin) {
//        _rubberCat.physicsBody.force = ccp(kAdjustMentPush,0);
//    } else if ($RCPos.x > xScreen - kMargin) {
//        _rubberCat.physicsBody.force = ccp(-kAdjustMentPush,0);
//    }
//    
//    if ($RCPos.y < kMargin) {
//        _rubberCat.physicsBody.force = ccp(0,kAdjustMentPush);
//    } else if ($RCPos.y > yScreen - kMargin) {
//        _rubberCat.physicsBody.force = ccp(0,-kAdjustMentPush);
//    }
//    //followNode.position = ccpAdd(_rubberCat.position,ccp(-_contentNode.boundingBox.size.width/2,-_contentNode.boundingBox.size.height/2));
//    NSLog(@"cat... (%f,%f)",_rubberCat.position.x,_rubberCat.position.y);
//    NSLog(@"following... (%f,%f)",_contentNode.position.x,_contentNode.position.y);
    
//    [self moveCamera];
    [self checkCatBubble];
}

-(void) popBackContentNode {
    // not implemented
}
//
//-(void) moveCamera {
//    if (!isTouching) {return;}
//    CGPoint $catPoint = [_contentNode convertToWorldSpace:_rubberCat.position];
//    float dx = $catPoint.x - touchPoint.x;
//    float dy = $catPoint.y - touchPoint.y;
//    float yNew = 0;
//    float xNew = 0;
//    if (dx > 0) {xNew = _contentNode.position.x + 0.001;}
//    else if (dx < 0) {xNew = _contentNode.position.x - 0.001;}
//    if (dy > 0) {yNew = _contentNode.position.y + 0.001;}
//    else if (dy < 0) {yNew = _contentNode.position.y - 0.001;}
//    _contentNode.position = ccp(xNew,yNew);
//}

-(void) checkCatBubble {
    // only if the player is touching
    if (!isTouching) {[_rubberCat hideBubble]; return;}
    CGPoint $catPoint = [_contentNode convertToWorldSpace:_rubberCat.position];
    float dx = abs($catPoint.x - touchPoint.x);
    float dy = abs($catPoint.y - touchPoint.y);
    if (dx < kBubbleSensitivity && dy < kBubbleSensitivity) {
        [_rubberCat showBubble];
    } else {
        [_rubberCat hideBubble];
    }

}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setTouchPoint:touch];
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setTouchPoint:touch];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self stopTouch];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self stopTouch];
}

-(void) setTouchPoint:(UITouch *)touch {
    isTouching = YES;
    touchPoint = [touch locationInWorld];
}
-(void) stopTouch {
    isTouching = NO;
}

@end
