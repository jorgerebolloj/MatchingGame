//
//  Card.h
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *colourCard;
@property (nonatomic) BOOL isPlayable;
@property (nonatomic) BOOL isFlipped;

- (Card *)initWithColourCard:(NSString *)colourCard;

- (int)match:(NSArray *)cards;

@end
