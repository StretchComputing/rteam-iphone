//
//  NewGame2.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewGame2 : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    

}
@property (nonatomic, strong) NSString *theDescription;
@property (nonatomic, strong) NSString *theOpponent;
@property (nonatomic, retain) NSString *theDuration;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) NSString *teamId;

@property (nonatomic, strong) IBOutlet UITextField *opponent;
@property (nonatomic, strong) IBOutlet UITextField *duration;
@property (nonatomic, strong) IBOutlet UITextView *description;
@property (nonatomic, strong) NSDate *start;



-(IBAction)createGame;
-(IBAction)endText;
@end
