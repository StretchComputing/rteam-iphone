//
//  ChangePassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChangePassword : UIViewController {
    
}
@property (nonatomic, strong) NSString *thePassword;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *confirmPassword;
@property (nonatomic, strong) IBOutlet UILabel *error;

@property bool changeSuccess;

-(IBAction)submit;
-(IBAction)endText;
@end
