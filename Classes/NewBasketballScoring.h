//
//  NewBasketballScoring.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewBasketballScoring : UIViewController {
	
	UISegmentedControl *topOrBottom;
	IBOutlet UIButton *subUs;
	IBOutlet UIButton *subThem;
	
	
	IBOutlet UIButton *addThem1;
	IBOutlet UIButton *addThem2;
	IBOutlet UIButton *addThem3;
	IBOutlet UIButton *addUs1;
	IBOutlet UIButton *addUs2;
	IBOutlet UIButton *addUs3;
	
	
	
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

	
    IBOutlet UIActivityIndicatorView *activity;
	
}

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIButton *cancelScoringButton;
@property bool isCoord;
@property (nonatomic, retain) NSString *initScoreUs;
@property (nonatomic, retain) NSString *initScoreThem;
@property (nonatomic, retain) NSString *interval;
@property bool createSuccess;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIButton *gameOverButton;

@property bool isGameOver;
@property (nonatomic, retain) UIButton *subUs;
@property (nonatomic, retain) UIButton *subThem;

@property (nonatomic, retain) UIButton *addThem1;
@property (nonatomic, retain) UIButton *addThem2;
@property (nonatomic, retain) UIButton *addThem3;
@property (nonatomic, retain) UIButton *addUs1;
@property (nonatomic, retain) UIButton *addUs2;
@property (nonatomic, retain) UIButton *addUs3;




@property (nonatomic, retain) UIButton *addQuart;
@property (nonatomic, retain) UIButton *subQuart;

@property (nonatomic, retain) UILabel *scoreUs;
@property (nonatomic, retain) UILabel *scoreThem;
@property (nonatomic, retain) UILabel *quarter;
@property (nonatomic, retain) UILabel *labelUs;
@property (nonatomic, retain) UILabel *labelThem;
@property (nonatomic, retain) UILabel *labelQuart;


@property (nonatomic, retain) UISegmentedControl *topOrBottom;

-(IBAction)cancel;
-(IBAction)addU:(id)sender;
-(IBAction)subU;
-(IBAction)addT:(id)sender;
-(IBAction)subT;
-(IBAction)addQ;
-(IBAction)subQ;
-(IBAction)gameOver;
-(void)hideGameScoring;
-(void)showGameScoring;
@end
