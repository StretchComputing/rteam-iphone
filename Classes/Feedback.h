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

}
@property (nonatomic, strong) IBOutlet UIButton *reviewButton;
@property (nonatomic, strong) IBOutlet UIButton *feedbackButton;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;

-(IBAction)feedback;
-(IBAction)review;
@end
