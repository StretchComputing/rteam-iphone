//
//  MovieTest.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface HelpAbout : UIViewController <ADBannerViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {

	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *feedbackButton;
	
	IBOutlet UILabel *displayLabel;
	
	ADBannerView *myAd;
	BOOL bannerIsVisible;
    bool fromSettings;
	
	IBOutlet UILabel *welcomeLabel;
}
@property bool fromSettings;
@property (nonatomic, retain) UILabel *welcomeLabel;
@property (nonatomic, retain) UILabel *displayLabel;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) UIButton *feedbackButton;
@property (nonatomic, retain) UIScrollView *scrollView;
-(IBAction)playMovie;
-(IBAction)createTeamHelp;
-(IBAction)addMemberHelp;
-(IBAction)addEventHelp;
-(IBAction)fastHelp;
-(IBAction)twitterHelp;
-(IBAction)feedback;
-(IBAction)messageHelp;
@end
