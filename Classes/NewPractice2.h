//
//  NewPractice2.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewPractice2 : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	
	IBOutlet UIActivityIndicatorView *serverProcess;
	IBOutlet UIButton *submitButton;
	IBOutlet UILabel *error;
	bool createSuccess;
	NSString *teamId;
	
	IBOutlet UITextField *location;
	IBOutlet UITextField *duration;
	IBOutlet UITextView *description;
	NSDate *start;
	
	NSString *errorString;
	
}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) NSString *teamId;

@property (nonatomic, strong) UITextField *location;
@property (nonatomic, strong) UITextField *duration;
@property (nonatomic, strong) UITextView *description;
@property (nonatomic, strong) NSDate *start;


-(IBAction)createPractice;
-(IBAction)endText;
@end

