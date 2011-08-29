//
//  SendPollOptions.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendPollOptions : UIViewController <UIActionSheetDelegate> {

	IBOutlet UITextField *option1;
	IBOutlet UITextField *option2;
	IBOutlet UITextField *option3;
	IBOutlet UITextField *option4;
	IBOutlet UITextField *option5;
	
	IBOutlet UIActivityIndicatorView *action;
	
	IBOutlet UITextView *question;
	
	IBOutlet UILabel *errorMessage;
	
	IBOutlet UIButton *submitButton;
	
	NSString *questionText;
	NSString *teamId;
	bool createSuccess;
	
	NSString *pollSubject;
	
	NSString *eventId;
	NSString *eventType;
	NSString *origLoc;
	NSString *userRole;
	NSArray *recipients;
	NSString *displayResults;
	NSString *errorString;
	bool toTeam;
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *displayResults;
@property bool toTeam;
@property (nonatomic, retain) NSArray *recipients;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;


@property (nonatomic, retain) UITextField *option1;
@property (nonatomic, retain) UITextField *option2;
@property (nonatomic, retain) UITextField *option3;
@property (nonatomic, retain) UITextField *option4;
@property (nonatomic, retain) UITextField *option5;

@property (nonatomic, retain) UIActivityIndicatorView *action;
@property (nonatomic, retain) UITextView *question;
@property (nonatomic, retain) UILabel *errorMessage;
@property (nonatomic, retain) NSString *origLoc;

@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) NSString *questionText;
@property (nonatomic, retain) NSString *teamId;
@property bool createSuccess;
@property (nonatomic, retain) NSString *pollSubject;

-(IBAction)submit;
-(IBAction)endText;
@end
