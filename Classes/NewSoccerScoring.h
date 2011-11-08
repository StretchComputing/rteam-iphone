//
//  NewSoccerScoring.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSoccerScoring : UIViewController {
	
	UISegmentedControl *topOrBottom;
	IBOutlet UIButton *subUs;
	IBOutlet UIButton *subThem;
	
	
	IBOutlet UIButton *addThem;
    
	IBOutlet UIButton *addUs;
    
	
	
	
	IBOutlet UIButton *addQuart;
	IBOutlet UIButton *subQuart;
	
	IBOutlet UILabel *scoreUs;
	IBOutlet UILabel *labelUs;
	IBOutlet UILabel *scoreThem;
	IBOutlet UILabel *labelThem;
	IBOutlet UILabel *quarter;
	IBOutlet UILabel *labelQuart;
	
	
	bool isGameOver;
	IBOutlet UIButton *gameOverButton;
	
	
	NSString *gameId;
	NSString *teamId;
	bool createSuccess;
	
	NSString *initScoreUs;
	NSString *initScoreThem;
	NSString *interval;
	
	bool isCoord;
	
	IBOutlet UIButton *cancelScoringButton;
	
	IBOutlet UILabel *orHalfLabel;
	
    IBOutlet UIActivityIndicatorView *activity;
	
}
@property (nonatomic, strong) NSString *theScoreThem;
@property (nonatomic, strong) NSString *theScoreUs;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *orHalfLabel;
@property (nonatomic, strong) UIButton *cancelScoringButton;
@property bool isCoord;
@property (nonatomic, strong) NSString *initScoreUs;
@property (nonatomic, strong) NSString *initScoreThem;
@property (nonatomic, strong) NSString *interval;
@property bool createSuccess;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIButton *gameOverButton;

@property bool isGameOver;
@property (nonatomic, strong) UIButton *subUs;
@property (nonatomic, strong) UIButton *subThem;

@property (nonatomic, strong) UIButton *addThem;
@property (nonatomic, strong) UIButton *addUs;





@property (nonatomic, strong) UIButton *addQuart;
@property (nonatomic, strong) UIButton *subQuart;

@property (nonatomic, strong) UILabel *scoreUs;
@property (nonatomic, strong) UILabel *scoreThem;
@property (nonatomic, strong) UILabel *quarter;
@property (nonatomic, strong) UILabel *labelUs;
@property (nonatomic, strong) UILabel *labelThem;
@property (nonatomic, strong) UILabel *labelQuart;


@property (nonatomic, strong) UISegmentedControl *topOrBottom;

-(IBAction)cancel;
-(IBAction)addU;
-(IBAction)subU;
-(IBAction)addT;
-(IBAction)subT;
-(IBAction)addQ;
-(IBAction)subQ;
-(IBAction)gameOver;
-(void)hideGameScoring;
-(void)showGameScoring;
@end
