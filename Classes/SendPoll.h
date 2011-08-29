//
//  SendPoll.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendPoll : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *doneButton;
	IBOutlet UITextView *pollQuestion;
	IBOutlet UISegmentedControl *pollType;
	IBOutlet UISegmentedControl *displayResults;
	IBOutlet UITextField *pollSubject;
	
	IBOutlet UILabel *errorMessage;
	
	NSString *teamId;
	bool createSuccess;
	bool toTeam;
	
	NSString *eventId;
	NSString *eventType;
	NSString *origLoc;
	NSArray *recipients;
	
	NSString *userRole;
	NSString *includeFans;
	NSString *errorString;
	
	UIActionSheet *pollActionSheet;
}
@property (nonatomic, retain) UIActionSheet *pollActionSheet;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *includeFans;
@property (nonatomic, retain) UISegmentedControl *displayResults;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UITextView *pollQuestion;
@property (nonatomic, retain) UISegmentedControl *pollType;
@property (nonatomic, retain) UILabel *errorMessage;
@property (nonatomic, retain) UITextField *pollSubject;
@property (nonatomic, retain) NSString *teamId;
@property bool createSuccess;

@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *origLoc;
@property (nonatomic, retain) NSArray *recipients;
@property bool toTeam;


-(IBAction)sendPoll;
-(IBAction)endText;
@end
