//
//  ResetPassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResetPassword : UIViewController {

}
@property (nonatomic, strong) NSString *theEmail;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *question;
@property bool success;
@property bool hasQuestion;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;

-(IBAction)reset;
-(IBAction)endText;
@end
