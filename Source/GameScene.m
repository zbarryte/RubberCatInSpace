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
    CCNode *_contentNode;
    CCNode *_schroedingersBox;
    CCPhysicsNode *_physicsNode;
    RubberCat *_rubberCat;
}

float xScreen;
float yScreen;

const uint kMargin = 22;
const float kAdjustMentPush = 1111;
const uint kBubbleSensitivity = 22;

const uint kNumSectors = 1;

BOOL isTouching;
CGPoint touchPoint;

const uint kSectorsRows = 3;
const uint kSectorsCols = 3;
NSMutableArray *sectors;

-(void) didLoadFromCCB {
    // get screen coords
    CGSize $sizeScreen = [[CCDirector sharedDirector] viewSize];
    xScreen = $sizeScreen.width;
    yScreen = $sizeScreen.height;
    
    [self addSectors];
    [self addRubberCat];
    [self setupCameralikeBehavior];
    
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
            float $xSector = (i + 0.5)*$wSector;
            float $ySector = (j + 0.5)*$hSector;
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
    // camera follows rubber cat
    CCActionFollow *$follow = [CCActionFollow actionWithTarget:_rubberCat worldBoundary:_contentNode.boundingBox];
    [_contentNode runAction:$follow];
}

// called on button presses
-(void) exitLevel {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}
-(void) restartLevel {
    [[CCDirector sharedDirector] replaceScene:[[self class] scene]];
}

-(void)update:(CCTime)$dt {
    [self checkCatBubble];
    [self checkCatInSchroedingersBox];
}

-(void) checkCatBubble {
    // only if the player is touching
    if (!isTouching) {[_rubberCat hideBubble]; return;}
    // check if the touch is appropriately over the cat
    CGPoint $catPoint = [_contentNode convertToWorldSpace:_rubberCat.position];
    float dx = abs($catPoint.x - touchPoint.x);
    float dy = abs($catPoint.y - touchPoint.y);
    // sensitivity can be adjusted, by the way
    if (dx < kBubbleSensitivity && dy < kBubbleSensitivity) {
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
    if (!CGRectContainsPoint($box, $catPos)) {
        NSLog(@":(");
        // If not, put it in the box!  Dammit.
        // (base this on which side of the box the cat is)
        float $magnitudeDx = $box.size.width/2;
        float $magnitudeDy = $box.size.height/2;
        float $dx = 0;
        float $dy = 0;
        CGPoint $boxPos = _schroedingersBox.position;
        if ($catPos.x > $magnitudeDx + $boxPos.x) {$dx -= 2*$magnitudeDx;}
        else if ($catPos.x < -$magnitudeDx + $boxPos.x) {$dx += 2*$magnitudeDx;}
        if ($catPos.y > $magnitudeDy + $boxPos.y) {$dy -= 2*$magnitudeDy;}
        else if ($catPos.y < -$magnitudeDy + $boxPos.y) {$dy += 2*$magnitudeDy;}
        // move the content node first, then the cat, to prevent screen jump
        CGPoint $contentPos = _contentNode.position;
        _contentNode.position = ccp($contentPos.x - $dx, $contentPos.y - $dy);
        // reconfigure everything before moving the cat, so that collisions aren't wonky
        [self reconfigureAllSectorsMovingDx:$dx Dy:$dy];
        // okay, now move the cat
        _rubberCat.position = ccp($catPos.x + $dx, $catPos.y + $dy);
        NSLog(@"_contentNode pos (%f,%f)",_contentNode.position.x,_contentNode.position.y);
        
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
    // preset the configurations
    for (uint i = 0; i < sectors.count; i++) {
        NSMutableArray *$cols = [sectors objectAtIndex:i];
        for (uint j = 0; j < $cols.count; j++) {
            RCSSector *$sector = [$cols objectAtIndex:j];
            int $iNew = i + $di;
            int $jNew = j + $dj;
            if (0 <= $iNew && $iNew < kSectorsCols &&
                0 <= $jNew && $jNew < kSectorsRows) {
                NSLog(@"preset new");
                RCSSector *$sectorNew = [[sectors objectAtIndex:$iNew] objectAtIndex:$jNew];
                [$sector presetConfiguretaionFromSector:$sectorNew];
            } else {
                NSLog(@"don't...");
                [$sector presetConfiguretaionFromSector:nil];
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
