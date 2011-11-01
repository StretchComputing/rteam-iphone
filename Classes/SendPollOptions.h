//
//  SendPollOptions.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendPollOptions : UIViewController <UIActionSheetDelegate> {

}

@property (nonatomic, strong) NSString *theOption1;
@property (nonatomic, strong) NSString *theOption2;
@property (nonatomic, strong) NSString *theOption3;
@property (nonatomic, strong) NSString *theOption4;
@property (nonatomic, strong) NSString *theOption5;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *displayResults;
@property bool toTeam;
@property (nonatomic, strong) NSArray *recipients;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;


@property (nonatomic, strong) IBOutlet UITextField *option1;
@property (nonatomic, strong) IBOutlet UITextField *option2;
@property (nonatomic, strong) IBOutlet UITextField *option3;
@property (nonatomic, strong) IBOutlet UITextField *option4;
@property (nonatomic, strong) IBOutlet UITextField *option5;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *action;
@property (nonatomic, strong) IBOutlet UITextView *question;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;
@property (nonatomic, strong) NSString *origLoc;

@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSString *teamId;
@property bool createSuccess;
@property (nonatomic, strong) NSString *pollSubject;

-(IBAction)submit;
-(IBAction)endText;
@end
