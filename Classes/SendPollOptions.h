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
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *displayResults;
@property bool toTeam;
@property (nonatomic, strong) NSArray *recipients;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;


@property (nonatomic, strong) UITextField *option1;
@property (nonatomic, strong) UITextField *option2;
@property (nonatomic, strong) UITextField *option3;
@property (nonatomic, strong) UITextField *option4;
@property (nonatomic, strong) UITextField *option5;

@property (nonatomic, strong) UIActivityIndicatorView *action;
@property (nonatomic, strong) UITextView *question;
@property (nonatomic, strong) UILabel *errorMessage;
@property (nonatomic, strong) NSString *origLoc;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSString *teamId;
@property bool createSuccess;
@property (nonatomic, strong) NSString *pollSubject;

-(IBAction)submit;
-(IBAction)endText;
@end
