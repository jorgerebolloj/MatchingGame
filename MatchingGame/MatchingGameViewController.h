//
//  MatchingGameViewController.h
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "Deck.h"

@interface MatchingGameViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

