//
//  MatchingGameViewController.m
//  MatchingGame
//
//  Created by Jorge Rebollo on 15/11/15.
//  Copyright © 2015 Jorge Rebollo. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "LogicGame.h"
#import "RankingViewController.h"

@interface MatchingGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) LogicGame *game;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *userViewLabel;
@property (weak, nonatomic) IBOutlet UITextField *userViewTextField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) RankingViewController *rankingView;
@property (strong, nonatomic) NSArray *rankModel;


@end

@implementation MatchingGameViewController

- (IBAction)flipCard:(UIButton *)sender {
    NSUInteger index = [_cardButtons indexOfObject:sender];
    [self.game flipCardAtIndex:index];
    [self updateUI];
    self.highScoresButton.enabled = NO;
}

- (LogicGame *)game {
    if (!_game)
        _game = [[LogicGame alloc] initWithCardCount:_cardButtons.count usingDeck:[[Deck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    for(int index = 0; index<_cardButtons.count; index++) {
        UIButton *button = _cardButtons[index];
        Card *card = [self.game cardAtIndex:index];
        
        button.enabled = card.isPlayable;
        button.selected = card.isFlipped;
        [button setBackgroundImage:[UIImage imageNamed:[card description]] forState:UIControlStateSelected];
        
        button.alpha = card.isPlayable ? 1.0 : 0.7;
    }
    
    [_scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    
    if (self.game.currentScore > 0)
        [self showScoreAnimation];
    if (self.game.pairCount == 8)
        [self showUserInput];
}

- (void)showScoreAnimation {
    UILabel *currentScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIButton *currentButton = [_cardButtons objectAtIndex:self.game.currentIndex];
    CGPoint point = currentButton.frame.origin;
    currentScoreLabel.frame = CGRectMake(point.x, point.y, 100, 40);
    
    currentScoreLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    currentScoreLabel.opaque = NO;
    
    currentScoreLabel.adjustsFontSizeToFitWidth = YES;
    currentScoreLabel.textAlignment = NSTextAlignmentCenter;
    currentScoreLabel.text = [NSString stringWithFormat:@"+ %d UP", self.game.currentScore];
    [_bgView addSubview:currentScoreLabel];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         currentScoreLabel.frame = CGRectMake(point.x,point.y-20,100,40);
                         currentScoreLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [currentScoreLabel removeFromSuperview];
                     }];
    
}

- (void)showUserInput {
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.userView setAlpha:1.0];
                         [self.userViewLabel setAlpha:1.0];
                         [self.userViewTextField setAlpha:1.0];
                         [self.okButton setAlpha:1.0];
                     }
                     completion:^(BOOL finished){}];
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self restartGame];
    self.highScoresButton.enabled = YES;
    return YES;
}

- (void)tapBackground {
    [self.userViewTextField resignFirstResponder];
}

- (void)keyboardWillHideHandler:(NSNotification*)notification {
    [self.userViewTextField resignFirstResponder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userViewTextField resignFirstResponder];
}

- (IBAction)scoresRequests:(id)sender {
    [self requestRankingModel];
    [self performSegueWithIdentifier:@"showRankingTable" sender:sender];
}

- (IBAction)userButton:(id)sender {
    [self restartGame];
    self.highScoresButton.enabled = YES;
}

- (void)hideUserInput {
    [self.userView setAlpha:0.0];
    [self.userViewLabel setAlpha:0.0];
    [self.userViewTextField setAlpha:0.0];
    [self.okButton setAlpha:0.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideUserInput];
    [self.userViewTextField setDelegate:self];
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(tapBackground)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)restartGame {
    if (![self emptyTextfieldValidation]) {
        [self.userViewTextField resignFirstResponder];
        [self storeData];
        [self requestRankingModel];
        [self performSegueWithIdentifier:@"showRankingTable" sender:@""];
        [self clenaGameAndReset];
    }
}

- (BOOL)emptyTextfieldValidation {
    return [self.userViewTextField.text isEqualToString:@""] ? YES: NO;
}

- (void)storeData {
    [self.game requestStoreDataWithUserName:self.userViewTextField.text];
}

- (void)requestRankingModel {
    self.rankModel = [self.game requestToObtainRanking];
}

- (void)clenaGameAndReset {
    self.userViewTextField.text = @"";
    [_scoreLabel setText:@"Score:"];
    [self hideUserInput];
    [self.game resetCounters];
    _game = nil;
    [self game];
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRankingTable"]) {
        self.rankingView = [segue destinationViewController];
        NSString *currentScore = ![self.scoreLabel.text isEqualToString:@"Score:"] ? [NSString stringWithFormat:@" %@",self.scoreLabel.text] : @"Score:";
        [self.rankingView requestRankingModelData:self.rankModel andCurrentScore:currentScore];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
