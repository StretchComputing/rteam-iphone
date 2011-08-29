//
//  TeamSettings.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface Feedback : UIViewController <MFMailComposeViewControllerDelegate>  {

	IBOutlet UILabel *displayLabel;
	IBOutlet UIButton *feedbackButton;
	IBOutlet UIButton *reviewButton;
}
@property (nonatomic, retain) UIButton *reviewButton;
@property (nonatomic, retain) UIButton *feedbackButton;
@property (nonatomic, retain) UILabel *displayLabel;

-(IBAction)feedback;
-(IBAction)review;
@end
