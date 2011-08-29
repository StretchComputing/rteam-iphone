//
//  Scores.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface Scores : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIActionSheetDelegate,
ADBannerViewDelegate> {

	NSString *teamId;
	
	IBOutlet UIScrollView *scroll;
	IBOutlet UITableView *teamTable;
	IBOutlet UITableView *table;
	IBOutlet UIToolbar *bottomBar;
	UIBarButtonItem *filterButton;
	UIBarButtonItem *refreshButton;
	
	NSArray *games;
	NSString *error;
	NSArray *teamList;
	bool haveTeamList;
	
	NSString *sport;
	NSString *teamName;
	
	BOOL bannerIsVisible;
	ADBannerView *myAd;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	IBOutlet UIActivityIndicatorView *refreshActivity;
	
	IBOutlet UIButton *cancelButton;
	
	IBOutlet UIView *insideView;

	
}
@property (nonatomic, retain) UIView *insideView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIActivityIndicatorView *refreshActivity;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSArray *teamList;
@property bool haveTeamList;
@property (nonatomic, retain) UIScrollView  *scroll;
@property (nonatomic, retain) UITableView *teamTable;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIToolbar *bottomBar;
@property (nonatomic, retain) UIBarButtonItem *filterButton;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) NSArray *games;

-(void)getGames;
-(IBAction)closeFilter;
@end
