//
//  RCSSector.h
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface RCSSector : CCNode

@property (nonatomic,strong) NSString *configurationString;

-(void) configure;
-(void) presetConfiguretaionFromSector:(RCSSector *)$sector;

@end
