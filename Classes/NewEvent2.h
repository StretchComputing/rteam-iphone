//
//  NewEvent2.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NewEvent2 : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	
	IBOutlet UIActivityIndicatorView *serverProcess;
	IBOutlet UIButton *submitButton;
	IBOutlet UILabel *error;
	bool createSuccess;
	NSString *teamId;
	
	IBOutlet UITextField *location;
	IBOutlet UITextField *eventName;
	IBOutlet UITextView *description;
	NSDate *start;
	
	NSString *errorString;
	
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) IBOutlet UITextField *eventName;
@property (nonatomic, retain) UIActivityIndicatorView *serverProcess;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *error;
@property bool createSuccess;
@property (nonatomic, retain) NSString *teamId;

@property (nonatomic, retain) UITextField *location;
@property (nonatomic, retain) UITextView *description;
@property (nonatomic, retain) NSDate *start;


-(IBAction)createEvent;
-(IBAction)endText;
@end
