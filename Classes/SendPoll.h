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
@property (nonatomic, retain) NSArray *recipientObjects;
@property (nonatomic, strong) UIActionSheet *pollActionSheet;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *includeFans;
@property (nonatomic, strong) UISegmentedControl *displayResults;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UITextView *pollQuestion;
@property (nonatomic, strong) UISegmentedControl *pollType;
@property (nonatomic, strong) UILabel *errorMessage;
@property (nonatomic, strong) UITextField *pollSubject;
@property (nonatomic, strong) NSString *teamId;
@property bool createSuccess;

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *origLoc;
@property (nonatomic, strong) NSArray *recipients;
@property bool toTeam;


-(IBAction)sendPoll;
-(IBAction)endText;
@end
