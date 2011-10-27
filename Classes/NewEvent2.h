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
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UITextField *eventName;
@property (nonatomic, strong) UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) NSString *teamId;

@property (nonatomic, strong) UITextField *location;
@property (nonatomic, strong) UITextView *description;
@property (nonatomic, strong) NSDate *start;


-(IBAction)createEvent;
-(IBAction)endText;
@end
