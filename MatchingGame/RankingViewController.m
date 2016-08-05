//
//  RankingViewController.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 17/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "RankingViewController.h"
#import "LogicGame.h"
#import "RankingTableViewCell.h"

@interface RankingViewController ()

@property (strong, nonatomic) NSArray *rankingModelData;
@property (weak, nonatomic) IBOutlet UILabel *yourScoreLabel;
@property (strong, nonatomic) NSString *currentScore;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *customersList = [UINib nibWithNibName:@"RankingTableViewCell" bundle:Nil];
    [self.myRankingTable registerNib:customersList forCellReuseIdentifier:@"RankingTableViewCell"];
    [self.myRankingTable setDataSource:self];
    //*Look and Feel
    self.myRankingTable.backgroundColor = [UIColor blackColor];
    UIView *emptyCellsSeparatorStyle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    emptyCellsSeparatorStyle.backgroundColor = [UIColor clearColor];
    self.yourScoreLabel.text = self.currentScore;
    self.yourScoreLabel.hidden = [self.currentScore isEqualToString:@""] ? YES : NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameButtonClick:(id)sender {
    if (self.yourScoreLabel.hidden == NO)
        self.yourScoreLabel.hidden = YES;
}

#pragma mark UITable DataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rankingModelData count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSUInteger row = (NSUInteger) indexPath.row;
    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingTableViewCell"
                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    SEL selector = @selector(setRankingUser:andIndex:);
    if([cell respondsToSelector:selector])
    {
        id cellViewModel = [self.rankingModelData objectAtIndex:row];
        [cell setRankingUser:cellViewModel andIndex:row];
    }
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)requestRankingModelData:(NSArray *)modelData andCurrentScore:(NSString *)currentScore {
    self.rankingModelData = modelData;
    self.currentScore = ![currentScore isEqualToString:@"Score:"] ? [NSString stringWithFormat:@"Your %@", currentScore] : @"";
}

@end
