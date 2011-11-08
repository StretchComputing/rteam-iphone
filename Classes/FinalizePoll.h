//
//  FinalizePoll.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FinalizePoll : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

}
@property (nonatomic, retain) NSString *theFollowUpMessage;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UITextView *followUpMessage;
@property (nonatomic, strong) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *messageThreadId;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;
@property bool createSuccess;

-(IBAction)confirm;
@end
