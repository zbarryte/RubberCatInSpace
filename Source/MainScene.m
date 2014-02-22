//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void) beginRubbing {
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

@end
