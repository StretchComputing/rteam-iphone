//
//  FastRequestStatus.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastRequestStatus : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	IBOutlet UITableView *myTableView;
	IBOutlet UIButton *cancelButton;
	IBOutlet UIButton *rightArrowButton;
	IBOutlet UIButton *leftArrowButton;
	
	IBOutlet UILabel *currentEventLabel;
	
	int currentInterval;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	NSMutableArray *eventsArray;
	
	IBOutlet UILabel *eventsError;
	bool eventsNowSuccess;
	int currentEventIndex;
	
	IBOutlet UILabel *teamLabel;
	
	IBOutlet UILabel *recipLabel;
	IBOutlet UIButton *editRecipButton;
	NSArray *recipients;
	
	NSString *includeFans;
	bool fansOnly;
	bool toTeam;
	
	IBOutlet UITextView *noEventsText;
	
}
@property (nonatomic, retain) UITextView *noEventsText;
@property (nonatomic, retain) NSString *includeFans;
@property bool fansOnly;
@property bool toTeam;
@property (nonatomic, retain) UIButton *editRecipButton;
@property (nonatomic, retain) UILabel *recipLabel;
@property (nonatomic, retain) NSArray *recipients;
@property (nonatomic, retain) UILabel *teamLabel;
@property int currentEventIndex;
@property bool eventsNowSuccess;
@property (nonatomic, retain) UILabel *eventsError;
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property int currentInterval;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *rightArrowButton;
@property (nonatomic, retain) UIButton *leftArrowButton;

@property (nonatomic, retain) UILabel *currentEventLabel;

-(NSString *)getEventLabel:(id)event;
-(IBAction)rightArrow;
-(IBAction)leftArrow;
-(IBAction)cancel;
-(IBAction)editRecipients;
@end

