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
    

}
@property (nonatomic, strong) UIActionSheet *feedbackAction;
@property (nonatomic, strong) ADBannerView *myAd;
@property bool fromSettings;
@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet UIButton *feedbackButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
-(IBAction)playMovie;
-(IBAction)createTeamHelp;
-(IBAction)addMemberHelp;
-(IBAction)addEventHelp;
-(IBAction)fastHelp;
-(IBAction)feedback;
-(IBAction)messageHelp;
@end
