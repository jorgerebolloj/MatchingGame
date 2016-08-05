//
//  LogicGame.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "LogicGame.h"
#import "AppDelegate.h"

@interface LogicGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSUInteger pairCount;
@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSUInteger currentIndex;

@end

@implementation LogicGame

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    if (deck.totalCardCount < count)
        return nil;
    
    self = [super init];
    _deck = deck;
    if(self) {
        for(int i=0; i<count; i++)
            self.cards[i] = [deck pickRandomCard];
    }
    
    return self;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    _currentIndex = index;
    Card *card = [_cards objectAtIndex:index];
    
    NSMutableArray *selectedCards = [[NSMutableArray alloc] init];
    
    if (!card)
        return;
    
    if (!card.isPlayable)
        return;
    
    if (card.isFlipped)
        return;
    else
        card.isFlipped = YES;
    
    for (Card *card in _cards) {
        if(card.isFlipped && card.isPlayable)
            [selectedCards addObject:card];
    }
    
    self.currentScore = [card match:selectedCards];
    
    if (self.currentScore == 0) {
        if (selectedCards.count > 1)
            [self performSelector:@selector(flipCardsWithSelectedCards:)
                       withObject:selectedCards
                       afterDelay:0];
        self.score -= 1;
    } else {
        self.score += self.currentScore;
        self.pairCount++;
        [self performSelector:@selector(flipCardsAndDisableWithSelectedCards:)
                   withObject:selectedCards
                   afterDelay:0];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return [_cards objectAtIndex:index];
}


- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)flipCardsWithSelectedCards:(NSMutableArray *)selectedCards {
    for(Card *card in selectedCards) {
        card.isPlayable = YES;
        card.isFlipped = NO;
        self.currentScore = 0;
    }
}

- (void)flipCardsAndDisableWithSelectedCards:(NSMutableArray *)selectedCards {
    for(Card *card in selectedCards) {
        card.isPlayable = NO;
        card.isFlipped = NO;
        self.currentScore = 0;
    }
}

- (void)requestStoreDataWithUserName:(NSString *)userName {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *rank = [NSEntityDescription insertNewObjectForEntityForName:@"Rank"
                                                          inManagedObjectContext:context];
    [rank setValue:userName forKey:@"userName"];
    [rank setValue:@((int)self.score) forKey:@"userScore"];
    
    NSError *error;
    if (![context save:&error])
        NSLog(@"Error when trying to save data: %@", [error localizedDescription]);
}

- (void)resetCounters {
    self.score = 0;
    self.pairCount = 0;
    for(Card *card in _cards)
        card.isPlayable = YES;
}

- (NSArray *)requestToObtainRanking {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *rank = [NSEntityDescription entityForName:@"Rank"
                                            inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:rank];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userScore" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in fetchedObjects) {
        NSLog(@"User Name: %@", [obj valueForKey:@"userName"]);
        NSLog(@"User Score: %@", [obj valueForKey:@"userScore"]);
        NSLog(@"------------------");
    }
    return fetchedObjects;
}

@end
