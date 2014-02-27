//
//  RubberCat.h
//  RubberCatInSpace
//
//  Created by Zachary Barryte on 2/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface RubberCat : CCNode

@property (nonatomic,assign) BOOL justStoppedBubbling;

+(id) cat;
-(void) begin;
-(void) hideBubble;
-(void) showBubble;

@end
