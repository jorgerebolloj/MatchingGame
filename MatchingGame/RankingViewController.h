//
//  RankingViewController.h
//  MatchingGame
//
//  Created by Jorge Rebollo on 17/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myRankingTable;

- (void)requestRankingModelData:(NSArray *)modelData andCurrentScore:(NSString *)currentScore;

@end
