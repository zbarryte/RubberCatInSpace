//
//  RubberCat.m
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RubberCat.h"

@implementation RubberCat {
    CCNode *_legF;
    CCNode *_legB;
    CCNode *_armF;
    CCNode *_armB;
    CCNode *_head;
    CCNode *_tail;
    CCNode *_body;
    CCSprite *_bubble;
}

const uint kXForceMax = 44444;
const uint kYForceMax = 44444;
const float kChangeVelPeriod = 2.4;
const uint kAngMax = 2;

+(id) cat {
    return [CCBReader load:NSStringFromClass(self)];
}

-(void) didLoadFromCCB {
    // darken back arm and leg
    CCColor *$colorDark = [CCColor colorWithRed:0.5f green:0.5f blue:0.5f];
    _armB.color = $colorDark;
    _legB.color = $colorDark;
    // hide the bubble until pressed
    [self hideBubble];
    
    [self begin];
}

-(void)hideBubble {_bubble.visible = NO;}
-(void)showBubble {_bubble.visible = YES;}

-(void) begin {
    [self changeVelocity];
    [self schedule:@selector(changeVelocity) interval:kChangeVelPeriod];
}

-(void) changeVelocity {
    // tang vel
    float $xForce = (float)(arc4random()%kXForceMax) - kXForceMax/2.f;
    float $yForce = (float)(arc4random()%kYForceMax) - kYForceMax/2.f;
    self.physicsBody.force = ccp($xForce,$yForce);
    // ang vel
    float $ang = ((float)(arc4random()%kAngMax) - kAngMax/2.f)*0.22;
    self.physicsBody.angularVelocity += $ang;
}

//-(void) update:(CCTime)delta {
//    NSLog(@"velocity = (%f,%f)",self.physicsBody.velocity.x,self.physicsBody.velocity.y);
//    NSLog(@"angularVelocity = %f",self.physicsBody.angularVelocity);
//}

@end
