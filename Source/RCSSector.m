//
//  RCSSector.m
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RCSSector.h"

@implementation RCSSector {
    NSMutableArray *configurations;
    NSString *nextConfigurationString;
}

-(id) init {
    if ((self = [super init])) {
        // the obstacle configurations are made in Sprite Builder, because yeah.
        configurations = [NSMutableArray arrayWithObjects:
                          @"sectors/lvl0/Sector000",
                          @"sectors/lvl0/Sector001",
                          @"sectors/lvl0/Sector002",
                          nil];
    }
    return self;
}

-(void) configure {
    // populate the sector with a random configuration (by adding the config as a child)
    // destroy allllll the children
    [self removeAllChildren];
//    NSLog(@"%@",self.configurationString);
    // generate a random config if there isn't one already specified by a move or something
    if (!nextConfigurationString) {
//        NSLog(@"nil -> (%f,%f)",self.position.x,self.position.y);
        self.configurationString = [configurations objectAtIndex:arc4random()%(configurations.count)];
    } else {
//        NSLog(@"groovy -> (%f,%f) %@",self.position.x,self.position.y,nextConfigurationString);
        self.configurationString = nextConfigurationString;
        nextConfigurationString = nil; 
    }
    // then add the new config to the sector
    CCNode *$config = [CCBReader load:self.configurationString];
    [self addChild:$config];
}

-(void) presetConfiguretaionFromSector:(RCSSector *)$sector {
    if (!$sector) {return;}
//    nextConfigurationString = [NSString stringWithFormat:@"%@",$sector.configurationString ];
    nextConfigurationString = $sector.configurationString;
}

@end
