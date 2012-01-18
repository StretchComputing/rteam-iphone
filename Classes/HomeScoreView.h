//
//  HomeScoreView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeScoreView : UIViewController {
    
}
@property (nonatomic, strong) NSString *eventStringDate;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) IBOutlet UIButton *addIntervalButton;
@property (nonatomic, strong) IBOutlet UIButton *subIntervalButton;;

@property (nonatomic, strong) IBOutlet UIButton *addUsButton;
@property (nonatomic, strong) IBOutlet UIButton *addThemButton;
@property (nonatomic, strong) IBOutlet UIButton *subUsButton;
@property (nonatomic, strong) IBOutlet UIButton *subThemButton;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) IBOutlet UIButton *goToButton;
@property (nonatomic, strong) IBOutlet UIButton *scoreButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *sport;


@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UILabel *usLabel;
@property (nonatomic, strong) IBOutlet UILabel *themLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreUsLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreThemLabel;
@property (nonatomic, strong) IBOutlet UILabel *intervalLabel;

@property int initY;
@property bool isFullScreen;
@property bool isKeepingScore;
@property (nonatomic, strong) IBOutlet UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;
-(void)doReset;

-(IBAction)goToPage;
-(IBAction)keepScore;


-(IBAction)addInterval;
-(IBAction)subInterval;
-(IBAction)addUs;
-(IBAction)addThem;
-(IBAction)subUs;
-(IBAction)subThem;

-(void)setNewInterval;


@end
