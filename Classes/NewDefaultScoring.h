//
//  NewDefaultScoring.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDefaultScoring : UIViewController {
	
	UISegmentedControl *topOrBottom;
	IBOutlet UIButton *subUs;
	IBOutlet UIButton *subThem;
	
	
	IBOutlet UIButton *addThem;
	
	IBOutlet UIButton *addUs;
	

	IBOutlet UILabel *scoreUs;
	IBOutlet UILabel *labelUs;
	IBOutlet UILabel *scoreThem;
	IBOutlet UILabel *labelThem;
	
	
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

@property (nonatomic, retain) UIButton *addThem;
@property (nonatomic, retain) UIButton *addUs;


@property (nonatomic, retain) UILabel *scoreUs;
@property (nonatomic, retain) UILabel *scoreThem;
@property (nonatomic, retain) UILabel *labelUs;
@property (nonatomic, retain) UILabel *labelThem;


@property (nonatomic, retain) UISegmentedControl *topOrBottom;

-(IBAction)cancel;
-(IBAction)addU;
-(IBAction)subU;
-(IBAction)addT;
-(IBAction)subT;
-(IBAction)gameOver;
-(void)hideGameScoring;
-(void)showGameScoring;
@end
