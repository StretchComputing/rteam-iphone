//
//  ChangePassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChangePassword : UIViewController {
    
	IBOutlet UIButton *submitButton;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UITextField *password;
	IBOutlet UITextField *confirmPassword;
	IBOutlet UILabel *error;
	
	bool changeSuccess;
	NSString *errorString;
}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *confirmPassword;
@property (nonatomic, strong) UILabel *error;

@property bool changeSuccess;

-(IBAction)submit;
-(IBAction)endText;
@end
