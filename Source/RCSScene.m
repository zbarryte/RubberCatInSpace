//
//  RCSScene.m
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RCSScene.h"

@implementation RCSScene

+(id)scene {
    return [CCBReader loadAsScene:NSStringFromClass(self)];
}

@end
