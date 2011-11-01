//
//  SettingsTabs.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SettingsTabs : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {
    

}
@property (nonatomic, strong) ADBannerView *myAd;
@property bool displaySuccess;

@property (nonatomic, strong) NSString *fromRegisterFlow;
@property (nonatomic, strong) NSString *didRegister;
@property int numMemberTeams;

@property bool didSynch;
@property bool synchSuccess;
@property bool doneGames;
@property bool doneEvents;
@property (nonatomic, strong) NSArray *allGames;
@property (nonatomic, strong) NSArray *allEvents;
@property (nonatomic, strong) NSMutableArray *gamesAndEvents;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *largeActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property bool haveUserInfo;
@property bool passwordReset;
@property (nonatomic, strong) NSString *passwordResetQuestion;

-(void)getUserInfo;

@end
