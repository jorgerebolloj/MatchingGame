//
//  RankingTableViewCell.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 17/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "RankingTableViewCell.h"

@interface RankingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *rankCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreCellLabel;
@property(nonatomic, strong) NSArray *userModelInfo;

@end

@implementation RankingTableViewCell

- (void)setRankingUser:(NSArray *)userInfo andIndex:(int)index {
    self.userModelInfo = userInfo;
    int rankNumber = index+1;
    [self reloadDataWithRankNumber:rankNumber];
}

- (void)reloadDataWithRankNumber:(int)rankNumber {
    [self.rankCellLabel setText:[NSString stringWithFormat:@"%d", rankNumber]];
    [self.nameCellLabel setText:[[self.userModelInfo valueForKey:@"userName"] description]];
    [self.scoreCellLabel setText:[[self.userModelInfo valueForKey:@"userScore"] description]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
