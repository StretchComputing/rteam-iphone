//
//  FastChangeEventStatus.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FastChangeEventStatus : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
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
	int numRows;
	
	IBOutlet UITextView *noEventsText;
    
	
}
@property (nonatomic, strong) UITextView *noEventsText;

@property int numRows;
@property (nonatomic, strong) UILabel *teamLabel;
@property int currentEventIndex;
@property bool eventsNowSuccess;
@property (nonatomic, strong) UILabel *eventsError;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property int currentInterval;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *rightArrowButton;
@property (nonatomic, strong) UIButton *leftArrowButton;

@property (nonatomic, strong) UILabel *currentEventLabel;

-(NSString *)getEventLabel:(id)event;
-(IBAction)rightArrow;
-(IBAction)leftArrow;
-(IBAction)cancel;
@end
