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
#import "RCSSector.h"

@implementation GameScene {
    /* created in Sprite Builder */
    CCNode *_contentNode;
    CCNode *_schroedingersBox;
    CCPhysicsNode *_physicsNode;
    RubberCat *_rubberCat;
//    CCNode *_cameraBox;
    
    float xScreen;
    float yScreen;
    
    BOOL isTouching;
    CGPoint touchPoint;
    
    NSMutableArray *sectors;
    
    CCAction *follow;
    CCNode *followNode;
    
    int coldCounter;
}

const uint kMargin = 22;
const float kAdjustMentPush = 1111;
const uint kBubbleSensitivity = 44;

const uint kNumSectors = 1;

const uint kSectorsRows = 3;
const uint kSectorsCols = 3;

const float kFollowVel = 5;
//const float kFollowVelMax = 444;
const uint kColdCounterMax = 5;

-(void) didLoadFromCCB {
    // get screen coords
    CGSize $sizeScreen = [[CCDirector sharedDirector] viewSize];
    xScreen = $sizeScreen.width;
    yScreen = $sizeScreen.height;
    
    [self addSectors];
    [self addRubberCat];
    [self setupCameralikeBehavior];
    
    coldCounter = kColdCounterMax;
    
    // allow touch
    self.userInteractionEnabled = YES;
}

-(void) addSectors {
    sectors = [NSMutableArray array];
    float $wSector = _contentNode.boundingBox.size.width/kSectorsCols;
    float $hSector = _contentNode.boundingBox.size.height/kSectorsRows;
    for (uint i = 0; i < kSectorsCols; i++) {
        NSMutableArray *$col = [NSMutableArray array];
        for (uint j = 0; j < kSectorsRows; j++) {
            // create a new sector
            RCSSector *$sector = [RCSSector node];
            [$col addObject:$sector];
            // position sector
            float $xSector = (i + 0.0)*$wSector;
            float $ySector = (j + 0.0)*$hSector;
            $sector.position = ccp($xSector,$ySector);
            // configure the sector
            [$sector configure];
            // Don't forget to add the sector to the physics node. Seriously. It needs physics.
            [_physicsNode addChild:$sector];
        }
        [sectors addObject:$col];
    }
}

-(void) addRubberCat {
    // create rubber cat
    _rubberCat = [RubberCat cat];
    [_physicsNode addChild:_rubberCat];
    // position rubber cat
    CGSize $sizePhys = _physicsNode.boundingBox.size;
    _rubberCat.position = ccp($sizePhys.width/2,$sizePhys.height/2);
}

-(void) setupCameralikeBehavior {
    // create follow node
    followNode = [CCNode node];
    followNode.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:1 andCenter:_rubberCat.position];
    followNode.physicsBody.type = CCPhysicsBodyTypeDynamic;
    followNode.physicsBody.affectedByGravity = NO;
    followNode.physicsBody.collisionMask = @[]; // don't collide with stuff
    [_physicsNode addChild:followNode];
    followNode.position = _rubberCat.position;
    // camera follows follow node, which follows the cat
    follow = [CCActionFollow actionWithTarget:followNode worldBoundary:_contentNode.boundingBox];
    [_contentNode runAction:follow];
}

// called on button presses
-(void) exitLevel {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}
-(void) restartLevel {
    [[CCDirector sharedDirector] replaceScene:[[self class] scene]];
}

-(void)update:(CCTime)$dt {
    [self moveThatFollowNode];
//    [self checkCatInCameraBox];
    [self checkCatBubble];
    [self checkCatInSchroedingersBox];
    [self checkIfCatStoppedBubbling];
}

-(void) checkIfCatStoppedBubbling {
    if (!_rubberCat.justStoppedBubbling) {return;}
    NSLog(@"just stopped bubbling");
    [self schedule:@selector(runColdTimer) interval:0.044];
}

-(void) runColdTimer {
    coldCounter --;
    NSLog(@"cold counter = %d",coldCounter);
    if (coldCounter <= 0) {
        [self lose];
    }
}

-(void) lose {
    NSLog(@"TOOOOOO COLD!");
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

-(void) moveThatFollowNode {
//    float $dx = 0;
//    float $dy = 0;
//    
////    CGPoint $catPos = _rubberCat.position;
//    CGPoint $followPos = followNode.position;
//    CGPoint $followVel = followNode.physicsBody.velocity;
////    float $deltaX = $catPos.x - $followPos.x;
////    float $deltaY = $catPos.y - $followPos.y;
////    followNode.position = ccpAdd(followNode.position, ccp($deltaX,$deltaY));
//    
////    float scaleFactor = 10;
////    followNode.physicsBody.force = ccp($deltaX*scaleFactor,$deltaY*scaleFactor);
//    
//    if ($followPos.x < _rubberCat.position.x) {
//        $dx += kFollowVel;
//    } else if ($followPos.x > _rubberCat.position.x) {
//        $dx -= kFollowVel;
//    }
//    
//    if ($followPos.y < _rubberCat.position.y) {
//        $dy += kFollowVel;
//    } else if (followNode.position.y > _rubberCat.position.y) {
//        $dy -= kFollowVel;
//    }
////
//    followNode.physicsBody.velocity = ccp($followVel.x + $dx, $followVel.y + $dy);
    
    
    CGPoint $catPos = _rubberCat.position;
    CGPoint $followPos = followNode.position;
    float $deltaX = $catPos.x - $followPos.x;
    float $deltaY = $catPos.y - $followPos.y;
//    CGPoint $catVel = _rubberCat.physicsBody.velocity;
//    followNode.physicsBody.velocity = ccp($deltaX * $catVel.x, $deltaY * $catVel.y);
    float $scaleFactor = 0.088;
    followNode.position = ccp($followPos.x + $deltaX*$scaleFactor, $followPos.y + $deltaY*$scaleFactor);
    
    
    
//    NSLog(@"(%f,%f)",followNode.physicsBody.velocity.x,followNode.physicsBody.velocity.y);
//
////    // don't go too fast!
//    float $distX = abs(_rubberCat.position.x - $followPos.x);
//    float $distY = abs(_rubberCat.position.y - $followPos.y);
//    
////    float $vx = followNode.physicsBody.velocity.x;
////    float $vy = followNode.physicsBody.velocity.y;
////    float $followVelMaxX = _rubberCat.physicsBody.velocity.x * 5 * $distX;
////    float $followVelMaxY = _rubberCat.physicsBody.velocity.y * 5 * $distY;
////    if ($vx > $followVelMaxX) {$vx = $followVelMaxX;}
////    else if ($vx < -$followVelMaxX) {$vx = -$followVelMaxX;}
////    if ($vy > $followVelMaxY) {$vy = $followVelMaxY;}
////    else if ($vy < -$followVelMaxY) {$vy = -$followVelMaxY;}
////    followNode.physicsBody.velocity = ccp($vx,$vy);
}

//-(void) checkCatInCameraBox {
//    CGRect $box = _cameraBox.boundingBox;
//    CGPoint $catPos = _rubberCat.position;
//    // track the cat if it's outside the box
//    if (!CGRectContainsPoint($box,$catPos)) {
////        follow = [CCActionFollow actionWithTarget:_rubberCat worldBoundary:_contentNode.boundingBox];
//        follow = [CCActionMoveTo actionWithDuration:1.00 position:ccp(-$catPos.x,-$catPos.y)];
//        [_contentNode runAction:follow];
//    } else if (follow) {
//        // otherwise, stop tracking it, it's in the box
//        // don't bother turning off tracking if the cat's already not tracked
//        [_contentNode stopAction:follow];
//        follow = nil;
//    }
//}

-(void) checkCatBubble {
    // only if the player is touching
    if (!isTouching) {[_rubberCat hideBubble]; return;}
    // check if the touch is appropriately over the cat
    CGPoint $catPoint = [_contentNode convertToWorldSpace:_rubberCat.position];
    float dx = abs($catPoint.x - touchPoint.x);
    float dy = abs($catPoint.y - touchPoint.y);
    // sensitivity can be adjusted, by the way
    if (dx < kBubbleSensitivity && dy < kBubbleSensitivity) {
        coldCounter = kColdCounterMax;
        [self unschedule:@selector(runColdTimer)];
        [_rubberCat showBubble];
    } else {
        [_rubberCat hideBubble];
    }
}

-(void) checkCatInSchroedingersBox {
//    NSLog(@"rubber cat is at (%f,%f)",_rubberCat.position.x,_rubberCat.position.y);
//    NSLog(@"schroedingersBox is def by (%f,%f) w = %f h = %f",_schroedingersBox.position.x,_schroedingersBox.position.y,_schroedingersBox.boundingBox.size.width,_schroedingersBox.boundingBox.size.height);
    // Is the cat in the box???  I hope so!
    CGRect $box = _schroedingersBox.boundingBox;
    CGPoint $catPos = _rubberCat.position;
    // okay, really it's about the follow node
    CGPoint $followPos = followNode.position;
    if (!CGRectContainsPoint($box, $followPos)) {
//        NSLog(@":(");
        // If not, put it in the box!  Dammit.
        // (base this on which side of the box the cat is)
        float $magnitudeDx = $box.size.width/2;
        float $magnitudeDy = $box.size.height/2;
        float $dx = 0;
        float $dy = 0;
        CGPoint $boxPos = _schroedingersBox.position;
        if ($followPos.x > $magnitudeDx + $boxPos.x) {$dx -= 2*$magnitudeDx;}
        else if ($followPos.x < -$magnitudeDx + $boxPos.x) {$dx += 2*$magnitudeDx;}
        if ($followPos.y > $magnitudeDy + $boxPos.y) {$dy -= 2*$magnitudeDy;}
        else if ($followPos.y < -$magnitudeDy + $boxPos.y) {$dy += 2*$magnitudeDy;}
        // move the content node first, then the cat, to prevent screen jump
        CGPoint $contentPos = _contentNode.position;
        _contentNode.position = ccp($contentPos.x - $dx, $contentPos.y - $dy);
        // reconfigure everything before moving the cat, so that collisions aren't wonky
        [self reconfigureAllSectorsMovingDx:$dx Dy:$dy];
        // okay, now move the cat
        _rubberCat.position = ccp($catPos.x + $dx, $catPos.y + $dy);
        followNode.position = ccp($followPos.x + $dx, $followPos.y + $dy);
    }
}

-(void) reconfigureAllSectorsMovingDx:(float)$dx Dy:(float)$dy {
    // set directions
    int $di = 0;
    int $dj = 0;
    if ($dx > 0) {$di += 1;}
    else if ($dx < 0) {$di -= 1;}
    if ($dy > 0) {$dj += 1;}
    else if ($dy < 0) {$dj -= 1;}
    
//    NSLog(@"di = %d; dj = %d; directions: %@, %@, %@, %@",$di,$dj,($dx > 0)?@"R":@"",($dx < 0)?@"L":@"",($dy > 0)?@"U":@"",($dy < 0)?@"D":@"");
    
//    NSLog(@"dx,dy = %f,%f",$dx,$dy);
    
    // preset the configurations
    for (uint i = 0; i < sectors.count; i++) {
        NSMutableArray *$cols = [sectors objectAtIndex:i];
        for (uint j = 0; j < $cols.count; j++) {
            RCSSector *$sector = [$cols objectAtIndex:j];
            int $iNew = i - $di;
            int $jNew = j - $dj;
            
//            NSLog(@"(%d,%d) replaced by (%d,%d)",i,j,$iNew,$jNew);
            // of course, only preset the sector if the neighbor exists
            if (0 <= $iNew && $iNew < kSectorsCols &&
                0 <= $jNew && $jNew < kSectorsRows) {
                RCSSector *$sectorNew = [[sectors objectAtIndex:$iNew] objectAtIndex:$jNew];
//                NSLog(@"locations: (%f,%f) -> (%f,%f)",$sector.position.x,$sector.position.y,$sectorNew.position.x,$sectorNew.position.y);
                [$sector presetConfiguretaionFromSector:$sectorNew];
            }
        }
    }
    // reconfigure everything
    for (uint i = 0; i < sectors.count; i++) {
        NSMutableArray *$cols = [sectors objectAtIndex:i];
        for (uint j = 0; j < $cols.count; j++) {
            RCSSector *$sector = [$cols objectAtIndex:j];
            [$sector configure];
        }
    }
}

// set the touch location if a touch exists
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setTouchPoint:touch];
}
-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setTouchPoint:touch];
}

// destroy the touch point after if the touch has vanished
-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self stopTouch];
}
-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self stopTouch];
}

// actually sets/unsets the touch point
-(void) setTouchPoint:(UITouch *)touch {
    isTouching = YES;
    touchPoint = [touch locationInWorld];
}
-(void) stopTouch {
    isTouching = NO;
}

@end
