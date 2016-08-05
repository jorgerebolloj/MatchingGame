//
//  Card.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "Card.h"

@implementation Card

- (Card *)initWithColourCard:(NSString *)aColourCard {
    self = [super init];
    if (self) {
        self.isFlipped = NO;
        self.isPlayable = YES;
        self.colourCard = aColourCard;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.colourCard];
}

- (int)match:(NSArray *)cards {
    int point = 0;
    if (cards.count < 2)
        return 0;
    Card *firstCard = cards[0];
    Card *lastCard = [cards lastObject];
    if (firstCard.colourCard == lastCard.colourCard && firstCard.colourCard == self.colourCard)
        point = 2;
    return point;
}

@end
