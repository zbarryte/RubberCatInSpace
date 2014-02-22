//
//  RCFlailable.m
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RCFlailable.h"

@implementation RCFlailable {
    CCSprite *_sprite;
}

-(void) didLoadFromCCB {
    float $flailDelay = (arc4random()%5000) / 1000.f;
    [self scheduleOnce:@selector(playFlail) delay:$flailDelay];
}

-(void) playFlail {
    CCBAnimationManager *$animMan = self.userObject;
    [$animMan runAnimationsForSequenceNamed:@"Flail"];
}

-(CCColor *)color {return _sprite.color;}
-(void) setColor:(CCColor *)$color {
    _sprite.color = $color;
}

@end
