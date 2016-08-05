//
//  LogicGame.h
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface LogicGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger pairCount;
@property (nonatomic, readonly) NSInteger currentScore;
@property (nonatomic, readonly) NSUInteger currentIndex;

// deginated initalizer

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)requestStoreDataWithUserName:(NSString *)userName;
- (void)resetCounters;
- (NSArray *)requestToObtainRanking;

@end
