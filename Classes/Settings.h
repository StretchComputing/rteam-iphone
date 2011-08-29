//
//  Settings.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>


@interface Settings : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate > {

	bool passwordReset;
	NSString *passwordResetQuestion;
	bool haveUserInfo;
	IBOutlet UITableView *myTableView;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	ADBannerView *myAd;
	
	BOOL bannerIsVisible;
    
    IBOutlet UIActivityIndicatorView *largeActivity;
    
    bool doneGames;
    bool doneEvents;
    NSArray *allGames;
    NSArray *allEvents;
    NSMutableArray *gamesAndEvents;
    
    bool didSynch;
    bool synchSuccess;
    
    
    
}
@property bool didSynch;
@property bool synchSuccess;
@property bool doneGames;
@property bool doneEvents;
@property (nonatomic, retain) NSArray *allGames;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSMutableArray *gamesAndEvents;

@property (nonatomic, retain) UIActivityIndicatorView *largeActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property bool haveUserInfo;
@property bool passwordReset;
@property (nonatomic, retain) NSString *passwordResetQuestion;

-(void)getUserInfo;
@end
