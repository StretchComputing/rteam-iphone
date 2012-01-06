//
//  ReplyEditActivity.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyEditActivity : UIViewController

@property (nonatomic, strong) NSString *originalMessage;
@property bool isReply;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, strong) IBOutlet UITextView *messageText;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIImageView *messageImage;
@property (nonatomic, strong) IBOutlet UIButton *cancelImageButton;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;

-(IBAction)cancelImage;
@end
