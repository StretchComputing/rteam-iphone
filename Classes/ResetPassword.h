//
//  ResetPassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResetPassword : UIViewController {
    
	IBOutlet UITextField *email;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *error;
	IBOutlet UIButton *resetButton;
	
	bool hasQuestion;
	bool success;
	
	NSString *question;
	NSString *errorString;
}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *question;
@property bool success;
@property bool hasQuestion;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) UIButton *resetButton;

-(IBAction)reset;
-(IBAction)endText;
@end
