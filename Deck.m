//
//  Deck.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

- (Deck *)init {
    self = [super init];
    if (self) {
        self.totalCardCount = 16;
    }
    return self;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
        NSArray *colourCards = @[@"colour1.png", @"colour2.png", @"colour3.png", @"colour4.png", @"colour5.png", @"colour6.png", @"colour7.png", @"colour8.png", @"colour1.png", @"colour2.png", @"colour3.png", @"colour4.png", @"colour5.png", @"colour6.png", @"colour7.png", @"colour8.png"];
        for (int i=0; i<16; i++) {
            NSString *colourCard = colourCards[i];
            _cards[i] = [[Card alloc] initWithColourCard:colourCard];
        }
    }
    return _cards;
}

- (Card *)pickRandomCard {
    Card *card;
    int random = arc4random() % self.cards.count;
    card = [self.cards objectAtIndex:random];
    [self.cards removeObjectAtIndex:random];
    return card;
}

@end
