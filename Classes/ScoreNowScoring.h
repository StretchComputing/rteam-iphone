//
//  ScoreNowScoring.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreNowScorePage.h"

@class ScoreNowScorePage;

@interface ScoreNowScoring : UIViewController {
	
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
	

	bool createSuccess;
	
	NSString *initScoreUs;
	NSString *initScoreThem;
	NSString *interval;
	
	bool isCoord;
	
	
    
	
	
}
@property (nonatomic, strong) ScoreNowScorePage *myParent;
@property (nonatomic, strong) NSString *theScoreThem;
@property (nonatomic, strong) NSString *theScoreUs;

@property bool isCoord;
@property (nonatomic, strong) NSString *initScoreUs;
@property (nonatomic, strong) NSString *initScoreThem;
@property (nonatomic, strong) NSString *interval;
@property bool createSuccess;

@property (nonatomic, strong) UIButton *gameOverButton;

@property bool isGameOver;
@property (nonatomic, strong) UIButton *subUs;
@property (nonatomic, strong) UIButton *subThem;

@property (nonatomic, strong) UIButton *addThem1;
@property (nonatomic, strong) UIButton *addThem2;
@property (nonatomic, strong) UIButton *addThem3;
@property (nonatomic, strong) UIButton *addUs1;
@property (nonatomic, strong) UIButton *addUs2;
@property (nonatomic, strong) UIButton *addUs3;




@property (nonatomic, strong) UIButton *addQuart;
@property (nonatomic, strong) UIButton *subQuart;

@property (nonatomic, strong) UILabel *scoreUs;
@property (nonatomic, strong) UILabel *scoreThem;
@property (nonatomic, strong) UILabel *quarter;
@property (nonatomic, strong) UILabel *labelUs;
@property (nonatomic, strong) UILabel *labelThem;
@property (nonatomic, strong) UILabel *labelQuart;


@property (nonatomic, strong) UISegmentedControl *topOrBottom;

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