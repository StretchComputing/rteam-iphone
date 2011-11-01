//
//  NewEvent2.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NewEvent2 : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	
}

@property (nonatomic, strong) NSString *theDescription;
@property (nonatomic, strong) NSString *theLocation;
@property (nonatomic, retain) NSString *theEventName;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UITextField *eventName;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) NSString *teamId;

@property (nonatomic, strong) IBOutlet UITextField *location;
@property (nonatomic, strong) IBOutlet UITextView *description;
@property (nonatomic, strong) NSDate *start;


-(IBAction)createEvent;
-(IBAction)endText;
@end
