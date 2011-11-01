//
//  SendPoll.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendPoll : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
   
}

@property (nonatomic, strong) NSString *thePollSubject;
@property (nonatomic, strong) NSString *thePollQuestion;
@property (nonatomic, strong) NSArray *recipientObjects;
@property (nonatomic, strong) UIActionSheet *pollActionSheet;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *includeFans;
@property (nonatomic, strong) IBOutlet UISegmentedControl *displayResults;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UITextView *pollQuestion;
@property (nonatomic, strong) IBOutlet UISegmentedControl *pollType;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;
@property (nonatomic, strong) IBOutlet UITextField *pollSubject;
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
